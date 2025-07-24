<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="domain.Trip" %>

<%
    List<Trip> tripList = (List<Trip>) request.getAttribute("tripList");
    // Get previous search parameters to repopulate the form
    String origin = request.getParameter("origin");
    String destination = request.getParameter("destination");
    String travelType = request.getParameter("travelType");
    String travelDate = request.getParameter("travelDate");
%>

<style>
    .search-card {
        border: none;
        border-radius: 16px;
        background: white;
        box-shadow: 0 5px 15px rgba(0,0,0,0.05);
        padding: 2rem;
        margin-bottom: 2rem;
    }
    
    .search-card .form-label {
        font-weight: 500;
        color: var(--text);
        margin-bottom: 0.5rem;
    }
    
    .search-card .form-control, 
    .search-card .form-select {
        border-radius: 12px;
        padding: 0.75rem 1rem;
        border: 1px solid rgba(0,0,0,0.1);
        transition: all 0.3s;
    }
    
    .search-card .form-control:focus, 
    .search-card .form-select:focus {
        border-color: var(--accent);
        box-shadow: 0 0 0 0.25rem rgba(66, 153, 225, 0.1);
    }
    
    .search-btn {
        background: linear-gradient(135deg, var(--primary), var(--accent));
        border: none;
        border-radius: 50px;
        padding: 0.75rem 2rem;
        font-weight: 600;
        letter-spacing: 0.5px;
        transition: all 0.3s;
        margin-top: 1rem;
    }
    
    .search-btn:hover {
        transform: translateY(-2px);
        box-shadow: 0 10px 20px rgba(26, 54, 93, 0.2);
    }
    
    .results-table {
        border-radius: 16px;
        overflow: hidden;
    }
    
    .results-table thead {
        background: linear-gradient(135deg, var(--primary), var(--accent));
        color: white;
    }
    
    .results-table th {
        font-weight: 500;
        padding: 1rem;
    }
    
    .results-table td {
        padding: 0.75rem 1rem;
        vertical-align: middle;
    }
    
    .results-table tr:hover {
        background-color: rgba(66, 153, 225, 0.05);
    }
    
    .no-results {
        background: white;
        border-radius: 16px;
        padding: 2rem;
        text-align: center;
        box-shadow: 0 5px 15px rgba(0,0,0,0.05);
    }
    
    .no-results i {
        font-size: 2rem;
        color: var(--accent);
        margin-bottom: 1rem;
    }
</style>

<!-- Search Form Card -->
<div class="search-card">
    <h5 class="fw-bold mb-4" style="color: var(--primary);">
        <i class="fas fa-search me-2"></i>Search Trips
    </h5>
    <form action="SearchTripsServlet" method="get" class="row g-3">
        <div class="col-md-4">
            <label for="origin" class="form-label">Origin</label>
            <input type="text" class="form-control" id="origin" name="origin" 
                   value="<%= origin != null ? origin : "" %>" 
                   placeholder="Any origin">
        </div>
        <div class="col-md-4">
            <label for="destination" class="form-label">Destination</label>
            <input type="text" class="form-control" id="destination" name="destination"
                   value="<%= destination != null ? destination : "" %>"
                   placeholder="Any destination">
        </div>
        <div class="col-md-4">
            <label for="travelType" class="form-label">Travel Type</label>
            <select class="form-select" id="travelType" name="travelType">
                <option value="">Any type</option>
                <option value="city" <%= "city".equals(travelType) ? "selected" : "" %>>City</option>
                <option value="inter-city" <%= "inter-city".equals(travelType) ? "selected" : "" %>>Inter-city</option>
            </select>
        </div>
        <div class="col-md-4">
            <label for="travelDate" class="form-label">Travel Date</label>
            <input type="date" class="form-control" id="travelDate" name="travelDate"
                   value="<%= travelDate != null ? travelDate : "" %>">
        </div>
        <div class="col-md-12 text-end">
            <button type="submit" class="btn search-btn text-white">
                <i class="fas fa-search me-2"></i>Search Trips
            </button>
        </div>
    </form>
</div>

<!-- Results Section -->
<% if (tripList != null) { %>
    <% if (!tripList.isEmpty()) { %>
        <div class="results-table-container">
            <h5 class="fw-bold mb-3" style="color: var(--primary);">
                <i class="fas fa-list me-2"></i>Search Results
            </h5>
            <div class="table-responsive">
                <table class="table results-table">
                    <thead>
                        <tr>
                            <th>Trip ID</th>
                            <th>Origin</th>
                            <th>Destination</th>
                            <th>Type</th>
                            <th>Departure Time</th>
                            <th>Available Seats</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Trip trip : tripList) { %>
                            <tr>
                                <td><%= trip.getId() %></td>
                                <td><%= trip.getOrigin() %></td>
                                <td><%= trip.getDestination() %></td>
                                <td>
                                    <span class="badge <%= "city".equals(trip.getTravelType()) ? "bg-primary" : "bg-warning text-dark" %>">
                                        <%= trip.getTravelType() %>
                                    </span>
                                </td>
                                <td><%= trip.getTime() %></td>
                                <td>
                                    <span class="badge <%= trip.getAvailableSeats() > 0 ? "bg-success" : "bg-danger" %>">
                                        <%= trip.getAvailableSeats() %>
                                    </span>
                                </td>
                                <td>
                                    <a href="bookTrip.jsp?id=<%= trip.getId() %>" class="btn btn-sm btn-primary-dash">
                                        <i class="fas fa-ticket-alt me-1"></i>Book
                                    </a>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    <% } else { %>
        <div class="no-results">
            <i class="fas fa-info-circle"></i>
            <h5 class="fw-bold mb-2">No trips found</h5>
            <p class="text-muted">Try adjusting your search criteria</p>
            <a href="SearchTripsServlet" class="btn btn-primary-dash mt-2">
                <i class="fas fa-sync-alt me-2"></i>Reset Search
            </a>
        </div>
    <% } %>
<% } %>

<script>
    // Set today's date as default if no date is selected
    document.addEventListener('DOMContentLoaded', function() {
        const dateInput = document.getElementById('travelDate');
        if (dateInput && !dateInput.value) {
            const today = new Date().toISOString().split('T')[0];
            dateInput.value = today;
        }
    });
</script>