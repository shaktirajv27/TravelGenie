// Global variables
let currentUser = null;
let currentPlan = null;

// Initialize app
document.addEventListener("DOMContentLoaded", function () {
  initializeApp();
});

async function initializeApp() {
  try {
    await checkAuthStatus();
    setupEventListeners();
    setupFormValidation();
  } catch (error) {
    console.error("App initialization error:", error);
  }
}

async function checkAuthStatus() {
  try {
    const response = await fetch("php/auth.php", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ action: "check" }),
    });

    const result = await response.json();

    if (result.success && result.user) {
      currentUser = result.user;
      updateNavForAuthenticatedUser();
    } else {
      currentUser = null;
      updateNavForGuestUser();
    }
  } catch (error) {
    console.error("Auth check failed:", error);
    currentUser = null;
    updateNavForGuestUser();
  }
}

function updateNavForAuthenticatedUser() {
  const navAuth = document.getElementById("navAuth");
  if (navAuth) {
    const firstName = currentUser.first_name || currentUser.username;
    navAuth.innerHTML = `
            <span class="user-greeting">Hello, ${firstName}!</span>
            <a href="dashboard.html" class="btn-secondary">Dashboard</a>
            <button class="btn-primary" onclick="logout()">Logout</button>
        `;
  }
}

function updateNavForGuestUser() {
  const navAuth = document.getElementById("navAuth");
  if (navAuth) {
    navAuth.innerHTML = `
            <a href="login.html" class="btn-secondary">Login</a>
            <a href="register.html" class="btn-primary">Sign Up</a>
        `;
  }
}

function setupEventListeners() {
  const travelForm = document.getElementById("travelForm");
  if (travelForm) {
    travelForm.addEventListener("submit", handleTravelFormSubmit);
  }

  const savePlanBtn = document.getElementById("savePlanBtn");
  if (savePlanBtn) {
    savePlanBtn.addEventListener("click", saveTravelPlan);
  }

  const sharePlanBtn = document.getElementById("sharePlanBtn");
  if (sharePlanBtn) {
    sharePlanBtn.addEventListener("click", shareTravelPlan);
  }

  // Booking buttons
  document.addEventListener("click", function (e) {
    if (e.target.classList.contains("booking-btn")) {
      handleBookingRedirect(e);
    }
  });

  // Smooth scrolling
  document.querySelectorAll('a[href^="#"]').forEach((anchor) => {
    anchor.addEventListener("click", function (e) {
      e.preventDefault();
      const target = document.querySelector(this.getAttribute("href"));
      if (target) {
        target.scrollIntoView({
          behavior: "smooth",
          block: "start",
        });
      }
    });
  });
}

function setupFormValidation() {
  const form = document.getElementById("travelForm");
  if (!form) return;

  const inputs = form.querySelectorAll("input[required], select[required]");
  inputs.forEach((input) => {
    input.addEventListener("blur", validateField);
    input.addEventListener("input", clearFieldError);
  });
}

function validateField(e) {
  const field = e.target;
  const value = field.value.trim();

  clearFieldError(field);

  if (field.hasAttribute("required") && !value) {
    showFieldError(field, "This field is required");
    return false;
  }

  if (field.name === "duration" && value) {
    const duration = parseInt(value);
    if (isNaN(duration) || duration < 1 || duration > 30) {
      showFieldError(field, "Duration must be between 1 and 30 days");
      return false;
    }
  }

  return true;
}

function showFieldError(field, message) {
  field.classList.add("error");

  let errorElement = field.parentNode.querySelector(".field-error");
  if (!errorElement) {
    errorElement = document.createElement("div");
    errorElement.className = "field-error";
    field.parentNode.appendChild(errorElement);
  }

  errorElement.innerHTML = `<i class="fas fa-exclamation-circle"></i> ${message}`;
}

function clearFieldError(field) {
  // Handle both event objects and direct field elements
  const targetField = field.target || field;

  if (targetField && targetField.classList) {
    targetField.classList.remove("error");

    // Find and remove error message
    const parentNode = targetField.parentNode;
    if (parentNode) {
      const errorElement = parentNode.querySelector(".field-error");
      if (errorElement) {
        errorElement.remove();
      }
    }
  }
}

