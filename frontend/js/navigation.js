document.addEventListener("DOMContentLoaded", function () {
    const currentPage = window.location.pathname.split("/").pop();

    // Authentication page
    if (currentPage === "login.html" || currentPage === "") {
        const loginTab = document.getElementById("tab-login");
        const signupTab = document.getElementById("tab-signup");
        const loginForm = document.querySelector("form");
        const createAccountLink = document.getElementById("create-account-link");
        const submitLabel = document.getElementById("auth-submit-label");

        let mode = "login";

        function setMode(nextMode) {
            mode = nextMode;

            const isLogin = mode === "login";

            if (loginTab) {
                loginTab.classList.toggle("bg-white", isLogin);
                loginTab.classList.toggle("text-brand-600", isLogin);
                loginTab.classList.toggle("shadow-sm", isLogin);
                loginTab.classList.toggle("text-slate-500", !isLogin);
            }

            if (signupTab) {
                signupTab.classList.toggle("bg-white", !isLogin);
                signupTab.classList.toggle("text-brand-600", !isLogin);
                signupTab.classList.toggle("shadow-sm", !isLogin);
                signupTab.classList.toggle("text-slate-500", isLogin);
            }

            if (submitLabel) {
                submitLabel.textContent = isLogin
                    ? "Log In"
                    : "Create Account";
            }

            if (loginForm) {
                loginForm.dataset.mode = mode;
            }
        }

        if (loginTab) {
            loginTab.addEventListener("click", function () {
                setMode("login");
            });
        }

        if (signupTab) {
            signupTab.addEventListener("click", function () {
                setMode("signup");
            });
        }

        if (createAccountLink) {
            createAccountLink.addEventListener("click", function (event) {
                event.preventDefault();
                setMode("signup");
                loginForm?.querySelector('input[type="email"]')?.focus();
            });
        }

        if (loginForm) {
            loginForm.addEventListener("submit", async function (event) {
                event.preventDefault();

                const email = loginForm.querySelector('input[type="email"]')?.value.trim() || "";
                const password = loginForm.querySelector('input[type="password"]')?.value || "";

                if (!email || !password) {
                    alert("Please enter your email and password.");
                    return;
                }

                try {
                    if (mode === "signup") {
                        await signupUser(email, password);

                        // Signup creates the account, then deliberately returns
                        // to the login state so the user can authenticate normally.
                        localStorage.removeItem("leaklens_auth");
                        setMode("login");

                        const passwordInput =
                            loginForm.querySelector('input[type="password"]');
                        if (passwordInput) passwordInput.value = "";

                        alert("Account created successfully. Please log in.");
                        return;
                    }

                    await loginUser(email, password);
                    window.location.href = "usage.html";
                } catch (error) {
                    alert(error.message || "Something went wrong.");
                }
            });
        }

        setMode("login");
    }

    // Profile / settings navigation on authenticated pages.
    document.querySelectorAll("[data-profile-button]").forEach(function (button) {
        button.addEventListener("click", function () {
            window.location.href = "settings.html";
        });
    });
});
