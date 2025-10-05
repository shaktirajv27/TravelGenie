// Authentication JavaScript
document.addEventListener("DOMContentLoaded", function () {
  initializeAuthForms();
  setupPasswordValidation();
});

function initializeAuthForms() {
  const loginForm = document.getElementById("loginForm");
  const registerForm = document.getElementById("registerForm");

  if (loginForm) {
    loginForm.addEventListener("submit", handleLogin);
    setupFormValidation(loginForm);
  }

  if (registerForm) {
    registerForm.addEventListener("submit", handleRegister);
    setupFormValidation(registerForm);
    setupPasswordStrengthMeter();
  }

  // Social login buttons
  setupSocialLogin();
}

async function handleLogin(e) {
  e.preventDefault();

  const form = e.target;
  const formData = new FormData(form);
  const submitButton = form.querySelector('button[type="submit"]');

  // Disable submit button
  submitButton.disabled = true;
  submitButton.innerHTML =
    '<i class="fas fa-spinner fa-spin"></i> Signing In...';

  try {
    const response = await fetch("php/auth.php", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        action: "login",
        email: formData.get("email"),
        password: formData.get("password"),
      }),
    });

    const result = await response.json();

    if (result.success) {
      showNotification("Login successful! Redirecting...", "success");

      // Redirect to dashboard or back to home
      setTimeout(() => {
        const urlParams = new URLSearchParams(window.location.search);
        const redirectTo = urlParams.get("redirect") || "dashboard.html";
        window.location.href = redirectTo;
      }, 1500);
    } else {
      throw new Error(result.error);
    }
  } catch (error) {
    console.error("Login error:", error);
    showNotification(
      error.message || "Login failed. Please try again.",
      "error"
    );

    // Highlight error fields
    if (error.message.toLowerCase().includes("email")) {
      highlightField("email", "error");
    }
    if (error.message.toLowerCase().includes("password")) {
      highlightField("password", "error");
    }
  } finally {
    // Re-enable submit button
    submitButton.disabled = false;
    submitButton.innerHTML = '<i class="fas fa-sign-in-alt"></i> Sign In';
  }
}

async function handleRegister(e) {
  e.preventDefault();

  const form = e.target;
  const formData = new FormData(form);
  const submitButton = form.querySelector('button[type="submit"]');

  // Validate passwords match
  const password = formData.get("password");
  const confirmPassword = formData.get("confirm_password");

  if (password !== confirmPassword) {
    showNotification("Passwords do not match", "error");
    highlightField("confirmPassword", "error");
    return;
  }

  // Check terms acceptance
  if (!formData.get("terms")) {
    showNotification("Please accept the Terms of Service", "warning");
    return;
  }

  // Disable submit button
  submitButton.disabled = true;
  submitButton.innerHTML =
    '<i class="fas fa-spinner fa-spin"></i> Creating Account...';

  try {
    const userData = {
      action: "register",
      username: formData.get("username"),
      email: formData.get("email"),
      password: password,
      first_name: formData.get("first_name"),
      last_name: formData.get("last_name"),
      phone: formData.get("phone"),
    };

    const response = await fetch("php/auth.php", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(userData),
    });

    const result = await response.json();

    if (result.success) {
      showNotification(
        "Account created successfully! Please sign in.",
        "success"
      );

      // Redirect to login
      setTimeout(() => {
        window.location.href = "login.html";
      }, 2000);
    } else {
      throw new Error(result.error);
    }
  } catch (error) {
    console.error("Registration error:", error);
    showNotification(
      error.message || "Registration failed. Please try again.",
      "error"
    );

    // Highlight error fields
    if (error.message.toLowerCase().includes("email")) {
      highlightField("email", "error");
    }
    if (error.message.toLowerCase().includes("username")) {
      highlightField("username", "error");
    }
  } finally {
    // Re-enable submit button
    submitButton.disabled = false;
    submitButton.innerHTML = '<i class="fas fa-user-plus"></i> Create Account';
  }
}

function setupFormValidation(form) {
  const inputs = form.querySelectorAll("input[required]");

  inputs.forEach((input) => {
    input.addEventListener("blur", validateField);
    input.addEventListener("input", clearFieldError);
  });
}

function validateField(e) {
  const field = e.target;
  const value = field.value.trim();

  // Clear previous validation
  clearFieldValidation(field);

  // Required field validation
  if (field.hasAttribute("required") && !value) {
    showFieldError(field, "This field is required");
    return false;
  }

  // Email validation
  if (field.type === "email" && value) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(value)) {
      showFieldError(field, "Please enter a valid email address");
      return false;
    }
  }

  // Password validation
  if (field.type === "password" && field.name === "password" && value) {
    if (value.length < 8) {
      showFieldError(field, "Password must be at least 8 characters");
      return false;
    }
  }

  // Username validation
  if (field.name === "username" && value) {
    const usernameRegex = /^[a-zA-Z0-9_]{3,20}$/;
    if (!usernameRegex.test(value)) {
      showFieldError(
        field,
        "Username must be 3-20 characters, letters, numbers, and underscores only"
      );
      return false;
    }
  }

  // Show success
  highlightField(field.id, "success");
  return true;
}

function clearFieldError(e) {
  const field = e.target;
  if (field.classList.contains("error")) {
    clearFieldValidation(field);
  }
}

