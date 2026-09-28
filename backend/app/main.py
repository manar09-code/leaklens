from fastapi import FastAPI, Header, HTTPException
from fastapi.middleware.cors import CORSMiddleware

from app.schemas import DiagnosticRequest, DiagnosticResponse
from app.logic import diagnose
from database import save_diagnostic, create_user, authenticate_user, get_user_by_token

app = FastAPI(
    title="LEAKLENS API",
    description=(
        "Détection de fuites d'eau cachées via analyse de consommation.\n\n"
        "MVP actuel : système à règles / heuristique (score composite pondéré), "
        "pas un modèle de machine learning entraîné. Voir app/logic.py."
    ),
    version="0.1.0",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/")
def root():
    return {"status": "ok", "service": "LEAKLENS API"}


@app.get("/health")
def health():
    return {"status": "healthy"}


@app.post("/api/auth/signup")
def signup(payload: dict):
    email = str(payload.get("email", "")).strip().lower()
    password = str(payload.get("password", ""))
    if "@" not in email or len(password) < 6:
        raise HTTPException(status_code=400, detail="Valid email and password (6+ characters) are required.")
    try:
        result = create_user(email, password)
    except ValueError as exc:
        raise HTTPException(status_code=409, detail=str(exc))
    if result is None:
        raise HTTPException(status_code=503, detail="Database is not configured.")
    return result


@app.post("/api/auth/login")
def login(payload: dict):
    email = str(payload.get("email", "")).strip().lower()
    password = str(payload.get("password", ""))
    result = authenticate_user(email, password)
    if result is None:
        raise HTTPException(status_code=401, detail="Invalid email or password.")
    return result


@app.post("/api/diagnostic", response_model=DiagnosticResponse)

def run_diagnostic(
    payload: DiagnosticRequest,
    authorization: str | None = Header(default=None),
):
    result = diagnose(payload)

    diagnostic_document = {
        "input": payload.model_dump(),
        "result": result.model_dump(),
    }

    try:
        token = authorization.removeprefix("Bearer ").strip() if authorization else ""
        user = get_user_by_token(token) if token else None
        save_diagnostic(
            diagnostic_document,
            user_id=user["user_id"] if user else None,
        )
    except Exception as exc:
        print(f"MongoDB persistence warning: {exc}")

    return result