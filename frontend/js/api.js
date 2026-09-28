/*
 * LEAKLENS frontend API integration.
 *
 * GitHub Pages is a static host, so the real FastAPI backend must be
 * deployed separately. Set window.LEAKLENS_API_BASE_URL to that public
 * backend URL when it is available.
 *
 * Until then, the browser uses the same deterministic MVP heuristic
 * locally so the public demo remains functional.
 */

const LEAKLENS_API_BASE_URL = (
    window.LEAKLENS_API_BASE_URL || "https://leaklens-api-a7pi.onrender.com"
).replace(/\/$/, "");


function clamp(value, min = 0, max = 100) {
    return Math.max(min, Math.min(max, value));
}


function computeExpectedUsage(fixtureCount, primaryFixture = "") {
    let expected = fixtureCount * 1.6;

    if (
        primaryFixture === "garden" ||
        primaryFixture === "pool"
    ) {
        expected *= 4.0;
    }

    return expected;
}


function computeExcessRatio(actual, expected) {
    if (expected <= 0) {
        return 0;
    }

    return Math.max(
        0,
        (actual - expected) / expected
    );
}


function computeNightSignal(
    usageHours,
    primaryFixture = ""
) {
    if (
        primaryFixture === "garden" ||
        primaryFixture === "pool"
    ) {
        return 0;
    }

    return usageHours.includes("night")
        ? 1
        : 0;
}


function computeSingleFixtureSignal(
    usageHours,
    primaryFixture
) {
    if (
        primaryFixture === "garden" ||
        primaryFixture === "pool"
    ) {
        return 0;
    }

    return usageHours.length <= 2
        ? 1
        : 0.3;
}


function buildLocalExplanation(
    leakDetected,
    excessRatio,
    nightSignal,
    fixtureSignal,
    state
) {
    if (!leakDetected) {
        return (
            "La consommation observée reste cohérente avec un usage normal " +
            "pour ce nombre de points d'eau. Aucune anomalie significative détectée."
        );
    }

    const reasons = [];

    if (excessRatio > 0.3) {
        reasons.push(
            "une consommation nettement supérieure à la normale attendue"
        );
    }

    if (nightSignal) {
        reasons.push(
            "une utilisation d'eau détectée pendant la nuit, " +
            "quand l'usage devrait être minimal"
        );
    }

    if (fixtureSignal >= 1.0) {
        reasons.push(
            "une concentration de la consommation sur un seul poste " +
            "(\"" + state.primary_fixture + "\")"
        );
    }

    if (reasons.length === 0) {
        reasons.push(
            "un profil de consommation légèrement inhabituel"
        );
    }

    return (
        "Fuite possible détectée : le système observe " +
        reasons.join(", ") +
        ". Cette estimation est une probabilité, pas une certitude. " +
        "Une vérification manuelle peut confirmer le diagnostic."
    );
}


function runLocalDiagnostic(state) {
    const monthlyUsage =
        Number(state.monthly_usage_m3) || 0;

    const usageHours =
        Array.isArray(state.usage_hours)
            ? state.usage_hours
            : [];

    const fixtureCount =
        Math.max(
            1,
            Number(state.fixture_count) || 1
        );

    const primaryFixture =
        state.primary_fixture || "";

    const expected =
        computeExpectedUsage(
            fixtureCount,
            primaryFixture
        );

    const excessRatio =
        computeExcessRatio(
            monthlyUsage,
            expected
        );

    const nightSignal =
        computeNightSignal(
            usageHours,
            primaryFixture
        );

    const fixtureSignal =
        computeSingleFixtureSignal(
            usageHours,
            primaryFixture
        );

    const rawScore =
        0.65 *
            Math.min(excessRatio, 1.5) / 1.5 * 100 +
        0.25 *
            nightSignal * 100 +
        0.10 *
            fixtureSignal * 100;

    const confidence =
        Math.round(
            clamp(rawScore)
        );

    const leakDetected =
        confidence >= 55;

    const excessM3 =
        Math.max(
            0,
            monthlyUsage - expected
        );

    const estimatedWaste =
        leakDetected
            ? Math.round(
                (excessM3 * 1000 / 30) * 10
            ) / 10
            : 0;

    const estimatedCost =
        leakDetected
            ? Math.round(
                excessM3 * 0.6 * 100
            ) / 100
            : 0;

    return {
        leak_detected: leakDetected,
        confidence: confidence,
        estimated_waste_liters_per_day: estimatedWaste,
        estimated_monthly_cost_dt: estimatedCost,
        suspected_fixture:
            leakDetected
                ? primaryFixture || null
                : null,
        explanation: buildLocalExplanation(
            leakDetected,
            excessRatio,
            nightSignal,
            fixtureSignal,
            {
                ...state,
                primary_fixture: primaryFixture
            }
        )
    };
}


async function runRemoteDiagnostic(state) {
    const response = await fetch(
        LEAKLENS_API_BASE_URL + "/api/diagnostic",
        {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({
                monthly_usage_m3:
                    Number(state.monthly_usage_m3) || 0,
                usage_hours:
                    Array.isArray(state.usage_hours)
                        ? state.usage_hours
                        : [],
                fixture_count:
                    Math.max(
                        1,
                        Number(state.fixture_count) || 1
                    ),
                primary_fixture:
                    state.primary_fixture || ""
            })
        }
    );

    if (!response.ok) {
        throw new Error(
            "Backend diagnostic request failed: " +
            response.status
        );
    }

    return await response.json();
}


async function runLeakDiagnostic(state) {
    /*
     * Prefer the real FastAPI backend when a public URL is configured.
     * If it is unavailable during the demo, fall back to the exact MVP
     * heuristic locally so the user journey does not break.
     */
    if (LEAKLENS_API_BASE_URL) {
        try {
            return await runRemoteDiagnostic(state);
        } catch (error) {
            console.warn(
                "Public LEAKLENS API unavailable. Using local diagnostic fallback.",
                error
            );
        }
    }

    return runLocalDiagnostic(state);
}
