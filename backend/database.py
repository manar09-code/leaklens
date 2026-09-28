import os
import socket
import hashlib
import secrets
from datetime import datetime, timezone

from dotenv import load_dotenv
from pymongo import MongoClient
from bson import ObjectId

load_dotenv()

MONGODB_URI = os.getenv("MONGODB_URI")
MONGODB_DATABASE = os.getenv("MONGODB_DATABASE", "leaklens")

client = None
db = None

# Demo-safe fallback used only when MongoDB cannot be reached.
_memory_users = {}

if MONGODB_URI:
    _original_getaddrinfo = socket.getaddrinfo

    def _mongodb_ipv4_getaddrinfo(host, port, family=0, type=0, proto=0, flags=0):
        if isinstance(host, str) and host.endswith("mongodb.net"):
            return _original_getaddrinfo(host, port, socket.AF_INET, type, proto, flags)
        return _original_getaddrinfo(host, port, family, type, proto, flags)

    socket.getaddrinfo = _mongodb_ipv4_getaddrinfo
    client = MongoClient(MONGODB_URI, serverSelectionTimeoutMS=5000)
    db = client[MONGODB_DATABASE]

def check_mongodb_connection() -> bool:
    if client is None: return False
    try:
        client.admin.command("ping")
        return True
    except Exception:
        return False

def _hash_password(password: str, salt: str | None = None) -> str:
    salt = salt or secrets.token_hex(16)
    derived = hashlib.pbkdf2_hmac("sha256", password.encode("utf-8"), bytes.fromhex(salt), 310000)
    return f"pbkdf2_sha256$310000${salt}${derived.hex()}"

def _verify_password(password: str, encoded: str) -> bool:
    try:
        algorithm, iterations, salt, expected = encoded.split("$", 3)
        if algorithm != "pbkdf2_sha256": return False
        derived = hashlib.pbkdf2_hmac("sha256", password.encode("utf-8"), bytes.fromhex(salt), int(iterations))
        return secrets.compare_digest(derived.hex(), expected)
    except (ValueError, TypeError):
        return False

def _memory_create_user(email: str, password: str):
    if email in _memory_users: raise ValueError("An account with this email already exists.")
    token = secrets.token_urlsafe(32)
    user_id = secrets.token_hex(12)
    _memory_users[email] = {"user_id": user_id, "email": email, "password_hash": _hash_password(password), "session_token": token, "created_at": datetime.now(timezone.utc)}
    return {"user_id": user_id, "email": email, "token": token}

def _memory_authenticate_user(email: str, password: str):
    user = _memory_users.get(email)
    if user is None or not _verify_password(password, user.get("password_hash", "")): return None
    token = secrets.token_urlsafe(32)
    user["session_token"] = token
    return {"user_id": user["user_id"], "email": email, "token": token}

def create_user(email: str, password: str):
    email = email.strip().lower()
    if db is None: return _memory_create_user(email, password)
    try:
        db.users.create_index("email", unique=True)
        if db.users.find_one({"email": email}) is not None: raise ValueError("An account with this email already exists.")
        token = secrets.token_urlsafe(32)
        result = db.users.insert_one({"email": email, "password_hash": _hash_password(password), "session_token": token, "created_at": datetime.now(timezone.utc)})
        return {"user_id": str(result.inserted_id), "email": email, "token": token}
    except ValueError:
        raise
    except Exception as exc:
        print(f"MongoDB signup warning: {exc}")
        return _memory_create_user(email, password)

def authenticate_user(email: str, password: str):
    email = email.strip().lower()
    if db is None: return _memory_authenticate_user(email, password)
    try:
        user = db.users.find_one({"email": email})
        if user is None or not _verify_password(password, user.get("password_hash", "")): return None
        token = secrets.token_urlsafe(32)
        db.users.update_one({"_id": user["_id"]}, {"$set": {"session_token": token, "last_login_at": datetime.now(timezone.utc)}})
        return {"user_id": str(user["_id"]), "email": email, "token": token}
    except Exception as exc:
        print(f"MongoDB login warning: {exc}")
        return _memory_authenticate_user(email, password)

def get_user_by_token(token: str):
    if not token: return None
    try:
        if db is not None:
            user = db.users.find_one({"session_token": token})
            if user is not None: return {"user_id": str(user["_id"]), "email": user["email"]}
    except Exception as exc:
        print(f"MongoDB token lookup warning: {exc}")
    for user in _memory_users.values():
        if user.get("session_token") == token: return {"user_id": user["user_id"], "email": user["email"]}
    return None

def save_diagnostic(data: dict, user_id: str | None = None) -> str:
    if db is None: return ""
    document = dict(data)
    if user_id: document["user_id"] = user_id
    document["created_at"] = datetime.now(timezone.utc)
    try:
        result = db.diagnostics.insert_one(document)
        return str(result.inserted_id)
    except Exception as exc:
        print(f"MongoDB diagnostic persistence warning: {exc}")
        return ""

def get_diagnostic(diagnostic_id: str):
    if db is None: return None
    try:
        document = db.diagnostics.find_one({"_id": ObjectId(diagnostic_id)})
    except Exception as exc:
        print(f"MongoDB diagnostic lookup warning: {exc}")
        return None
    if document is None: return None
    document["_id"] = str(document["_id"])
    return document