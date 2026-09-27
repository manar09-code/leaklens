"""
Constantes du modèle de détection.
Regroupées ici pour pouvoir les ajuster rapidement pendant le hackathon
sans toucher à la logique métier.
"""

# Consommation "normale" attendue par point d'eau (m3/mois).
# Valeur de départ pour un foyer domestique moyen.
BASE_USAGE_PER_FIXTURE_M3 = 1.6

# En dessous de ce seuil de confiance, on considère qu'il n'y a pas de fuite.
LEAK_CONFIDENCE_THRESHOLD = 55

# Prix moyen de l'eau (DT / m3) — SONEDE, à ajuster selon tranche réelle si besoin.
WATER_PRICE_DT_PER_M3 = 0.6

# Poids de chaque facteur dans le score d'anomalie (doivent sommer ~1.0)
WEIGHT_EXCESS_RATIO = 0.65
WEIGHT_NIGHT_USAGE = 0.25
WEIGHT_SINGLE_FIXTURE = 0.10

# Fixtures qui "consomment naturellement" en continu (jardin, piscine) :
# on relâche un peu la suspicion pour eux.
HIGH_LEGITIMATE_USAGE_FIXTURES = {"garden", "pool"}
