<%@page import="java.text.SimpleDateFormat"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page import="java.util.List"%>
<%@page import="domain.Ticket"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    if (session.getAttribute("user") == null) {
        response.sendRedirect("admin/adminLogin.jsp");
        return;
    }

    System.out.println((List<Ticket>) request.getAttribute("commonTickets"));

%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="icon" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/icons/train-front.svg" type="image/svg+xml">
        <title>Ticket Sales Reports | MASAR Admin</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/daterangepicker@3.1.0/daterangepicker.css">
        <style>
            :root {
                --primary: #1a365d;
                --secondary: #FFD700;
                --accent: #FFC000;
                --light: #f8f9fa;
                --dark: #1a202c;
            }

            body {
                background-color: #f5f7fa;
                font-family: 'Inter', sans-serif;
            }

            .sidebar {
                background-color: var(--primary);
                color: white;
                height: 100vh;
                position: fixed;
                width: 250px;
            }

            .main-content {
                margin-left: 250px;
                padding: 2rem;
            }

            .navbar-brand {
                font-weight: 700;
                color: var(--secondary);
            }

            .card {
                border: none;
                border-radius: 0.5rem;
                box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            }

            .card-header {
                background-color: white;
                border-bottom: 1px solid rgba(0,0,0,0.05);
            }

            .filter-card {
                background-color: white;
                border-radius: 0.5rem;
                box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            }

            .stats-card {
                background-color: white;
                border-left: 4px solid var(--secondary);
            }

            .badge-gold {
                background-color: var(--secondary);
                color: var(--dark);
            }

            .btn-gold {
                background-color: var(--secondary);
                color: var(--dark);
                border: none;
            }

            .btn-gold:hover {
                background-color: var(--accent);
                color: var(--dark);
            }

            .table th {
                background-color: var(--primary);
                color: white;
            }
        </style>
    </head>
    <body>
        <!-- Sidebar -->
        <div class="sidebar">
            <div class="p-4">
                <h4 class="navbar-brand">
                    <i class="bi bi-train-front"></i> MASAR Admin
                </h4>
            </div>
            <nav class="nav flex-column px-3">
                <a class="nav-link text-white" href="${adminPath}adminDashboard.jsp">
                    <i class="bi bi-speedometer2 me-2"></i> Dashboard
                </a>
                <a class="nav-link text-white" href="${adminPath}manageTrips.jsp">
                    <i class="bi bi-map me-2"></i> Trips
                </a>
                <a class="nav-link text-white" href="#">
                    <i class="bi bi-ticket-perforated me-2"></i> Tickets
                </a>
                <a class="nav-link active text-white" href="#">
                    <i class="bi bi-graph-up me-2"></i> Reports
                </a>
                <a class="nav-link text-white" href="#">
                    <i class="bi bi-people me-2"></i> Users
                </a>
                <div class="mt-auto p-3">
                    <a class="nav-link text-white" href="${pageContext.request.contextPath}/LogoutServlet">
                        <i class="bi bi-box-arrow-left me-2"></i> Logout
                    </a>
                </div>
            </nav>
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <!-- Header -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2 class="mb-0">
                    <i class="bi bi-graph-up me-2"></i> Ticket Sales Reports
                </h2>
                <div class="text-muted">
                    <i class="bi bi-calendar me-1"></i> <span id="currentDate"></span>
                </div>
            </div>

            <!-- Filters Card -->
            <div class="card filter-card mb-4">
                <div class="card-body">
                    <h5 class="card-title">
                        <i class="bi bi-funnel me-2"></i> Filter Reports
                    </h5>
                    <form id="reportFilters" method="get" action="${pageContext.request.contextPath}/ReportsServlet">
                        <div class="row g-3">
                            <div class="col-md-4">
                                <label for="dateRange" class="form-label">Date Range</label>
                                <input type="text" class="form-control" id="dateRange" name="dateRange" 
                                       value="${dateRangeParam}" placeholder="Select date range">
                            </div>
                            <div class="col-md-4">
                                <label for="ticketType" class="form-label">Ticket Type</label>
                                <select class="form-select" id="ticketType" name="ticketType">
                                    <option value="" ${empty param.ticketType ? 'selected' : ''}>All Types</option>
                                    <option value="one_trip" ${param.ticketType eq 'one_trip' ? 'selected' : ''}>One Trip</option>
                                    <option value="daily_pass" ${param.ticketType eq 'daily_pass' ? 'selected' : ''}>Daily Pass</option>
                                    <option value="weekly_pass" ${param.ticketType eq 'weekly_pass' ? 'selected' : ''}>Weekly Pass</option>
                                    <option value="monthly_pass" ${param.ticketType eq 'monthly_pass' ? 'selected' : ''}>Monthly Pass</option>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label for="userCategory" class="form-label">User Category</label>
                                <select class="form-select" id="userCategory" name="userCategory">
                                    <option value="" ${empty param.userCategory ? 'selected' : ''}>All Categories</option>
                                    <option value="regular" ${param.userCategory eq 'regular' ? 'selected' : ''}>Regular</option>
                                    <option value="student" ${param.userCategory eq 'student' ? 'selected' : ''}>Student</option>
                                    <option value="senior" ${param.userCategory eq 'senior' ? 'selected' : ''}>Senior</option>
                                </select>
                            </div>
                        </div>
                        <div class="d-flex justify-content-end mt-3">
                            <button type="reset" class="btn btn-outline-secondary me-2">
                                <i class="bi bi-arrow-counterclockwise me-1"></i> Reset
                            </button>
                            <button type="submit" class="btn btn-gold">
                                <i class="bi bi-filter-square me-1"></i> Apply Filters
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Summary Stats -->
            <div class="row mb-4">
                <div class="col-md-4">
                    <div class="card stats-card h-100">
                        <div class="card-body">
                            <h6 class="card-subtitle mb-2 text-muted">Total Tickets Sold</h6>
                            <h3 class="card-title">${not empty totalSoldTickets ? totalSoldTickets : 0}</h3>
                            <span class="badge bg-success">+12% from last period</span>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card stats-card h-100">
                        <div class="card-body">
                            <h6 class="card-subtitle mb-2 text-muted">Total Revenue</h6>
                            <h3 class="card-title">
                                <fmt:formatNumber value="${not empty totalRevenue ? totalRevenue : 0}" type="currency"/>
                            </h3>
                            <span class="badge bg-success">+8% from last period</span>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card stats-card h-100">
                        <div class="card-body">
                            <h6 class="card-subtitle mb-2 text-muted">Average Ticket Price</h6>
                            <h3 class="card-title">
                                <c:choose>
                                    <c:when test="${totalSoldTickets gt 0}">
                                        <fmt:formatNumber value="${totalRevenue/totalSoldTickets}" type="currency"/>
                                    </c:when>
                                    <c:otherwise>$0.00</c:otherwise>
                                </c:choose>
                            </h3>
                            <span class="badge bg-warning text-dark">-2% from last period</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Reports Table -->
            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h5 class="mb-0">
                        <i class="bi bi-table me-2"></i> Detailed Ticket Sales
                    </h5>
                    <button class="btn btn-sm btn-gold">
                        <i class="bi bi-download me-1"></i> Export
                    </button>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead>
                                <tr>
                                    <th>Date</th>
                                    <th>Ticket Type</th>
                                    <th>User Category</th>
                                    <th class="text-end">Tickets Sold</th>
                                    <th class="text-end">Revenue</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${commonTickets}" var="ticket">
                                    <tr>
                                        <td><fmt:formatDate value="${ticket.purchaseDate}" pattern="MMM dd, yyyy"/></td>
                                        <td>${ticket.ticketType.replace("_"," ")}</td>
                                        <td>${ticket.userCategory}</td>
                                        <td class="text-end"><fmt:formatNumber value="${ticket.fare}" type="currency"/></td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                            <tfoot>
                                <tr class="fw-bold">
                                    <td colspan="3">Total</td>
                                    <td class="text-end">${fn:length(commonTickets)}</td>
                                    <td class="text-end">
                                        <fmt:formatNumber value="${totalRevenue}" type="currency"/>
                                    </td>
                                </tr>
                            </tfoot>
                        </table>
                    </div>
                </div>
                <div class="card-footer bg-white">
                    <nav aria-label="Table navigation">
                        <ul class="pagination justify-content-center mb-0">
                            <li class="page-item disabled">
                                <a class="page-link" href="#" tabindex="-1">Previous</a>
                            </li>
                            <li class="page-item active"><a class="page-link" href="#">1</a></li>
                            <li class="page-item"><a class="page-link" href="#">2</a></li>
                            <li class="page-item"><a class="page-link" href="#">3</a></li>
                            <li class="page-item">
                                <a class="page-link" href="#">Next</a>
                            </li>
                        </ul>
                    </nav>
                </div>
            </div>
        </div>

        <!-- jQuery -->
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <!-- Date Range Picker -->
        <script src="https://cdn.jsdelivr.net/npm/moment@2.29.1/moment.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/daterangepicker@3.1.0/daterangepicker.min.js"></script>

        <script>
                    // Set current date
                    document.getElementById('currentDate').textContent = moment().format('MMMM D, YYYY');
                    // Initialize date range picker with previous values
                    $(function() {
                    // Get previous values or set defaults
                    let startDate = moment().subtract(29, 'days');
                            let endDate = moment();
                            // If we have a previous date range value
                            if ('${not empty param.dateRange}') {
                    const parts = '${param.dateRange}'.split(' - ');
                            if (parts.length === 2) {
                    startDate = moment(parts[0].trim(), 'MMM D, YYYY');
                            endDate = moment(parts[1].trim(), 'MMM D, YYYY');
                    }
                    }

                    $('#dateRange').daterangepicker({
                    opens: 'left',
                            locale: {
                            format: 'MMM D, YYYY'
                            },
                            startDate: startDate,
                            endDate: endDate
                    }, function(start, end) {
                    // Update the visible field value when dates change
                    $('#dateRange').val(start.format('MMM D, YYYY') + ' - ' + end.format('MMM D, YYYY'));
                    });
                            // Set initial value if coming from a submission
                            if ('${not empty param.dateRange}') {
                    $('#dateRange').val('${param.dateRange}');
                    }
                    });
        </script>
    </body>
</html>