function highlightField(fieldId, type) {
  const field = document.getElementById(fieldId);
  if (!field) return;

  clearFieldValidation(field);
  field.classList.add(type);
}

function showFieldError(field, message) {
  highlightField(field.id, "error");

  // Add error message
  let errorElement =
    field.parentNode.parentNode.querySelector(".error-message");
  if (!errorElement) {
    errorElement = document.createElement("div");
    errorElement.className = "error-message";
    field.parentNode.parentNode.appendChild(errorElement);
  }

  errorElement.innerHTML = `<i class="fas fa-exclamation-circle"></i> ${message}`;
}

function clearFieldValidation(field) {
  field.classList.remove("error", "success");

  // Remove error message
  const errorElement =
    field.parentNode.parentNode.querySelector(".error-message");
  if (errorElement) {
    errorElement.remove();
  }
}

function setupPasswordValidation() {
  const passwordField = document.getElementById("password");
  const confirmPasswordField = document.getElementById("confirmPassword");

  if (passwordField) {
    passwordField.addEventListener("input", function () {
      updatePasswordStrength(this.value);
    });
  }

  if (confirmPasswordField) {
    confirmPasswordField.addEventListener("input", function () {
      validatePasswordMatch();
    });
  }
}

function setupPasswordStrengthMeter() {
  const passwordField = document.getElementById("password");
  if (!passwordField) return;

  passwordField.addEventListener("input", function () {
    updatePasswordStrength(this.value);
  });
}

function updatePasswordStrength(password) {
  const strengthMeter = document.querySelector(".strength-fill");
  const strengthText = document.querySelector(".strength-text");

  if (!strengthMeter || !strengthText) return;

  let strength = 0;
  let strengthLabel = "";

  if (password.length >= 8) strength++;
  if (/[a-z]/.test(password)) strength++;
  if (/[A-Z]/.test(password)) strength++;
  if (/[0-9]/.test(password)) strength++;
  if (/[^A-Za-z0-9]/.test(password)) strength++;

  // Remove all strength classes
  strengthMeter.className = "strength-fill";

  switch (strength) {
    case 0:
    case 1:
      strengthMeter.classList.add("weak");
      strengthLabel = "Weak";
      break;
    case 2:
      strengthMeter.classList.add("fair");
      strengthLabel = "Fair";
      break;
    case 3:
    case 4:
      strengthMeter.classList.add("good");
      strengthLabel = "Good";
      break;
    case 5:
      strengthMeter.classList.add("strong");
      strengthLabel = "Strong";
      break;
  }

  strengthText.textContent = `Password strength: ${strengthLabel}`;
}

function validatePasswordMatch() {
  const password = document.getElementById("password").value;
  const confirmPassword = document.getElementById("confirmPassword").value;

  if (confirmPassword && password !== confirmPassword) {
    showFieldError(
      document.getElementById("confirmPassword"),
      "Passwords do not match"
    );
  } else if (confirmPassword && password === confirmPassword) {
    highlightField("confirmPassword", "success");
  }
}

function togglePassword(fieldId) {
  const field = document.getElementById(fieldId);
  const button = field.parentNode.querySelector(".password-toggle");
  const icon = button.querySelector("i");

  if (field.type === "password") {
    field.type = "text";
    icon.className = "fas fa-eye-slash";
  } else {
    field.type = "password";
    icon.className = "fas fa-eye";
  }
}

function setupSocialLogin() {
  const googleBtn = document.querySelector(".google-btn");
  const facebookBtn = document.querySelector(".facebook-btn");

  if (googleBtn) {
    googleBtn.addEventListener("click", function () {
      showNotification("Google login will be available soon!", "info");
    });
  }

  if (facebookBtn) {
    facebookBtn.addEventListener("click", function () {
      showNotification("Facebook login will be available soon!", "info");
    });
  }
}

// Global logout function
async function logout() {
  try {
    await fetch("php/auth.php", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ action: "logout" }),
    });

    showNotification("Logged out successfully", "success");

    setTimeout(() => {
      window.location.href = "index.html";
    }, 1500);
  } catch (error) {
    console.error("Logout failed:", error);
    showNotification("Logout failed", "error");
  }
}

// Notification function (if not already included)
function showNotification(message, type = "info") {
  // Remove existing notifications
  const existingNotifications = document.querySelectorAll(".notification");
  existingNotifications.forEach((notification) => notification.remove());

  // Create notification element
  const notification = document.createElement("div");
  notification.className = `notification notification-${type}`;
  notification.innerHTML = `
        <i class="fas fa-${getNotificationIcon(type)}"></i>
        <span>${message}</span>
        <button class="notification-close" onclick="this.parentElement.remove()">
            <i class="fas fa-times"></i>
        </button>
    `;

  // Add to page
  document.body.appendChild(notification);

  // Auto remove after 5 seconds
  setTimeout(() => {
    if (notification.parentElement) {
      notification.remove();
    }
  }, 5000);

  // Animate in
  requestAnimationFrame(() => {
    notification.classList.add("show");
  });
}

function getNotificationIcon(type) {
  const icons = {
    success: "check-circle",
    error: "exclamation-circle",
    warning: "exclamation-triangle",
    info: "info-circle",
  };
  return icons[type] || "info-circle";
}
