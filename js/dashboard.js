// Dashboard JavaScript
let currentUser = null;
let userTravelPlans = [];
let filteredPlans = [];

document.addEventListener("DOMContentLoaded", function () {
  initializeDashboard();
});

async function initializeDashboard() {
  try {
    // Check authentication
    await checkAuthStatus();

    if (!currentUser) {
      window.location.href = "login.html?redirect=dashboard.html";
      return;
    }

    // Initialize dashboard components
    setupEventListeners();
    updateUserInterface();
    await loadUserData();
  } catch (error) {
    console.error("Dashboard initialization failed:", error);
    showNotification("Failed to load dashboard", "error");
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
    } else {
      throw new Error("Not authenticated");
    }
  } catch (error) {
    console.error("Auth check failed:", error);
    currentUser = null;
  }
}

function setupEventListeners() {
  // User menu toggle
  const userMenuToggle = document.getElementById("userMenuToggle");
  const userMenuDropdown = document.getElementById("userMenuDropdown");

  if (userMenuToggle && userMenuDropdown) {
    userMenuToggle.addEventListener("click", function (e) {
      e.stopPropagation();
      userMenuDropdown.classList.toggle("show");
    });

    // Close menu when clicking outside
    document.addEventListener("click", function () {
      userMenuDropdown.classList.remove("show");
    });
  }

  // Filter buttons
  const filterButtons = document.querySelectorAll(".filter-btn");
  filterButtons.forEach((btn) => {
    btn.addEventListener("click", function () {
      // Update active filter
      filterButtons.forEach((b) => b.classList.remove("active"));
      this.classList.add("active");

      // Filter plans
      const filter = this.dataset.filter;
      filterTravelPlans(filter);
    });
  });

  // Quick action handlers
  setupQuickActions();
}

function setupQuickActions() {
  // Random destination handler is already set up in HTML onclick
  // Travel tips handler is already set up in HTML onclick
  // Weather update handler is already set up in HTML onclick
}

function updateUserInterface() {
  // Update user name in greeting
  const userGreeting = document.getElementById("userGreeting");
  const userName = document.getElementById("userName");

  if (userGreeting && currentUser) {
    userGreeting.textContent = currentUser.first_name || currentUser.username;
  }

  if (userName && currentUser) {
    userName.textContent = currentUser.first_name || currentUser.username;
  }
}

async function loadUserData() {
  try {
    // Load travel plans
    await loadTravelPlans();

    // Update statistics
    updateDashboardStats();

    // Load recent activity
    loadRecentActivity();
  } catch (error) {
    console.error("Failed to load user data:", error);
    showNotification("Failed to load user data", "error");
  }
}

async function loadTravelPlans() {
  try {
    const response = await fetch("php/travel_planner.php", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ action: "get_plans" }),
    });

    const result = await response.json();

    if (result.success) {
      userTravelPlans = result.data;
      filteredPlans = userTravelPlans;
      renderTravelPlans();
    } else {
      throw new Error(result.error);
    }
  } catch (error) {
    console.error("Failed to load travel plans:", error);
    renderEmptyState();
  }
}

function renderTravelPlans() {
  const grid = document.getElementById("travelPlansGrid");

  if (!grid) return;

  if (filteredPlans.length === 0) {
    renderEmptyState();
    return;
  }

  grid.innerHTML = filteredPlans.map((plan) => createPlanCard(plan)).join("");
}

function createPlanCard(plan) {
  const statusColors = {
    draft: "draft",
    confirmed: "confirmed",
    completed: "completed",
  };

  const createdDate = new Date(plan.created_at).toLocaleDateString("en-US", {
    year: "numeric",
    month: "short",
    day: "numeric",
  });

  return `
        <div class="plan-card" onclick="viewPlanDetails(${plan.id})">
            <div class="plan-header">
                <div class="plan-destination">${plan.destination}</div>
                <div class="plan-duration">${plan.duration} days</div>
            </div>
            <div class="plan-body">
                <div class="plan-details">
                    <div class="plan-detail">
                        <i class="fas fa-wallet"></i>
                        <span>${plan.budget_range}</span>
                    </div>
                    <div class="plan-detail">
                        <i class="fas fa-users"></i>
                        <span>${plan.travel_type}</span>
                    </div>
                    <div class="plan-detail">
                        <i class="fas fa-calendar"></i>
                        <span>${createdDate}</span>
                    </div>
                    <div class="plan-detail">
                        <span class="plan-status ${statusColors[plan.status]}">
                            ${plan.status}
                        </span>
                    </div>
                </div>
                <div class="plan-actions">
                    <button class="plan-btn" onclick="event.stopPropagation(); sharePlan(${
                      plan.id
                    })">
                        <i class="fas fa-share"></i> Share
                    </button>
                    <button class="plan-btn primary" onclick="event.stopPropagation(); bookPlan(${
                      plan.id
                    })">
                        <i class="fas fa-ticket-alt"></i> Trip
                    </button>
                </div>
            </div>
        </div>
    `;
}

