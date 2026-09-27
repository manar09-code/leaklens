"""
LEAKLENS backend — API FastAPI.

Lancer en local :
    uvicorn app.main:app --reload --port 8000

Documentation interactive auto-générée :
    http://localhost:8000/docs
"""

from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware

from app.schemas import DiagnosticRequest, DiagnosticResponse
from app.logic import diagnose

app = FastAPI(
    title="LEAKLENS API",
    description=(
        "Détection de fuites d'eau cachées via analyse de consommation.\n\n"
        "MVP actuel : système à règles / heuristique (score composite pondéré), "
        "pas un modèle de machine learning entraîné. Voir app/logic.py."
    ),
    version="0.1.0",
)

# CORS ouvert pour le hackathon : le frontend web ET l'app Flutter
# doivent pouvoir appeler l'API depuis n'importe quelle origine.
# A restreindre en production.
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
        return diagnose(payload)
    except Exception as exc:
        # En hackathon on préfère un message clair côté frontend
        # plutôt qu'un crash silencieux.
        raise HTTPException(status_code=500, detail=f"Erreur de diagnostic: {exc}")
