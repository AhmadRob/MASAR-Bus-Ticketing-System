<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="domain.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"passenger".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Check if we should activate the estimate tab
    String activeTab = (String) request.getAttribute("activeTab");
    if (activeTab == null) {
        activeTab = "search"; // Default to search tab
    }
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="icon" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/icons/train-front.svg" type="image/svg+xml">
        <title>Passenger Dashboard | Masar</title>
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
                padding: 2rem 0;
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

            .avatar {
                width: 40px;
                height: 40px;
                background-color: var(--accent);
                color: white;
                border-radius: 50%;
                font-weight: 600;
                display: flex;
                align-items: center;
                justify-content: center;
                transition: all 0.3s ease;
            }

            .avatar:hover {
                transform: scale(1.1);
            }

            .dropdown-menu {
                border-radius: 12px;
                border: none;
                box-shadow: 0 10px 30px rgba(0,0,0,0.1);
                margin-top: 10px;
            }

            .dropdown-item {
                padding: 0.5rem 1.5rem;
                transition: all 0.2s;
            }

            .dropdown-item:hover {
                background-color: rgba(66, 153, 225, 0.1);
                color: var(--primary);
            }

            .nav-pills .nav-link {
                color: var(--text);
                border-radius: 12px;
                transition: all 0.3s;
                margin-bottom: 0.5rem;
                padding: 0.75rem 1.25rem;
                display: flex;
                align-items: center;
            }

            .nav-pills .nav-link i {
                margin-right: 10px;
                width: 20px;
                text-align: center;
            }

            .nav-pills .nav-link.active {
                background: linear-gradient(135deg, var(--primary), var(--accent));
                color: white;
                box-shadow: 0 5px 15px rgba(26, 54, 93, 0.2);
            }

            .card {
                border: none;
                border-radius: 16px;
                background: white;
                box-shadow: 0 5px 15px rgba(0,0,0,0.05);
                transition: all 0.3s ease;
                overflow: hidden;
            }

            .card:hover {
                transform: translateY(-5px);
                box-shadow: 0 15px 30px rgba(0,0,0,0.1);
            }

            .card-header {
                background: white;
                border-bottom: 1px solid rgba(0,0,0,0.05);
                padding: 1.5rem;
            }

            .card-header h4 {
                font-family: 'Playfair Display', serif;
                font-weight: 600;
                color: var(--primary);
            }

            .tab-pane {
                animation: fadeIn 0.4s ease-out;
            }

            @keyframes fadeIn {
                from { opacity: 0; transform: translateY(10px); }
                to { opacity: 1; transform: translateY(0); }
            }

            .btn-dashboard {
                border-radius: 50px;
                padding: 0.8rem 1.5rem;
                font-weight: 600;
                letter-spacing: 0.5px;
                transition: all 0.3s;
                border: none;
                position: relative;
                overflow: hidden;
            }

            .btn-primary-dash {
                background: linear-gradient(135deg, var(--primary), var(--accent));
                color: white;
            }

            .btn-primary-dash:hover {
                box-shadow: 0 10px 20px rgba(26, 54, 93, 0.2);
                transform: translateY(-2px);
            }

            .sticky-top {
                top: 1.5rem;
            }

            .navbar {
                background: white;
                box-shadow: 0 2px 15px rgba(0,0,0,0.05);
                padding: 0.75rem 0;
            }

            .navbar-brand {
                font-family: 'Playfair Display', serif;
                font-weight: 700;
                color: var(--primary);
                font-size: 1.5rem;
            }

            .dropdown-toggle::after {
                display: none;
            }

            .user-menu-btn {
                background: none;
                border: none;
                color: var(--text);
                font-weight: 500;
                display: flex;
                align-items: center;
            }

            .user-menu-btn:hover {
                color: var(--primary);
            }
        </style>
    </head>
    <body>
        <!-- Header Section -->
        <header class="dashboard-header">
            <div class="container">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h1 class="dashboard-title">Passenger Dashboard</h1>
                        <p class="dashboard-subtitle">Welcome back, <%= user.getName()%></p>
                    </div>
                    <div class="d-flex align-items-center">
                        <div class="avatar me-2"><%= user.getName().charAt(0)%></div>
                        <div class="dropdown">
                            <button class="user-menu-btn" type="button" id="userMenu" data-bs-toggle="dropdown">
                                <i class="fas fa-caret-down ms-2"></i>
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end shadow">
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/TicketServlet"><i class="fas fa-ticket-alt me-2"></i>My Tickets</a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li>
                                    <form action="${pageContext.request.contextPath}/LogoutServlet" method="post">
                                        <button type="submit" class="dropdown-item text-danger"><i class="fas fa-sign-out-alt me-2"></i>Logout</button>
                                    </form>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </header>

        <!-- Main Content -->
        <div class="container-fluid mb-5">
            <div class="row">
                <!-- Sidebar -->
                <div class="col-md-3 mb-4">
                    <div class="card sticky-top">
                        <div class="card-body p-3">
                            <ul class="nav nav-pills flex-column">
                                <li class="nav-item">
                                    <a class="nav-link <%= activeTab.equals("search") ? "active" : ""%>" href="#search" data-bs-toggle="pill">
                                        <i class="fas fa-search"></i>Search Trips
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link <%= activeTab.equals("estimate") ? "active" : ""%>" href="#estimate" data-bs-toggle="pill">
                                        <i class="fas fa-calculator"></i>Estimate Fare
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link <%= activeTab.equals("purchase") ? "active" : ""%>" href="#purchase" data-bs-toggle="pill">
                                        <i class="fas fa-ticket-alt"></i>Purchase Ticket
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link" href="${pageContext.request.contextPath}/TicketServlet">
                                        <i class="fas fa-clipboard-list"></i>My Tickets
                                    </a>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>

                <!-- Tabs Panel -->
                <div class="col-md-9">
                    <div class="tab-content">
                        <div class="tab-pane fade <%= activeTab.equals("search") ? "show active" : ""%>" id="search">
                            <div class="card mb-4">
                                <div class="card-header">
                                    <h4 class="fw-bold">Search Available Trips</h4>
                                </div>
                                <div class="card-body">
                                    <jsp:include page="searchTrips.jsp" />
                                </div>
                            </div>
                        </div>
                        <div class="tab-pane fade <%= activeTab.equals("estimate") ? "show active" : ""%>" id="estimate">
                            <div class="card mb-4">
                                <div class="card-header">
                                    <h4 class="fw-bold">Fare Estimation</h4>
                                </div>
                                <div class="card-body">
                                    <jsp:include page="fareEstimation.jsp" />
                                </div>
                            </div>
                        </div>
                        <div class="tab-pane fade <%= activeTab.equals("purchase") ? "show active" : ""%>" id="purchase">
                            <div class="card mb-4">
                                <div class="card-header">
                                    <h4 class="fw-bold">Purchase Ticket</h4>
                                </div>
                                <div class="card-body">
                                    <jsp:include page="purchaseTicket.jsp" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bootstrap JS Bundle with Popper -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                    document.addEventListener('DOMContentLoaded', function () {
                    // Get the active tab from the server-side attribute
                    const activeTab = '<%= activeTab%>';
                            // If we have an active tab specified, show it
                            if (activeTab && activeTab !== 'null') {
                    const tabElement = document.querySelector(`.nav - link[href = "#${activeTab}"]`);
                            if (tabElement) {
                    new bootstrap.Tab(tabElement).show();
                    }
                    }

                    // Add smooth transitions between tabs
                    const tabLinks = document.querySelectorAll('.nav-link[data-bs-toggle="pill"]');
                            tabLinks.forEach(link => {
                            link.addEventListener('click', function() {
                            document.querySelectorAll('.nav-link').forEach(navLink => {
                            navLink.classList.remove('active');
                            });
                                    this.classList.add('active');
                            });
                            });
                    });
        </script>
    </body>
</html>