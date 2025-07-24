<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/icons/train-front.svg" type="image/svg+xml">
    <title>Error | Masar</title>
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
            --error: #f56565;
        }
        
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f5f7fa;
            color: var(--text);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        
        .error-container {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem;
        }
        
        .error-card {
            border: none;
            border-radius: 16px;
            background: white;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            max-width: 600px;
            width: 100%;
            overflow: hidden;
            text-align: center;
        }
        
        .error-header {
            background: linear-gradient(135deg, var(--error), #e53e3e);
            color: white;
            padding: 2rem;
        }
        
        .error-title {
            font-family: 'Playfair Display', serif;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }
        
        .error-icon {
            font-size: 3rem;
            margin-bottom: 1rem;
        }
        
        .error-body {
            padding: 2rem;
        }
        
        .error-message {
            font-size: 1.1rem;
            margin-bottom: 2rem;
            color: var(--dark);
        }
        
        .btn-primary {
            background: linear-gradient(135deg, var(--primary), var(--accent));
            border: none;
            border-radius: 50px;
            padding: 0.75rem 1.5rem;
            font-weight: 600;
            transition: all 0.3s;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(26, 54, 93, 0.3);
        }
        
        .navbar {
            background: linear-gradient(135deg, var(--primary), var(--accent));
            color: white;
            padding: 1rem 0;
            box-shadow: 0 4px 20px rgba(26, 54, 93, 0.1);
        }
        
        .navbar-brand {
            font-family: 'Playfair Display', serif;
            font-weight: 700;
            color: white;
            font-size: 1.5rem;
        }
        
        footer {
            background: var(--dark);
            color: white;
            padding: 1.5rem 0;
            text-align: center;
        }
    </style>
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar">
        <div class="container">
            <a class="navbar-brand" href="#">MASAR</a>
        </div>
    </nav>

    <!-- Error Content -->
    <div class="error-container">
        <div class="error-card">
            <div class="error-header">
                <div class="error-icon">
                    <i class="fas fa-exclamation-triangle"></i>
                </div>
                <h1 class="error-title">Oops! Something Went Wrong</h1>
            </div>
            <div class="error-body">
                <p class="error-message">
                    <c:choose>
                        <c:when test="${not empty error}">
                            ${error}
                        </c:when>
                        <c:otherwise>
                            We encountered an unexpected error while processing your request.
                        </c:otherwise>
                    </c:choose>
                </p>
                <a href="passengerDashboard.jsp" class="btn btn-primary">
                    <i class="fas fa-arrow-left me-2"></i>Return to Dashboard
                </a>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer>
        <div class="container">
            <p class="mb-0">&copy; 2025 Masar Bus System. All rights reserved.</p>
        </div>
    </footer>

    <!-- Bootstrap JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>