async function handleTravelFormSubmit(e) {
  e.preventDefault();

  // Check authentication first
  if (!currentUser) {
    showNotification("Please log in to create travel plans", "warning");
    setTimeout(() => {
      window.location.href =
        "login.html?redirect=" + encodeURIComponent(window.location.href);
    }, 2000);
    return;
  }

  // Validate all fields
  const form = e.target;
  let isValid = true;
  const requiredFields = form.querySelectorAll(
    "input[required], select[required]"
  );

  requiredFields.forEach((field) => {
    if (!validateField({ target: field })) {
      isValid = false;
    }
  });

  if (!isValid) {
    showNotification("Please fix the errors in the form", "error");
    return;
  }

  // Collect form data
  const formData = new FormData(form);
  const interests = [];
  document
    .querySelectorAll('input[name="interests[]"]:checked')
    .forEach((checkbox) => {
      interests.push(checkbox.value);
    });

  const travelData = {
    destination: formData.get("destination").trim(),
    duration: parseInt(formData.get("duration")),
    budget: formData.get("budget"),
    interests: interests,
    travelType: formData.get("travelType"),
  };

  // Show loading
  showLoadingSection();

  try {
    const response = await fetch("php/travel_planner.php", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(travelData),
      credentials: "same-origin",
    });

    if (!response.ok) {
      throw new Error(`HTTP ${response.status}: ${response.statusText}`);
    }

    const result = await response.json();

    if (result.success && result.data) {
      currentPlan = {
        id: result.data.plan_id,
        data: travelData,
        bookingLinks: result.data.booking_links,
      };

      displayTravelPlan(result.data.ai_response);
      showNotification("Travel plan generated successfully!", "success");
    } else {
      throw new Error(result.error || "Failed to generate travel plan");
    }
  } catch (error) {
    console.error("Travel plan generation error:", error);
    displayError(
      error.message || "Failed to generate travel plan. Please try again."
    );
    showNotification("Error: " + (error.message || "Unknown error"), "error");
  } finally {
    hideLoadingSection();
  }
}

function showLoadingSection() {
  const loadingSection = document.getElementById("loadingSection");
  const resultsSection = document.getElementById("resultsSection");

  if (loadingSection) {
    loadingSection.style.display = "block";
    loadingSection.scrollIntoView({ behavior: "smooth" });
  }

  if (resultsSection) {
    resultsSection.style.display = "none";
  }
}

function hideLoadingSection() {
  const loadingSection = document.getElementById("loadingSection");
  if (loadingSection) {
    loadingSection.style.display = "none";
  }
}

function displayTravelPlan(planText) {
  const travelPlan = document.getElementById("travelPlan");
  const resultsSection = document.getElementById("resultsSection");

  if (travelPlan) {
    travelPlan.innerHTML = formatTravelPlan(planText);
  }

  if (resultsSection) {
    resultsSection.style.display = "block";
    resultsSection.scrollIntoView({ behavior: "smooth" });
  }
}

function displayError(errorMessage) {
  const travelPlan = document.getElementById("travelPlan");
  const resultsSection = document.getElementById("resultsSection");

  if (travelPlan) {
    travelPlan.innerHTML = `
            <div class="error-message">
                <i class="fas fa-exclamation-triangle"></i>
                <h3>Oops! Something went wrong</h3>
                <p>${errorMessage}</p>
                <button onclick="location.reload()" class="btn-primary">
                    <i class="fas fa-redo"></i> Try Again
                </button>
            </div>
        `;
  }

  if (resultsSection) {
    resultsSection.style.display = "block";
    resultsSection.scrollIntoView({ behavior: "smooth" });
  }
}

function formatTravelPlan(planText) {
  // Convert markdown-style formatting to HTML
  let formatted = planText
    .replace(/\*\*(.*?)\*\*/g, "<strong>$1</strong>")
    .replace(/\*(.*?)\*/g, "<em>$1</em>")
    .replace(/\n\n/g, "</p><p>")
    .replace(/\n/g, "<br>");

  // Wrap in paragraphs
  formatted = "<p>" + formatted + "</p>";

  // Add section styling
  formatted = formatted
    .replace(/🗓️|📅/g, '<i class="fas fa-calendar-alt"></i>')
    .replace(/🏨|🏩/g, '<i class="fas fa-bed"></i>')
    .replace(/🍽️|🍴/g, '<i class="fas fa-utensils"></i>')
    .replace(/🚌|🚗/g, '<i class="fas fa-car"></i>')
    .replace(/💎|✨/g, '<i class="fas fa-gem"></i>')
    .replace(/💰|💸/g, '<i class="fas fa-dollar-sign"></i>')
    .replace(/🌟|⭐/g, '<i class="fas fa-star"></i>')
    .replace(/📱|📞/g, '<i class="fas fa-mobile-alt"></i>');

  return `<div class="travel-plan-content">${formatted}</div>`;
}

async function saveTravelPlan() {
  if (!currentUser) {
    showNotification("Please log in to save plans", "warning");
    return;
  }

  if (!currentPlan) {
    showNotification("No plan to save", "warning");
    return;
  }

  showNotification("Plan saved to your dashboard!", "success");

  const savePlanBtn = document.getElementById("savePlanBtn");
  if (savePlanBtn) {
    savePlanBtn.innerHTML = '<i class="fas fa-check"></i> Saved';
    savePlanBtn.disabled = true;
    savePlanBtn.classList.add("saved");
  }
}

function shareTravelPlan() {
  if (!currentPlan) {
    showNotification("No plan to share", "warning");
    return;
  }

  const shareText = `Check out my ${currentPlan.data.duration}-day trip to ${currentPlan.data.destination} planned with TravelGenie AI!`;

  if (navigator.share) {
    navigator
      .share({
        title: "My Travel Plan",
        text: shareText,
        url: window.location.href,
      })
      .then(() => {
        showNotification("Plan shared successfully!", "success");
      })
      .catch(() => {
        fallbackShare(shareText);
      });
  } else {
    fallbackShare(shareText);
  }
}

