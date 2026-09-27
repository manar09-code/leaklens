from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware

from app.schemas import DiagnosticRequest, DiagnosticResponse
from app.logic import diagnose
from database import save_diagnostic

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


@app.post("/api/diagnostic", response_model=DiagnosticResponse)
def run_diagnostic(payload: DiagnosticRequest):
    try:
        result = diagnose(payload)

        diagnostic_document = {
            "input": payload.model_dump(),
            "result": result.model_dump(),
        }

        save_diagnostic(diagnostic_document)

        return result

    except Exception as exc:
        raise HTTPException(
            status_code=500,
            detail=f"Erreur de diagnostic: {exc}"
        )