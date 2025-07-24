<%@page import="java.time.LocalTime"%>
<%@page import="dao.TripDAO"%>
<%@page import="java.util.List"%>
<%@page import="domain.Trip"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    if (session.getAttribute("user") == null) {
        response.sendRedirect("adminLogin.jsp");
        return;
    }

    List<Trip> trips = (List<Trip>) session.getAttribute("trips");
    int tripCount = trips.size();
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="icon" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/icons/train-front.svg" type="image/svg+xml">

        <title>Admin Dashboard | Masar</title>
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
            }

            body {
                font-family: 'Inter', sans-serif;
                background-color: #f5f7fa;
                color: var(--text);
                min-height: 100vh;
            }

            .dashboard-header {
                background: linear-gradient(135deg, var(--primary), var(--accent));
                color: white;
                padding: 3rem 0;
                margin-bottom: 2rem;
                border-radius: 0 0 20px 20px;
                box-shadow: 0 4px 20px rgba(26, 54, 93, 0.1);
            }

            .dashboard-title {
                font-family: 'Playfair Display', serif;
                font-weight: 700;
                margin-bottom: 0.5rem;
            }

            .dashboard-subtitle {
                opacity: 0.9;
                margin-bottom: 1.5rem;
            }

            .clock-display {
                background: rgba(255,255,255,0.2);
                padding: 0.5rem 1rem;
                border-radius: 50px;
                display: inline-block;
                font-weight: 600;
            }

            .stat-card {
                border: none;
                border-radius: 16px;
                background: white;
                box-shadow: 0 5px 15px rgba(0,0,0,0.05);
                transition: all 0.3s ease;
                height: 100%;
                position: relative;
                overflow: hidden;
            }

            .stat-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 15px 30px rgba(0,0,0,0.1);
            }

            .stat-card::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 5px;
                background: linear-gradient(90deg, var(--secondary), var(--accent));
            }

            .stat-icon {
                font-size: 2rem;
                color: var(--primary);
                margin-bottom: 1rem;
            }

            .stat-value {
                font-size: 2.5rem;
                font-weight: 700;
                color: var(--primary);
                margin: 1rem 0;
            }

            .action-card {
                border: none;
                border-radius: 16px;
                background: white;
                box-shadow: 0 5px 15px rgba(0,0,0,0.05);
                padding: 2rem;
            }

            .btn-dashboard {
                border-radius: 50px;
                padding: 0.8rem 1.5rem;
                font-weight: 600;
                letter-spacing: 0.5px;
                transition: all 0.3s;
                margin: 0.5rem;
                min-width: 180px;
                position: relative;
                overflow: hidden;
                border: none;
            }

            .btn-dashboard:hover {
                transform: translateY(-2px);
            }

            .btn-primary-dash {
                background: linear-gradient(135deg, var(--primary), var(--accent));
                color: white;
            }

            .btn-primary-dash:hover {
                box-shadow: 0 10px 20px rgba(26, 54, 93, 0.2);
            }

            .btn-secondary-dash {
                background: linear-gradient(135deg, var(--secondary), #f6e05e);
                color: var(--dark);
            }

            .btn-secondary-dash:hover {
                box-shadow: 0 10px 20px rgba(236, 201, 75, 0.2);
            }

            .btn-danger-dash {
                background: linear-gradient(135deg, #f56565, #e53e3e);
                color: white;
            }

            .btn-danger-dash:hover {
                box-shadow: 0 10px 20px rgba(245, 101, 101, 0.2);
            }

            @media (max-width: 768px) {
                .btn-dashboard {
                    width: 100%;
                    margin: 0.5rem 0;
                }
            }
        </style>
    </head>
    <body>
        <!-- Header Section -->
        <header class="dashboard-header text-center">
            <div class="container">
                <h1 class="dashboard-title">Admin Dashboard</h1>
                <p class="dashboard-subtitle">Manage your Masar transportation system with precision</p>
                <div class="clock-display">
                    <i class="fas fa-clock me-2"></i>
                    <span id="clock">Loading ...</span>
                    <span id = "date"></span>
                </div>
            </div>
        </header>

        <main class="container mb-5">
            <!-- Stats Section -->
            <div class="row justify-content-center mb-4">
                <div class="col-md-4 mb-4">
                    <div class="stat-card text-center p-4">
                        <i class="fas fa-route stat-icon"></i>
                        <div class="stat-value"><%= tripCount%></div>
                        <h5>Total Trips</h5>
                        <p class="text-muted">Active in the system</p>
                    </div>
                </div>
            </div>

            <!-- Actions Section -->
            <div class="action-card text-center">
                <h4 class="mb-4">Management Actions</h4>
                <div class="d-flex flex-wrap justify-content-center">
                    <a href="${adminPath}manageTrips.jsp" class="btn btn-primary-dash btn-dashboard">
                        <i class="fas fa-route me-2"></i>Manage Trips
                    </a>
                    <a href="${adminPath}configureFare.jsp" class="btn btn-secondary-dash btn-dashboard">
                        <i class="fas fa-tag me-2"></i>Manage Fares
                    </a>
                    <a href="${pageContext.request.contextPath}/ReportsServlet" class="btn btn-primary-dash btn-dashboard">
                        <i class="fas fa-chart-bar me-2"></i>View Reports
                    </a>
                    <form action="${pageContext.request.contextPath}/LogoutServlet" method="post" class="d-inline">
                        <button type="submit" class="btn btn-danger-dash btn-dashboard">
                            <i class="fas fa-sign-out-alt me-2"></i>Logout
                        </button>
                    </form>
                </div>
            </div>
        </main>

        <!-- Bootstrap JS Bundle with Popper -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                    function updateClock() {
                    const now = new Date();
                            const timeString = now.toLocaleTimeString();
                            const dateString = now.toLocaleDateString();
                            document.getElementById('clock').textContent = timeString;
                            document.getElementById('date').textContent = dateString;
                    }
            setInterval(updateClock, 1000);
                    updateClock(); // Initial call
        </script>
        <script>
                    window.addEventListener('pageshow', function(event) {
                    if (event.persisted) {
                    // Page was loaded from bfcache (back-forward cache)
                    window.location.reload();
                    }
                    });
        </script>
    </body>
</html>