function renderEmptyState() {
  const grid = document.getElementById("travelPlansGrid");
  if (grid) {
    grid.innerHTML = `
            <div class="empty-state">
                <i class="fas fa-map"></i>
                <h3>No Travel Plans Yet</h3>
                <p>Start planning your first amazing trip with AI assistance!</p>
                <a href="index.html#travel-planner" class="btn-primary">
                    <i class="fas fa-plus"></i>
                    Create Your First Trip
                </a>
            </div>
        `;
  }
}

function filterTravelPlans(filter) {
  if (filter === "all") {
    filteredPlans = userTravelPlans;
  } else {
    filteredPlans = userTravelPlans.filter((plan) => plan.status === filter);
  }

  renderTravelPlans();
}

function updateDashboardStats() {
  // Total trips
  const totalTripsElement = document.getElementById("totalTrips");
  if (totalTripsElement) {
    totalTripsElement.textContent = userTravelPlans.length;
  }

  // Countries to visit
  const countriesElement = document.getElementById("countriesVisited");
  if (countriesElement) {
    const uniqueCountries = new Set();
    userTravelPlans.forEach((plan) => {
      // Extract country from destination (simple approach)
      const destination = plan.destination.toLowerCase();
      if (destination.includes(",")) {
        const country = destination.split(",").pop().trim();
        uniqueCountries.add(country);
      } else {
        uniqueCountries.add(destination);
      }
    });
    countriesElement.textContent = uniqueCountries.size;
  }

  // Upcoming trips
  const upcomingElement = document.getElementById("upcomingTrips");
  if (upcomingElement) {
    const upcomingCount = userTravelPlans.filter(
      (plan) => plan.status === "confirmed" || plan.status === "draft"
    ).length;
    upcomingElement.textContent = upcomingCount;
  }
}

function loadRecentActivity() {
  const activityList = document.getElementById("activityList");
  if (!activityList) return;

  // Generate recent activity based on travel plans
  const activities = [];

  userTravelPlans.slice(0, 5).forEach((plan) => {
    const date = new Date(plan.created_at);
    const timeAgo = getTimeAgo(date);

    activities.push({
      icon: "fas fa-plus",
      title: "Travel plan created",
      description: `Created a ${plan.duration}-day trip to ${plan.destination}`,
      time: timeAgo,
    });
  });

  if (activities.length === 0) {
    activityList.innerHTML = `
            <div class="empty-state">
                <p>No recent activity</p>
            </div>
        `;
    return;
  }

  activityList.innerHTML = activities
    .map(
      (activity) => `
        <div class="activity-item">
            <div class="activity-icon">
                <i class="${activity.icon}"></i>
            </div>
            <div class="activity-content">
                <div class="activity-title">${activity.title}</div>
                <div class="activity-description">${activity.description}</div>
            </div>
            <div class="activity-time">${activity.time}</div>
        </div>
    `
    )
    .join("");
}

function getTimeAgo(date) {
  const now = new Date();
  const diffTime = Math.abs(now - date);
  const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));

  if (diffDays === 1) return "1 day ago";
  if (diffDays < 7) return `${diffDays} days ago`;
  if (diffDays < 30) return `${Math.floor(diffDays / 7)} weeks ago`;
  return `${Math.floor(diffDays / 30)} months ago`;
}

// Plan action handlers
async function viewPlanDetails(planId) {
  try {
    const response = await fetch("php/travel_planner.php", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        action: "get_plan_details",
        plan_id: planId,
      }),
    });

    const result = await response.json();

    if (result.success) {
      showPlanModal(result.data);
    } else {
      throw new Error(result.error);
    }
  } catch (error) {
    console.error("Failed to load plan details:", error);
    showNotification("Failed to load plan details", "error");
  }
}

