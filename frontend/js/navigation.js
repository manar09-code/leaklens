document.addEventListener("DOMContentLoaded", function () {
    const currentPage = window.location.pathname.split("/").pop();

    if (currentPage === "login.html" || currentPage === "") {
        const loginTab = document.getElementById("tab-login");
        const signupTab = document.getElementById("tab-signup");
        const loginForm = document.querySelector("form");
        const createAccountLink = document.querySelector(
            'a[href="#"]'
        );

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

                // Authentication is not implemented in the MVP.
                // Both tabs can enter the application flow.
            });
        }

        // Login button enters the LEAKLENS questionnaire.
        if (loginForm) {
            loginForm.addEventListener("submit", function (event) {
                event.preventDefault();
                window.location.href = "usage.html";
            });
        }

        // "Create an account" also enters the application flow.
        if (createAccountLink) {
            createAccountLink.addEventListener("click", function (event) {
                event.preventDefault();
                window.location.href = "usage.html";
            });
        }
    }
});
