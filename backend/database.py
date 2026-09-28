import os
import socket

from dotenv import load_dotenv
from pymongo import MongoClient
from bson import ObjectId

load_dotenv()

MONGODB_URI = os.getenv("MONGODB_URI")
MONGODB_DATABASE = os.getenv("MONGODB_DATABASE", "leaklens")

client = None
db = None

if MONGODB_URI:
    _original_getaddrinfo = socket.getaddrinfo

    def _mongodb_ipv4_getaddrinfo(
        host,
        port,
        family=0,
        type=0,
        proto=0,
        flags=0
    ):
        if (
            isinstance(host, str)
            and host.endswith("mongodb.net")
        ):
            return _original_getaddrinfo(
                host,
                port,
                socket.AF_INET,
                type,
                proto,
                flags
            )

        return _original_getaddrinfo(
            host,
            port,
            family,
            type,
            proto,
            flags
        )

    socket.getaddrinfo = _mongodb_ipv4_getaddrinfo

    client = MongoClient(
        MONGODB_URI,
        serverSelectionTimeoutMS=5000,
    )

    db = client[MONGODB_DATABASE]


def check_mongodb_connection() -> bool:
    if client is None:
        return False

    client.admin.command("ping")
    return True


def save_diagnostic(data: dict) -> str:
    if db is None:
        return ""

    result = db.diagnostics.insert_one(data)
    return str(result.inserted_id)


def get_diagnostic(diagnostic_id: str):
    if db is None:
        return None

    document = db.diagnostics.find_one(
        {"_id": ObjectId(diagnostic_id)}
    )

    if document is None:
        return None

    document["_id"] = str(document["_id"])
    return document
