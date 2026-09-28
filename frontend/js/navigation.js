document.addEventListener("DOMContentLoaded", function () {
    const currentPage = window.location.pathname.split("/").pop();

    if (currentPage === "login.html" || currentPage === "") {
        const loginTab = document.getElementById("tab-login");
        const signupTab = document.getElementById("tab-signup");
        const loginForm = document.querySelector("form");
        const createAccountLink = document.querySelector(
            'a[href="#"]'
        );
        const submitLabel = document.getElementById("auth-submit-label");

        // Login tab
        if (loginTab) {
            loginTab.addEventListener("click", function () {
                loginTab.classList.add(
                    "bg-white",
                    "text-brand-600",
                    "shadow-sm"
                );

                loginTab.classList.remove(
                    "text-slate-500"
                );

                if (signupTab) {
                    signupTab.classList.remove(
                        "bg-white",
                        "text-brand-600",
                        "shadow-sm"
                    );

                    signupTab.classList.add(
                        "text-slate-500"
                    );
                }
            });
        }

        // Sign Up tab
        if (signupTab) {
            signupTab.addEventListener("click", function () {
                signupTab.classList.add(
                    "bg-white",
                    "text-brand-600",
                    "shadow-sm"
                );

                signupTab.classList.remove(
                    "text-slate-500"
                );

                if (loginTab) {
                    loginTab.classList.remove(
                        "bg-white",
                        "text-brand-600",
                        "shadow-sm"
                    );

                    loginTab.classList.add(
                        "text-slate-500"
                    );
                }

                if (submitLabel) {
                    submitLabel.textContent = "Create Account";
                }
            });
        }

        let mode = "login";

        if (loginTab) {
            loginTab.addEventListener("click", function () {
                mode = "login";
                if (submitLabel) submitLabel.textContent = "Log In";
            });
        }

        if (signupTab) {
            signupTab.addEventListener("click", function () {
                mode = "signup";
                if (submitLabel) submitLabel.textContent = "Create Account";
            });
        }

        if (loginForm) {
            loginForm.addEventListener("submit", async function (event) {
                event.preventDefault();

                const inputs = loginForm.querySelectorAll("input");
                const email = inputs[0]?.value.trim();
                const password = inputs[1]?.value || "";

                if (!email || !password) {
                    alert("Please enter your email and password.");
                    return;
                }

                try {
                    if (mode === "signup") {
                        await signupUser(email, password);
                    } else {
                        await loginUser(email, password);
                    }
                    window.location.href = "usage.html";
                } catch (error) {
                    alert(error.message);
                }
            });
        }

        if (createAccountLink) {
            createAccountLink.addEventListener("click", function (event) {
                event.preventDefault();
                if (signupTab) signupTab.click();
                loginForm?.querySelector("input")?.focus();
            });
        }
    }
});


// Profile / settings navigation available on all authenticated screens.
document.addEventListener("DOMContentLoaded", function () {
    document.querySelectorAll("[data-profile-button]").forEach(function (button) {
        button.addEventListener("click", function () {
            window.location.href = "settings.html";
        });
    });
});