function fallbackShare(text) {
  if (navigator.clipboard) {
    navigator.clipboard
      .writeText(text + " - " + window.location.href)
      .then(() => showNotification("Plan copied to clipboard!", "success"))
      .catch(() => showNotification("Unable to copy to clipboard", "error"));
  } else {
    showNotification("Sharing not available on this device", "info");
  }
}

function handleBookingRedirect(e) {
  e.preventDefault();

  if (!currentPlan) {
    showNotification("Please generate a travel plan first", "warning");
    return;
  }

  const provider = e.target.dataset.provider;
  const bookingLinks = currentPlan.bookingLinks;

  if (bookingLinks && bookingLinks[provider]) {
    window.open(bookingLinks[provider], "_blank");
    showNotification("Opening booking site...", "info");
  } else {
    showNotification("Booking link not available", "error");
  }
}

async function logout() {
  try {
    await fetch("php/auth.php", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ action: "logout" }),
    });

    currentUser = null;
    updateNavForGuestUser();
    showNotification("Logged out successfully", "success");

    setTimeout(() => {
      window.location.href = "index.html";
    }, 1500);
  } catch (error) {
    console.error("Logout failed:", error);
    showNotification("Logout failed", "error");
  }
}

function showNotification(message, type = "info") {
  // Remove existing notifications
  const existingNotifications = document.querySelectorAll(".notification");
  existingNotifications.forEach((notification) => notification.remove());

  const notification = document.createElement("div");
  notification.className = `notification notification-${type}`;
  notification.innerHTML = `
        <i class="fas fa-${getNotificationIcon(type)}"></i>
        <span>${message}</span>
        <button class="notification-close" onclick="this.parentElement.remove()">
            <i class="fas fa-times"></i>
        </button>
    `;

  document.body.appendChild(notification);

  setTimeout(() => {
    if (notification.parentElement) {
      notification.remove();
    }
  }, 5000);

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
async function handleTravelFormSubmit(e) {
  e.preventDefault();

  console.log("Form submitted");

  // Check authentication first
  if (!currentUser) {
    showNotification("Please log in to create travel plans", "warning");
    setTimeout(() => {
      window.location.href =
        "login.html?redirect=" + encodeURIComponent(window.location.href);
    }, 2000);
    return;
  }

  // Collect form data
  const formData = new FormData(e.target);
  const interests = [];
  document
    .querySelectorAll('input[name="interests[]"]:checked')
    .forEach((checkbox) => {
      interests.push(checkbox.value);
    });

  const travelData = {
    destination: formData.get("destination"),
    duration: formData.get("duration"),
    budget: formData.get("budget"),
    interests: interests,
    travelType: formData.get("travelType"),
  };

  console.log("Sending travel data:", travelData);

  // Validate required fields
  if (
    !travelData.destination ||
    !travelData.duration ||
    !travelData.budget ||
    !travelData.travelType
  ) {
    showNotification("Please fill in all required fields", "error");
    return;
  }

  // Show loading
  showLoadingSection();

  try {
    console.log("Making API request...");

    const response = await fetch("php/travel_planner.php", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(travelData),
    });

    console.log("Response status:", response.status);
    console.log("Response ok:", response.ok);

    const result = await response.json();
    console.log("API response:", result);

    if (result.success && result.data) {
      currentPlan = {
        id: result.data.plan_id,
        data: travelData,
        bookingLinks: result.data.booking_links,
      };

      displayTravelPlan(result.data.ai_response);
      showNotification("Travel plan generated successfully!", "success");
    } else {
      throw new Error(result.error || "Failed to generate travel plan");
    }
  } catch (error) {
    console.error("Travel plan generation error:", error);
    displayError(
      error.message || "Failed to generate travel plan. Please try again."
    );
    showNotification("Error: " + (error.message || "Unknown error"), "error");
  } finally {
    hideLoadingSection();
  }
}

function setupFormValidation() {
  const form = document.getElementById("travelForm");
  if (!form) return;

  const inputs = form.querySelectorAll("input[required], select[required]");
  inputs.forEach((input) => {
    input.addEventListener("blur", validateField);
    input.addEventListener("input", function (e) {
      clearFieldError(e.target);
    });
  });
}

function validateField(e) {
  const field = e.target;
  const value = field.value.trim();

  clearFieldError(field);

  if (field.hasAttribute("required") && !value) {
    showFieldError(field, "This field is required");
    return false;
  }

  if (field.name === "duration" && value) {
    const duration = parseInt(value);
    if (isNaN(duration) || duration < 1 || duration > 30) {
      showFieldError(field, "Duration must be between 1 and 30 days");
      return false;
    }
  }

  return true;
}

function showFieldError(field, message) {
  field.classList.add("error");

  let errorElement = field.parentNode.querySelector(".field-error");
  if (!errorElement) {
    errorElement = document.createElement("div");
    errorElement.className = "field-error";
    field.parentNode.appendChild(errorElement);
  }

  errorElement.innerHTML = `<i class="fas fa-exclamation-circle"></i> ${message}`;
}
