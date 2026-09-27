"""
Logique de détection d'anomalie / fuite — LEAKLENS MVP.

Approche : système à RÈGLES / HEURISTIQUE (scoring composite pondéré
sur plusieurs signaux mesurables), PAS un modèle de machine learning
entraîné. C'est un choix assumé pour ce MVP :
- déterministe et rapide à valider/déboguer,
- entièrement explicable aux utilisateurs et aux juges,
- fiable sans données d'entraînement réelles.

Cette fonction a une signature stable (DiagnosticRequest -> DiagnosticResponse)
afin de pouvoir être remplacée plus tard par un vrai modèle (ex: isolation
forest) sans changer le contrat d'API, si et quand ce choix est validé.
Tant que ce n'est pas fait, ne rien présenter comme "ML" dans le pitch.
"""

from app.schemas import DiagnosticRequest, DiagnosticResponse
from app.config import (
    BASE_USAGE_PER_FIXTURE_M3,
    LEAK_CONFIDENCE_THRESHOLD,
    WATER_PRICE_DT_PER_M3,
    WEIGHT_EXCESS_RATIO,
    WEIGHT_NIGHT_USAGE,
    WEIGHT_SINGLE_FIXTURE,
    HIGH_LEGITIMATE_USAGE_FIXTURES,
)


def _clamp(value: float, low: float = 0.0, high: float = 100.0) -> float:
    return max(low, min(high, value))


def compute_expected_usage(fixture_count: int, primary_fixture: str = "") -> float:
    """
    Consommation mensuelle attendue (m3) pour un foyer donné.

    Les usages légitimement variables (jardin, piscine) ont une base
    de référence plus large : leur consommation naturelle fluctue
    beaucoup plus qu'un usage domestique classique (douche, cuisine...),
    donc on ne peut pas les juger avec le même seuil sans provoquer
    des faux positifs.
    """
    base = fixture_count * BASE_USAGE_PER_FIXTURE_M3
    if primary_fixture in HIGH_LEGITIMATE_USAGE_FIXTURES:
        base *= 4.0
    return base


def compute_excess_ratio(actual: float, expected: float) -> float:
    """
    Ratio de dépassement, normalisé.
    0   = consommation normale ou en dessous
    1   = consommation ~2x la normale (fort signal)
    >1  = très fortement anormal
    """
    if expected <= 0:
        return 0.0
    excess = (actual - expected) / expected
    return max(0.0, excess)


def compute_night_signal(usage_hours: list[str], primary_fixture: str = "") -> float:
    """
    Une consommation continue la nuit est un signal classique de fuite
    (personne n'utilise l'eau activement, donc l'eau qui coule = suspect).

    Exception volontaire : pour les usages légitimement variables
    (jardin, piscine), l'arrosage automatique nocturne est une pratique
    normale et recommandée (évaporation plus faible) -> on ne compte
    pas ce signal comme suspect pour ces fixtures.
    """
    if primary_fixture in HIGH_LEGITIMATE_USAGE_FIXTURES:
        return 0.0
    return 1.0 if "night" in usage_hours else 0.0


def compute_single_fixture_signal(usage_hours: list[str], primary_fixture: str) -> float:
    """
    Si un seul poste (ex: douche) concentre la conso ET que l'usage est
    limité à peu de créneaux horaires déclarés, ça renforce l'hypothèse
    d'une fuite localisée plutôt qu'un usage familial diffus.
    """
    if primary_fixture in HIGH_LEGITIMATE_USAGE_FIXTURES:
        return 0.0
    return 1.0 if len(usage_hours) <= 2 else 0.3


def diagnose(payload: DiagnosticRequest) -> DiagnosticResponse:
    expected = compute_expected_usage(payload.fixture_count, payload.primary_fixture)
    excess_ratio = compute_excess_ratio(payload.monthly_usage_m3, expected)
    night_signal = compute_night_signal(payload.usage_hours, payload.primary_fixture)
    fixture_signal = compute_single_fixture_signal(payload.usage_hours, payload.primary_fixture)

    # Score composite 0-100
    raw_score = (
        WEIGHT_EXCESS_RATIO * min(excess_ratio, 1.5) / 1.5 * 100
        + WEIGHT_NIGHT_USAGE * night_signal * 100
        + WEIGHT_SINGLE_FIXTURE * fixture_signal * 100
    )
    confidence = int(round(_clamp(raw_score)))

    leak_detected = confidence >= LEAK_CONFIDENCE_THRESHOLD

    # Eau gaspillée estimée = uniquement la partie "excès" de la conso
    excess_m3 = max(0.0, payload.monthly_usage_m3 - expected)
    estimated_waste_liters_per_day = round((excess_m3 * 1000) / 30, 1) if leak_detected else 0.0
    estimated_monthly_cost_dt = round(excess_m3 * WATER_PRICE_DT_PER_M3, 2) if leak_detected else 0.0

    suspected_fixture = payload.primary_fixture if leak_detected else None

    explanation = _build_explanation(
        leak_detected, excess_ratio, night_signal, fixture_signal, payload
    )

    return DiagnosticResponse(
        leak_detected=leak_detected,
        confidence=confidence,
        estimated_waste_liters_per_day=estimated_waste_liters_per_day,
        estimated_monthly_cost_dt=estimated_monthly_cost_dt,
        suspected_fixture=suspected_fixture,
        explanation=explanation,
    )


def _build_explanation(leak_detected, excess_ratio, night_signal, fixture_signal, payload) -> str:
    if not leak_detected:
        return (
            "La consommation observée reste cohérente avec un usage normal "
            "pour ce nombre de points d'eau. Aucune anomalie significative détectée."
        )

    reasons = []
    if excess_ratio > 0.3:
        reasons.append("une consommation nettement supérieure à la normale attendue")
    if night_signal:
        reasons.append("une utilisation d'eau détectée pendant la nuit, quand l'usage devrait être minimal")
    if fixture_signal >= 1.0:
        reasons.append(f"une concentration de la consommation sur un seul poste ('{payload.primary_fixture}')")

    if not reasons:
        reasons.append("un profil de consommation légèrement inhabituel")

    return (
        "Fuite possible détectée : le système observe " + ", ".join(reasons) + ". "
        "Cette estimation est une probabilité, pas une certitude — Cette estimation"
        "est une probabilité, pas une certitude — une vérification manuelle peut confirmer le diagnostic."
    )
