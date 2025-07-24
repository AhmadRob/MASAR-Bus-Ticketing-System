<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Get previous form values if they exist
    String origin = request.getParameter("origin");
    String destination = request.getParameter("destination");
    String passengers = request.getParameter("passengers");
    String tripType = request.getParameter("tripType");
    String ticketType = request.getParameter("ticketType");
    String userCategory = request.getParameter("userCategory");
    String travelTime = request.getParameter("travelTime");
%>

<style>
    .fare-estimation-card {
        border: none;
        border-radius: 16px;
        background: white;
        box-shadow: 0 5px 15px rgba(0,0,0,0.05);
        padding: 2rem;
        margin-bottom: 2rem;
        transition: all 0.3s ease;
    }
    
    .fare-estimation-card:hover {
        transform: translateY(-3px);
        box-shadow: 0 10px 25px rgba(0,0,0,0.1);
    }
    
    .fare-estimation-card h4 {
        font-family: 'Playfair Display', serif;
        color: var(--primary);
        margin-bottom: 1.5rem;
        padding-bottom: 0.5rem;
        border-bottom: 2px solid rgba(26, 54, 93, 0.1);
    }
    
    .form-label {
        font-weight: 500;
        color: var(--text);
        margin-bottom: 0.5rem;
    }
    
    .form-control, .form-select {
        border-radius: 12px;
        padding: 0.75rem 1rem;
        border: 1px solid rgba(0,0,0,0.1);
        transition: all 0.3s;
    }
    
    .form-control:focus, .form-select:focus {
        border-color: var(--accent);
        box-shadow: 0 0 0 0.25rem rgba(66, 153, 225, 0.1);
    }
    
    .estimate-btn {
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
    
    .estimate-btn:hover {
        transform: translateY(-2px);
        box-shadow: 0 10px 20px rgba(236, 201, 75, 0.2);
    }
    
    .form-section-title {
        color: var(--primary);
        font-weight: 600;
        margin: 1.5rem 0 1rem;
        font-size: 1.1rem;
    }
    
    .required-field::after {
        content: " *";
        color: #e53e3e;
    }
    
    .is-invalid {
        border-color: #e53e3e !important;
    }
    
    .invalid-feedback {
        color: #e53e3e;
        font-size: 0.875rem;
        margin-top: 0.25rem;
    }
    
    /* Time input styling */
    input[type="time"]::-webkit-calendar-picker-indicator {
        filter: invert(0.5);
        cursor: pointer;
    }
    
    input[type="time"]::-webkit-calendar-picker-indicator:hover {
        filter: invert(0.3);
    }
</style>

<div class="fare-estimation-card">
    <h4><i class="fas fa-calculator me-2"></i>Fare Estimation</h4>
    
    <form id="fareEstimationForm" action="${pageContext.request.contextPath}/FareEstimationServlet" method="get" novalidate>
        <!-- Route Information -->
        <div class="form-section-title">
            <i class="fas fa-route me-2"></i>Route Information
        </div>
        <div class="row mb-3">
            <div class="col-md-6">
                <label for="origin" class="form-label required-field">Origin</label>
                <input type="text" class="form-control" id="origin" name="origin" 
                       value="<%= origin != null ? origin : "" %>" 
                       placeholder="Enter origin" required>
                <div class="invalid-feedback">Please enter origin</div>
            </div>
            <div class="col-md-6">
                <label for="destination" class="form-label required-field">Destination</label>
                <input type="text" class="form-control" id="destination" name="destination" 
                       value="<%= destination != null ? destination : "" %>" 
                       placeholder="Enter destination" required>
                <div class="invalid-feedback">Please enter destination</div>
            </div>
        </div>
        
        <!-- Trip Details -->
        <div class="form-section-title">
            <i class="fas fa-info-circle me-2"></i>Trip Details
        </div>
        <div class="row mb-3">
            <div class="col-md-3">
                <label for="passengers" class="form-label required-field">Passengers</label>
                <input type="number" class="form-control" id="passengers" name="passengers" 
                       min="1" value="<%= passengers != null ? passengers : "" %>" required>
                <div class="invalid-feedback">Minimum 1 passenger</div>
            </div>
            <div class="col-md-3">
                <label for="tripType" class="form-label required-field">Trip Type</label>
                <select class="form-select" id="tripType" name="tripType" required>
                    <option value="" disabled selected>Select type</option>
                    <option value="city" <%= "city".equals(tripType) ? "selected" : "" %>>City</option>
                    <option value="inter-city" <%= "inter-city".equals(tripType) ? "selected" : "" %>>Inter City</option>
                </select>
                <div class="invalid-feedback">Please select trip type</div>
            </div>
            <div class="col-md-3">
                <label for="travelDate" class="form-label required-field">Travel Date</label>
                <input type="date" class="form-control" id="travelDate" name="travelDate" 
                       value="<%= request.getParameter("travelDate") != null ? request.getParameter("travelDate") : "" %>" required>
                <div class="invalid-feedback">Please select travel date</div>
            </div>
            <div class="col-md-3">
                <label for="travelTime" class="form-label required-field">Travel Time</label>
                <input type="time" class="form-control" id="travelTime" name="travelTime" 
                       value="<%= travelTime != null ? travelTime : "" %>" required>
                <div class="invalid-feedback">Please select travel time</div>
            </div>
        </div>
        
        <!-- Ticket Options -->
        <div class="form-section-title">
            <i class="fas fa-ticket-alt me-2"></i>Ticket Options
        </div>
        <div class="row mb-3">
            <div class="col-md-4">
                <label for="ticketType" class="form-label required-field">Ticket Type</label>
                <select class="form-select" id="ticketType" name="ticketType" required>
                    <option value="" disabled selected>Select type</option>
                    <option value="one_trip" <%= "one-trip".equals(ticketType) ? "selected" : "" %>>One Trip</option>
                    <option value="daily_pass" <%= "daily".equals(ticketType) ? "selected" : "" %>>Daily</option>
                    <option value="weekly_pass" <%= "weekly".equals(ticketType) ? "selected" : "" %>>Weekly</option>
                    <option value="monthly_pass" <%= "monthly".equals(ticketType) ? "selected" : "" %>>Monthly</option>
                </select>
                <div class="invalid-feedback">Please select ticket type</div>
            </div>
            <div class="col-md-4">
                <label for="userCategory" class="form-label required-field">User Category</label>
                <select class="form-select" id="userCategory" name="userCategory" required>
                    <option value="" disabled selected>Select category</option>
                    <option value="regular" <%= "regular".equals(userCategory) ? "selected" : "" %>>Regular</option>
                    <option value="student" <%= "student".equals(userCategory) ? "selected" : "" %>>Student</option>
                    <option value="senior" <%= "senior".equals(userCategory) ? "selected" : "" %>>Senior</option>
                </select>
                <div class="invalid-feedback">Please select user category</div>
            </div>
        </div>
        
        <div class="text-end">
            <button type="submit" class="btn estimate-btn">
                <i class="fas fa-calculator me-2"></i>Estimate Fare
            </button>
        </div>
    </form>
</div>

<% if (request.getAttribute("estimatedFare") != null) { %>
    <div class="fare-result-card mt-4 p-4 text-center" 
         style="background: linear-gradient(135deg, rgba(26, 54, 93, 0.05), rgba(66, 153, 225, 0.05)); 
                border-radius: 16px;">
        <h5 class="fw-bold" style="color: var(--primary);">
            <i class="fas fa-receipt me-2"></i>Fare Estimation Result
        </h5>
        <div class="display-4 my-3" style="color: var(--accent);">
            $<%= request.getAttribute("estimatedFare") %>
        </div>
        <p class="text-muted">
            Based on your selected criteria
        </p>
        <a href="passengerDashboard.jsp" class="btn btn-primary-dash mt-2">
            <i class="fas fa-redo me-2"></i>New Estimation
        </a>
    </div>
<% } %>

<script>
    // Form validation
    document.addEventListener('DOMContentLoaded', function() {
        const form = document.getElementById('fareEstimationForm');
        
        // Set default date to today if empty
        const dateInput = document.getElementById('travelDate');
        if (dateInput && !dateInput.value) {
            const today = new Date().toISOString().split('T')[0];
            dateInput.value = today;
        }
        
        // Set default time to current time if empty
        const timeInput = document.getElementById('travelTime');
        if (timeInput && !timeInput.value) {
            const now = new Date();
            const hours = String(now.getHours()).padStart(2, '0');
            const minutes = String(now.getMinutes()).padStart(2, '0');
            timeInput.value = `${hours}:${minutes}`;
        }
        
        // Prevent default option selection for dropdowns
        document.querySelectorAll('select[required]').forEach(select => {
            select.addEventListener('change', function() {
                if (this.value === "") {
                    this.classList.add('is-invalid');
                } else {
                    this.classList.remove('is-invalid');
                }
            });
        });
        
        form.addEventListener('submit', function(event) {
            let isValid = true;
            
            // Validate all required fields
            form.querySelectorAll('[required]').forEach(field => {
                if (!field.value || (field.tagName === 'SELECT' && field.value === "")) {
                    field.classList.add('is-invalid');
                    isValid = false;
                } else {
                    field.classList.remove('is-invalid');
                }
            });
            
            // Validate number of passengers
            const passengersInput = document.getElementById('passengers');
            if (passengersInput.value < 1) {
                passengersInput.classList.add('is-invalid');
                passengersInput.nextElementSibling.textContent = "Number of passengers must be at least 1";
                isValid = false;
            }
            
            if (!isValid) {
                event.preventDefault();
                event.stopPropagation();
                
                // Scroll to first invalid field
                const firstInvalid = form.querySelector('.is-invalid');
                if (firstInvalid) {
                    firstInvalid.scrollIntoView({ behavior: 'smooth', block: 'center' });
                }
            }
            
            form.classList.add('was-validated');
        });
        
        // Real-time validation for input fields
        form.querySelectorAll('input[required]').forEach(input => {
            input.addEventListener('input', function() {
                if (this.value) {
                    this.classList.remove('is-invalid');
                }
            });
        });
    });
</script>