function showPlanModal(plan) {
  const modal = document.getElementById("planModal");
  const modalTitle = document.getElementById("modalTitle");
  const modalBody = document.getElementById("modalBody");

  if (!modal || !modalTitle || !modalBody) return;

  modalTitle.textContent = `${plan.destination} - ${plan.duration} Days`;

  modalBody.innerHTML = `
        <div class="plan-modal-content">
            <div class="plan-info">
                <h3>Trip Information</h3>
                <div class="info-grid">
                    <div class="info-item">
                        <strong>Destination:</strong> ${plan.destination}
                    </div>
                    <div class="info-item">
                        <strong>Duration:</strong> ${plan.duration} days
                    </div>
                    <div class="info-item">
                        <strong>Budget:</strong> ${plan.budget_range}
                    </div>
                    <div class="info-item">
                        <strong>Travel Type:</strong> ${plan.travel_type}
                    </div>
                    <div class="info-item">
                        <strong>Status:</strong> <span class="plan-status ${
                          plan.status
                        }">${plan.status}</span>
                    </div>
                    <div class="info-item">
                        <strong>Created:</strong> ${new Date(
                          plan.created_at
                        ).toLocaleDateString()}
                    </div>
                </div>
            </div>
            <div class="plan-ai-response">
                <h3>AI Travel Plan</h3>
                <div class="ai-content">
                    ${formatAIResponse(plan.ai_response)}
                </div>
            </div>
        </div>
    `;

  modal.classList.add("show");
  document.body.style.overflow = "hidden";
}

function formatAIResponse(response) {
  if (!response) return "<p>No AI response available.</p>";

  // Format the AI response with proper HTML
  return response
    .replace(/\*\*(.*?)\*\*/g, "<strong>$1</strong>")
    .replace(/\*(.*?)\*/g, "<em>$1</em>")
    .replace(/\n\n/g, "</p><p>")
    .replace(/\n/g, "<br>")
    .replace(/^/, "<p>")
    .replace(/$/, "</p>");
}

function closeModal(modalId) {
  const modal = document.getElementById(modalId);
  if (modal) {
    modal.classList.remove("show");
    document.body.style.overflow = "auto";
  }
}



function sharePlan(planId) {
  const plan = userTravelPlans.find((p) => p.id === planId);
  if (!plan) return;

  const shareData = {
    title: `My Travel Plan - ${plan.destination}`,
    text: `Check out my ${plan.duration}-day trip to ${plan.destination} planned with TravelGenie AI!`,
    url: window.location.href,
  };

  if (navigator.share) {
    navigator
      .share(shareData)
      .then(() => showNotification("Plan shared successfully!", "success"))
      .catch(() => fallbackShare(shareData));
  } else {
    fallbackShare(shareData);
  }
}

function fallbackShare(shareData) {
  const textToCopy = `${shareData.title}\n${shareData.text}\n${shareData.url}`;

  if (navigator.clipboard) {
    navigator.clipboard
      .writeText(textToCopy)
      .then(() => showNotification("Plan copied to clipboard!", "success"))
      .catch(() => showNotification("Unable to copy to clipboard", "error"));
  }
}

function bookPlan(planId) {
  const plan = userTravelPlans.find((p) => p.id === planId);
  if (!plan) return;

  // Redirect to booking section
  window.location.href = `index.html#travel-planner`;
  showNotification("Redirecting to booking options...", "info");
}

// Quick action handlers
function showRandomDestination() {
  const destinations = [
    "Paris, France",
    "Tokyo, Japan",
    "New York, USA",
    "Rome, Italy",
    "Barcelona, Spain",
    "Amsterdam, Netherlands",
    "Prague, Czech Republic",
    "Bali, Indonesia",
    "Santorini, Greece",
    "Dubai, UAE",
  ];

  const randomDestination =
    destinations[Math.floor(Math.random() * destinations.length)];
  showNotification(`How about visiting ${randomDestination}?`, "info");
}

function showTravelTips() {
  const tips = [
    "Always keep copies of important documents",
    "Pack light and bring versatile clothing",
    "Research local customs and etiquette",
    "Get travel insurance for peace of mind",
    "Learn basic phrases in the local language",
    "Keep emergency contacts easily accessible",
  ];

  const randomTip = tips[Math.floor(Math.random() * tips.length)];
  showNotification(`💡 Travel Tip: ${randomTip}`, "info");
}

function showWeatherUpdate() {
  showNotification("Weather integration coming soon! 🌤️", "info");
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

// Notification function
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

// Modal close on outside click
document.addEventListener("click", function (e) {
  const modal = document.querySelector(".modal.show");
  if (modal && e.target === modal) {
    closeModal(modal.id);
  }
});
