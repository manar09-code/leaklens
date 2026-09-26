async function runLeakDiagnostic(state) {
    // Temporary mock API.
    // Later, this function will call the real backend.

    await new Promise(function (resolve) {
        setTimeout(resolve, 800);
    });

    const usage = Number(state.monthly_usage_m3) || 20;
    const fixture = state.primary_fixture || "shower";

    // Simple mock calculation for the demo
    const estimatedWaste = Math.max(
        8,
        Math.round(usage * 0.45)
    );

    const monthlyCost = Math.round(
        estimatedWaste * 30 * 0.05
    );

    const confidence = Math.min(
        97,
        Math.max(
            72,
            Math.round(70 + usage * 0.5)
        )
    );

    return {
        leak_detected: true,
        confidence: confidence,
        estimated_waste_liters_per_day: estimatedWaste,
        estimated_monthly_cost_dt: monthlyCost,
        suspected_fixture: fixture,
        explanation:
            "Your consumption pattern is higher than expected for the reported usage profile. The anomaly is consistent with a possible hidden leak."
    };
}