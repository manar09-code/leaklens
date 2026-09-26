const LEAKLENS_STATE = {
    monthly_usage_m3: 20,
    usage_hours: ["morning", "evening"],
    fixture_count: 6,
    primary_fixture: ""
};

function saveState() {
    localStorage.setItem(
        "leaklens_state",
        JSON.stringify(LEAKLENS_STATE)
    );
}

function loadState() {
    const saved = localStorage.getItem("leaklens_state");

    if (saved) {
        try {
            Object.assign(
                LEAKLENS_STATE,
                JSON.parse(saved)
            );
        } catch (error) {
            console.error(
                "Could not load saved LEAKLENS state:",
                error
            );
        }
    }

    return LEAKLENS_STATE;
}