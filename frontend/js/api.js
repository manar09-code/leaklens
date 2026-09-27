async function runLeakDiagnostic(state) {
    try {
        const response = await fetch(
            "http://127.0.0.1:8000/api/diagnostic",
            {
                method: "POST",
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify({
                    monthly_usage_m3: state.monthly_usage_m3,
                    usage_hours: state.usage_hours,
                    fixture_count: state.fixture_count,
                    primary_fixture: state.primary_fixture
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

    } catch (error) {
        console.error(
            "LEAKLENS diagnostic error:",
            error
        );

        throw new Error(
            "Unable to connect to the diagnostic service. Please try again."
        );
    }
}
