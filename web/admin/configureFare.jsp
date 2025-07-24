<%@page import="util.FareConfig"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="icon" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/icons/train-front.svg" type="image/svg+xml">
        <title>Fare Configuration | Masar</title>
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
                padding: 2rem 0;
                margin-bottom: 2rem;
                border-radius: 0 0 20px 20px;
                box-shadow: 0 4px 20px rgba(26, 54, 93, 0.1);
            }

            .page-title {
                font-family: 'Playfair Display', serif;
                font-weight: 700;
                margin-bottom: 0.5rem;
            }

            .config-card {
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

            .card-body {
                padding: 1.5rem;
            }

            .form-label {
                font-weight: 500;
                color: var(--dark);
                margin-bottom: 0.5rem;
            }

            .form-control {
                border-radius: 8px;
                padding: 0.75rem 1rem;
                border: 1px solid #e2e8f0;
                transition: all 0.3s;
            }

            .form-control:focus {
                border-color: var(--accent);
                box-shadow: 0 0 0 0.25rem rgba(66, 153, 225, 0.25);
            }

            .form-group {
                margin-bottom: 1.5rem;
            }

            .btn-save {
                background: linear-gradient(135deg, var(--success), #38a169);
                color: white;
                border: none;
                border-radius: 50px;
                padding: 0.75rem 1.5rem;
                font-weight: 600;
                transition: all 0.3s;
            }

            .btn-save:hover {
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(72, 187, 120, 0.3);
            }

            .form-check-input:checked {
                background-color: var(--success);
                border-color: var(--success);
            }

            .form-check-label {
                margin-left: 0.5rem;
            }

            .alert-message {
                border-radius: 8px;
                padding: 1rem;
                margin-bottom: 1.5rem;
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

            @media (max-width: 768px) {
                .header-section {
                    padding: 1.5rem 0;
                }

                .card-body {
                    padding: 1rem;
                }
            }
        </style>
    </head>
    <body>
        <!-- Header Section -->
        <header class="header-section text-center">
            <div class="container">
                <h1 class="page-title">Fare Configuration</h1>
                <p class="text-white">Manage pricing and discount settings for Masar transportation</p>
            </div>
        </header>

        <main class="container mb-5">
            <!-- Message Alert -->
            <c:if test="${not empty message}">
                <div class="alert-message alert alert-success">
                    <i class="fas fa-check-circle me-2"></i>${message}
                </div>
            </c:if>

            <!-- Base Fare Configuration -->
            <div class="config-card">
                <div class="card-header">
                    <i class="fas fa-tag me-2"></i>Base Fares
                </div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/AdminServlet" method="post">
                        <input type="hidden" name="action" value="updateFare">
                        <input type="hidden" name="configType" value="baseFare">

                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">City Travel Base Fare (JD)</label>
                                    <div class="input-group">
                                        <input type="number" step="0.01" name="cityFare" class="form-control" 
                                               value= "<%=FareConfig.getInstance().getCityBaseFare()%>" required>
                                        <span class="input-group-text">JD</span>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">Inter-City Base Fare (JD)</label>
                                    <div class="input-group">
                                        <input type="number" step="0.01" name="interCityFare" class="form-control" 
                                               value="<%=FareConfig.getInstance().getInterCityBaseFare()%>" required>
                                        <span class="input-group-text">JD</span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="text-end">
                            <button type="submit" class="btn btn-save">
                                <i class="fas fa-save me-2"></i>Save Base Fares
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Discount Configuration -->
            <div class="config-card">
                <div class="card-header">
                    <i class="fas fa-percentage me-2"></i>Discount Settings
                </div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/AdminServlet" method="POST">
                        <input type="hidden" name="action" value="updateFare">
                        <input type="hidden" name="configType" value="discounts">

                        <div class="row">
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label class="form-label">Student Discount (%)</label>
                                    <div class="input-group">
                                        <input type="number" name="studentDiscount" class="form-control" min="0" max="100"
                                               value="<%=(FareConfig.getInstance().getStudentDiscount() * 100)%>" required>
                                        <span class="input-group-text">%</span>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label class="form-label">Senior Discount (%)</label>
                                    <div class="input-group">
                                        <input type="number" name="seniorDiscount" class="form-control" min="0" max="100"
                                               value="<%=(FareConfig.getInstance().getSeniorDiscount() * 100)%>" required>
                                        <span class="input-group-text">%</span>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label class="form-label">Evening Discount (%)</label>
                                    <div class="input-group">
                                        <input type="number" name="eveningDiscount" class="form-control" min="0" max="100"
                                               value="<%=(FareConfig.getInstance().getEveningDiscount()) * 100%>" required>
                                        <span class="input-group-text">%</span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="form-group form-check">
                            <input type="checkbox" name="discountCap" id="discountCap" class="form-check-input" 
                                   ${empty discounts.capEnabled or discounts.capEnabled ? 'checked' : ''}>
                            <label class="form-check-label" for="discountCap">Enable 50% Maximum Discount Cap</label>
                        </div>

                        <div class="text-end">
                            <button type="submit" class="btn btn-save">
                                <i class="fas fa-save me-2"></i>Save Discount Settings
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Navigation Buttons -->
            <div class="text-center mt-4">
                <a href="${adminPath}adminDashboard.jsp" class="btn nav-btn m-2">
                    <i class="fas fa-tachometer-alt me-2"></i>Dashboard
                </a>
                <a href="${adminPath}manageTrips.jsp" class="btn nav-btn m-2">
                    <i class="fas fa-route me-2"></i>Manage Trips
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