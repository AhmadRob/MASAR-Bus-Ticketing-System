<%@page import="util.FareConfig"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="domain.Trip"%>
<%@page import="dao.TripDAO"%>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    if (session.getAttribute("user") == null) {
        response.sendRedirect("adminLogin.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="icon" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/icons/train-front.svg" type="image/svg+xml">
        <title>Manage Trips | Masar</title>
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <!-- Google Fonts -->
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Playfair+Display:wght@400;500;600;700&display=swap" rel="stylesheet">
        <style>
            :root {
                --primary: #1a365d;
                --secondary: #ecc94b;
                --light: #f8f9fa;
                --dark: #1a202c;
                --text: #4a5568;
                --accent: #4299e1;
                --success: #48bb78;
                --error: #f56565;
            }

            body {
                font-family: 'Inter', sans-serif;
                background-color: #f5f7fa;
                color: var(--text);
            }

            .header-section {
                background: linear-gradient(135deg, var(--primary), var(--accent));
                color: white;
                padding: 3rem 0;
                margin-bottom: 2rem;
                border-radius: 0 0 20px 20px;
                box-shadow: 0 4px 20px rgba(26, 54, 93, 0.1);
            }

            .page-title {
                font-family: 'Playfair Display', serif;
                font-weight: 700;
                margin-bottom: 0.5rem;
            }

            .page-subtitle {
                opacity: 0.9;
            }

            .management-card {
                border: none;
                border-radius: 16px;
                box-shadow: 0 5px 15px rgba(0,0,0,0.05);
                margin-bottom: 2rem;
                overflow: hidden;
            }

            .card-header {
                background: linear-gradient(135deg, var(--primary), var(--accent));
                color: white;
                font-weight: 600;
                padding: 1rem 1.5rem;
            }

            .form-control, .form-select {
                border-radius: 8px;
                padding: 0.75rem 1rem;
                margin-bottom: 1rem;
                border: 1px solid #e2e8f0;
                transition: all 0.3s;
            }

            .form-control:focus, .form-select:focus {
                border-color: var(--accent);
                box-shadow: 0 0 0 0.25rem rgba(66, 153, 225, 0.25);
            }

            .form-label {
                font-weight: 500;
                color: var(--dark);
                margin-bottom: 0.5rem;
                display: block;
            }

            .form-group {
                margin-bottom: 1.5rem;
            }

            .btn-action {
                border-radius: 50px;
                padding: 0.5rem 1.25rem;
                font-weight: 600;
                transition: all 0.3s;
            }

            .btn-add {
                background: linear-gradient(135deg, var(--success), #38a169);
                color: white;
                border: none;
            }

            .btn-add:hover {
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(72, 187, 120, 0.3);
            }

            .btn-edit {
                background: linear-gradient(135deg, var(--secondary), #f6e05e);
                color: var(--dark);
                border: none;
            }

            .btn-edit:hover {
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(236, 201, 75, 0.3);
            }

            .btn-delete {
                background: linear-gradient(135deg, var(--error), #e53e3e);
                color: white;
                border: none;
            }

            .btn-delete:hover {
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(245, 101, 101, 0.3);
            }

            .table th {
                background-color: var(--primary);
                color: white;
                font-weight: 500;
            }

            .table-hover tbody tr:hover {
                background-color: rgba(66, 153, 225, 0.1);
            }

            .badge-city {
                background-color: #4299e1;
                color: white;
            }

            .badge-intercity {
                background-color: #9f7aea;
                color: white;
            }

            .modal-content {
                border-radius: 16px;
                overflow: hidden;
            }

            .modal-header {
                background: linear-gradient(135deg, var(--primary), var(--accent));
                color: white;
            }

            .nav-btn {
                border-radius: 50px;
                padding: 0.5rem 1.25rem;
                font-weight: 600;
                transition: all 0.3s;
                border: 2px solid var(--primary);
                color: var(--primary);
            }

            .nav-btn:hover {
                background: var(--primary);
                color: white;
                transform: translateY(-2px);
            }

            .btn-logout {
                border-radius: 50px;
                padding: 0.5rem 1.25rem;
                font-weight: 600;
                transition: all 0.3s;
                border: 2px solid var(--error);
                color: var(--error);
            }

            .btn-logout:hover {
                background: var(--error);
                color: white;
                transform: translateY(-2px);
            }

            /* Improved form spacing */
            .form-container {
                padding: 1.5rem;
            }

            .form-row {
                margin-bottom: 1rem;
            }

            @media (max-width: 768px) {
                .header-section {
                    padding: 2rem 0;
                }

                .btn-action {
                    width: 100%;
                    margin-bottom: 0.5rem;
                }

                .form-container {
                    padding: 1rem;
                }
            }
        </style>
    </head>
    <body>
        <!-- Header Section -->
        <header class="header-section text-center">
            <div class="container">
                <h1 class="page-title">Trip Management Panel</h1>
                <p class="page-subtitle">Manage all trips in the Masar transportation system</p>
            </div>
        </header>

        <main class="container mb-5">
            <!-- Add Trip Form -->
            <div class="management-card">
                <div class="card-header">
                    <i class="fas fa-plus-circle me-2"></i>Add New Trip
                </div>
                <div class="card-body form-container">
                    <form action="${pageContext.request.contextPath}/AdminServlet" method="post">
                        <input type="hidden" name="action" value="addTrip"/>

                        <div class="row g-3">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">Origin</label>
                                    <input type="text" name="origin" class="form-control" required>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">Destination</label>
                                    <input type="text" name="destination" class="form-control" required>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label class="form-label">Date</label>
                                    <input type="date" name="date" class="form-control" required>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label class="form-label">Time</label>
                                    <input type="time" name="time" class="form-control" required>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label class="form-label">Capacity</label>
                                    <input type="number" name="capacity" class="form-control" min="1" max="55" required>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">Travel Type</label>
                                    <select name="travel_type" class="form-select" required>
                                        <option value="" disabled selected>Select Travel Type</option>
                                        <option value="city">City</option>
                                        <option value="inter_city">Inter City</option>
                                    </select>
                                </div>
                            </div>
                            <div class="col-12">
                                <div class="form-group text-end">
                                    <button type="submit" class="btn btn-add px-4">
                                        <i class="fas fa-plus me-2"></i>Add Trip
                                    </button>
                                </div>
                            </div>
                        </div>

                        <%
                            List<String> errors = (List<String>) request.getAttribute("errors");
                            if (errors != null && !errors.isEmpty()) {
                        %>
                        <div class="alert alert-danger mt-3">
                            <ul class="mb-0">
                                <% for (String error : errors) {%>
                                <li><%= error%></li>
                                    <% } %>
                            </ul>
                        </div>
                        <% }%>
                    </form>
                </div>
            </div>

            <!-- Trip List Table -->
            <div class="management-card">
                <div class="card-header">
                    <i class="fas fa-list me-2"></i>All Trips
                </div>
                <div class="card-body">
                    <%
                        TripDAO tripDAO = new TripDAO();
                        List<Trip> trips = tripDAO.getAllTrips();
                        if (trips.isEmpty()) {
                    %>
                    <div class="alert alert-warning">No trips found in the system.</div>
                    <% } else { %>
                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Origin</th>
                                    <th>Destination</th>
                                    <th>Date</th>
                                    <th>Time</th>
                                    <th>Capacity</th>
                                    <th>Available</th>
                                    <th>Type</th>
                                    <th>Fare</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Trip trip : trips) {
                                        int availableSeats = trip.getAvailableSeats();
                                        double baseFare = trip.getTravelType().equalsIgnoreCase("city")
                                                ? FareConfig.getInstance().getCityBaseFare()
                                                : FareConfig.getInstance().getInterCityBaseFare();
                                %>
                                <tr>
                                    <td><strong><%= trip.getId()%></strong></td>
                                    <td><%= trip.getOrigin()%></td>
                                    <td><%= trip.getDestination()%></td>
                                    <td><%= trip.getDate()%></td>
                                    <td><%= trip.getTime().toString().substring(11, 16)%></td>
                                    <td><%= trip.getCapacity()%></td>
                                    <td><span class="badge <%= availableSeats > 0 ? "bg-success" : "bg-danger"%>"><%= availableSeats%></span></td>
                                    <td>
                                        <span class="badge <%= trip.getTravelType().equalsIgnoreCase("city") ? "badge-city" : "badge-intercity"%>">
                                            <%= trip.getTravelType().replace("_", " ")%>
                                        </span>
                                    </td>
                                    <td><strong><%= String.format("%.2f", baseFare)%> JD</strong></td>
                                    <td>
                                        <button class="btn btn-edit btn-sm" data-bs-toggle="modal" data-bs-target="#editModal<%= trip.getId()%>">
                                            <i class="fas fa-edit me-1"></i>Edit
                                        </button>
                                        <form action="${pageContext.request.contextPath}/AdminServlet" method="post" class="d-inline" onsubmit="return confirm('Are you sure you want to delete this trip?');">
                                            <input type="hidden" name="action" value="deleteTrip">
                                            <input type="hidden" name="tripId" value="<%= trip.getId()%>">
                                            <button type="submit" class="btn btn-delete btn-sm">
                                                <i class="fas fa-trash me-1"></i>Delete
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>

                    <!-- Edit Trip Modals -->
                    <% for (Trip trip : trips) {%>
                    <div class="modal fade" id="editModal<%= trip.getId()%>" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog modal-dialog-centered">
                            <div class="modal-content">
                                <form action="${pageContext.request.contextPath}/AdminServlet" method="post">
                                    <div class="modal-header">
                                        <h5 class="modal-title"><i class="fas fa-edit me-2"></i>Edit Trip</h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>
                                    <div class="modal-body">
                                        <input type="hidden" name="action" value="updateTrip">
                                        <input type="hidden" name="tripId" value="<%= trip.getId()%>">
                                        <div class="mb-3">
                                            <label class="form-label">Origin</label>
                                            <input type="text" name="origin" class="form-control" value="<%= trip.getOrigin()%>" required>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label">Destination</label>
                                            <input type="text" name="destination" class="form-control" value="<%= trip.getDestination()%>" required>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label">Date</label>
                                            <input type="date" name="date" class="form-control" value="<%= trip.getDate()%>" required
                                                   min="<%= java.time.LocalDate.now().plusDays(1).toString()%>">
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label">Time</label>
                                            <input type="time" name="time" class="form-control" value="<%= trip.getTime().toString().substring(0, 5)%>" required>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label">Capacity</label>
                                            <input type="number" name="capacity" class="form-control" value="<%= trip.getCapacity()%>" min="1" max="55" required>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label">Travel Type</label>
                                            <select name="travel_type" class="form-select" required>
                                                <option value="city" <%= "city".equals(trip.getTravelType()) ? "selected" : ""%>>City</option>
                                                <option value="inter_city" <%= "inter_city".equals(trip.getTravelType()) ? "selected" : ""%>>Inter City</option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                        <button type="submit" class="btn btn-primary">Save Changes</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                    <% } %>
                    <% }%>
                </div>
            </div>
        </div>

        <!-- Navigation Buttons -->
        <div class="text-center mt-4">
            <a href="adminDashboard.jsp" class="btn nav-btn m-2">
                <i class="fas fa-tachometer-alt me-2"></i>Dashboard
            </a>
            <a href="configureFare.jsp" class="btn nav-btn m-2">
                <i class="fas fa-tag me-2"></i>Manage Fares
            </a>
            <a href="${pageContext.request.contextPath}/ReportsServlet" class="btn nav-btn m-2">
                <i class="fas fa-chart-bar me-2"></i>View Reports
            </a>
            <form action="${pageContext.request.contextPath}/LogoutServlet" method="post" class="d-inline">
                <button type="submit" class="btn btn-logout m-2">
                    <i class="fas fa-sign-out-alt me-2"></i>Logout
                </button>
            </form>
        </div>
    </main>

    <!-- Bootstrap JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
                                    window.addEventListener('pageshow', function (event) {
                                        if (event.persisted) {
                                            // Page was loaded from bfcache (back-forward cache)
                                            window.location.reload();
                                        }
                                    });
    </script>

</body>
</html>