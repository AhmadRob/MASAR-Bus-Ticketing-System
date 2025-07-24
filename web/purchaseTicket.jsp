<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="domain.Trip"%>

<style>
    .purchase-form {
        background: white;
        border-radius: 16px;
        padding: 2rem;
        box-shadow: 0 5px 15px rgba(0,0,0,0.05);
    }

    .purchase-form .form-label {
        font-weight: 500;
        color: var(--text);
        margin-bottom: 0.5rem;
    }

    .purchase-form .form-control, 
    .purchase-form .form-select {
        border-radius: 12px;
        padding: 0.75rem 1rem;
        border: 1px solid rgba(0,0,0,0.1);
        transition: all 0.3s;
    }

    .purchase-form .form-control:focus, 
    .purchase-form .form-select:focus {
        border-color: var(--accent);
        box-shadow: 0 0 0 0.25rem rgba(66, 153, 225, 0.1);
    }

    .purchase-btn {
        background: linear-gradient(135deg, var(--secondary), #f6e05e);
        border: none;
        border-radius: 50px;
        padding: 0.75rem 2rem;
        font-weight: 600;
        letter-spacing: 0.5px;
        transition: all 0.3s;
        color: var(--dark);
        margin-top: 1rem;
    }

    .purchase-btn:hover {
        transform: translateY(-2px);
        box-shadow: 0 10px 20px rgba(236, 201, 75, 0.2);
    }

    .trip-option {
        display: flex;
        justify-content: space-between;
    }

    .trip-route {
        font-weight: 500;
    }

    .trip-time {
        color: var(--text);
        opacity: 0.8;
    }

    .required-field::after {
        content: " *";
        color: #e53e3e;
    }

    .refresh-container {
        display: flex;
        align-items: center;
        gap: 10px;
        margin-top: 10px;
    }

    .refresh-btn {
        background: none;
        border: none;
        color: var(--accent);
        cursor: pointer;
        transition: transform 0.3s;
        padding: 5px;
    }

    .refresh-btn:hover {
        transform: rotate(180deg);
    }

    .no-trips-message {
        color: #e53e3e;
        margin-top: 10px;
        display: flex;
        align-items: center;
        gap: 5px;
    }

    .loading-spinner {
        display: none;
        color: var(--accent);
    }
</style>

<div class="purchase-form">
    <h4 class="fw-bold mb-4" style="color: var(--primary);">
        <i class="fas fa-ticket-alt me-2"></i>Purchase Ticket
    </h4>

    <form action="${pageContext.request.contextPath}/PurchaseTicketServlet" method="post">
        <input type="hidden" name="userId" value="<%= session.getAttribute("userId")%>" />

        <div class="row mb-4">

            <!-- Trip selection -->
            <div class="col-md-6">
                <label for="tripId" class="form-label required-field">Select Trip</label>
                <select class="form-select" id="tripId" name="tripId" required>
                    <option value="" disabled selected>-- Select Trip --</option>
                    <%
                        List<Trip> tripList = (List<Trip>) request.getAttribute("tripList");
                        if (tripList != null && !tripList.isEmpty()) {
                            for (Trip trip : tripList) {
                    %>
                    <option value="<%= trip.getId()%>">
                    <span class="trip-option">
                        <span class="trip-route"><%= trip.getOrigin()%> to <%= trip.getDestination()%></span>
                        <span class="trip-time"><%= trip.getTime()%></span>
                    </span>
                    </option>
                    <%
                            }
                        }
                    %>
                </select>

                <% if (tripList == null || tripList.isEmpty()) { %>
                <div class="no-trips-message">
                    <i class="fas fa-exclamation-circle"></i>
                    <span>No trips available</span>
                </div>
                <div class="refresh-container">
                    <button type="button" id="refreshTrips" class="refresh-btn" title="Refresh trips"
                            onclick="window.location.href = 'SearchTripsServlet?origin=&destination=&travelType=&travelDate=&activeTab=purchase'">
                        <i class="fas fa-sync-alt"></i>
                    </button>
                    <span>Click to refresh</span>
                    <i id="refreshSpinner" class="fas fa-spinner fa-spin loading-spinner"></i>
                </div>
                <% }%>
            </div>

            <!-- Seats input -->
            <div class="col-md-3">
                <label for="seats" class="form-label required-field">Number of Seats</label>
                <input type="number" class="form-control" id="seats" name="seats" value="1" min="1" required>
            </div>

            <!-- Ticket type selection -->
            <div class="col-md-3">
                <label for="ticketType" class="form-label required-field">Ticket Type</label>
                <select class="form-select" id="ticketType" name="ticketType" required>
                    <option value="" disabled selected>-- Select Type --</option>
                    <option value="one_trip">One Trip</option>
                    <option value="daily_pass">Daily Pass</option>
                    <option value="weekly_pass">Weekly Pass</option>
                    <option value="monthly_pass">Monthly Pass</option>
                </select>
            </div>
        </div>

        <!-- Passenger class input -->
        <div class="row mb-4">
            <div class="col-md-6">
                <label for="passengerClass" class="form-label required-field">Passenger Class</label>
                <select class="form-select" id="passengerClass" name="passengerClass" required>
                    <option value="" disabled selected>-- Select Class --</option>
                    <option value="regular">Regular</option>
                    <option value="student">Student</option>
                    <option value="senior">Senior</option>
                </select>
            </div>
        </div>

        <div class="text-end">
            <button type="submit" class="btn purchase-btn" <%= (tripList == null || tripList.isEmpty()) ? "disabled" : ""%>>
                <i class="fas fa-shopping-cart me-2"></i>Purchase Ticket
            </button>
        </div>
    </form>
</div>

<script>
            document.addEventListener('DOMContentLoaded', function() {
            const refreshBtn = document.getElementById('refreshTrips');
                    const refreshSpinner = document.getElementById('refreshSpinner');
                    if (refreshBtn) {
            refreshBtn.addEventListener('click', function() {
            // Show loading spinner
            refreshSpinner.style.display = 'inline-block';
                    this.style.display = 'none';
                    // Reload the page after a short delay to show the spinner
                    setTimeout(function() {
                    window.location.reload();
                    }, 300);
            });
            }
            });
</script>