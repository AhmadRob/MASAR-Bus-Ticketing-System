<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="icon" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/icons/train-front.svg" type="image/svg+xml">
        <title>Passenger Registration | Masar Bus System</title>
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <!-- Google Fonts -->
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Playfair+Display:wght@400;500;600;700&display=swap" rel="stylesheet">
        <!-- AOS Animation -->
        <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
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
                background: linear-gradient(rgba(248, 249, 250, 0.9), rgba(248, 249, 250, 0.9)), 
                    url('https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1920&q=80') no-repeat center center;
                background-size: cover;
                min-height: 100vh;
                color: var(--text);
            }

            .register-container {
                display: flex;
                align-items: center;
                justify-content: center;
                min-height: 100vh;
                padding: 2rem;
            }

            .register-card {
                border: none;
                border-radius: 16px;
                overflow: hidden;
                box-shadow: 0 15px 40px rgba(26, 54, 93, 0.15);
                transition: all 0.3s ease;
                background: white;
                width: 100%;
                max-width: 500px;
                position: relative;
                z-index: 1;
                transform-style: preserve-3d;
                perspective: 1000px;
            }

            .register-card::before {
                content: '';
                position: absolute;
                top: -10px;
                left: -10px;
                right: -10px;
                bottom: -10px;
                background: linear-gradient(135deg, var(--primary), var(--accent));
                z-index: -1;
                border-radius: 20px;
                opacity: 0.1;
                transform: translateZ(-20px);
            }

            .register-card:hover {
                transform: translateY(-5px) rotateX(1deg) rotateY(1deg);
                box-shadow: 0 20px 50px rgba(26, 54, 93, 0.25);
            }

            .card-header {
                background: linear-gradient(135deg, var(--primary), var(--accent));
                color: white;
                text-align: center;
                padding: 2rem;
                position: relative;
                overflow: hidden;
            }

            .card-header::after {
                content: '';
                position: absolute;
                bottom: 0;
                left: 0;
                width: 100%;
                height: 4px;
                background: rgba(255,255,255,0.3);
            }

            .card-header h3 {
                font-family: 'Playfair Display', serif;
                font-weight: 700;
                margin-bottom: 0.5rem;
            }

            .card-body {
                padding: 2.5rem;
            }

            .form-label {
                font-weight: 600;
                color: var(--dark);
                margin-bottom: 0.5rem;
            }

            .form-control {
                border-radius: 50px;
                padding: 12px 20px;
                border: 1px solid #e2e8f0;
                transition: all 0.3s;
                background-color: var(--light);
            }

            .form-control:focus {
                border-color: var(--accent);
                box-shadow: 0 0 0 0.25rem rgba(66, 153, 225, 0.25);
            }

            .input-icon {
                position: relative;
            }

            .input-icon i {
                position: absolute;
                right: 20px;
                top: 50%;
                transform: translateY(-50%);
                color: var(--primary);
            }

            .password-container {
                position: relative;
            }

            .password-toggle {
                position: absolute;
                right: 20px;
                top: 50%;
                transform: translateY(-50%);
                color: var(--primary);
                cursor: pointer;
                z-index: 2;
            }

            .btn-register {
                background: linear-gradient(135deg, var(--secondary), #f6e05e);
                color: var(--dark);
                border: none;
                border-radius: 50px;
                padding: 12px;
                font-weight: 600;
                letter-spacing: 0.5px;
                transition: all 0.3s;
                position: relative;
                overflow: hidden;
                width: 100%;
            }

            .btn-register:hover {
                transform: translateY(-2px);
                box-shadow: 0 10px 20px rgba(236, 201, 75, 0.3);
            }

            .btn-register::after {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: linear-gradient(rgba(255,255,255,0.3), rgba(255,255,255,0));
                opacity: 0;
                transition: opacity 0.3s;
            }

            .btn-register:hover::after {
                opacity: 1;
            }

            .alert-error {
                background-color: rgba(245, 101, 101, 0.1);
                border: 1px solid var(--error);
                color: var(--error);
                border-radius: 10px;
                animation: shake 0.5s;
            }

            @keyframes shake {
                0%, 100% { transform: translateX(0); }
                20%, 60% { transform: translateX(-5px); }
                40%, 80% { transform: translateX(5px); }
            }

            .footer-links {
                text-align: center;
                margin-top: 1.5rem;
            }

            .footer-links a {
                color: var(--primary);
                text-decoration: none;
                transition: color 0.3s;
                font-weight: 500;
            }

            .footer-links a:hover {
                color: var(--accent);
                text-decoration: underline;
            }

            .password-strength {
                height: 5px;
                margin-top: 5px;
                border-radius: 5px;
                transition: all 0.3s;
                background-color: #e2e8f0;
                overflow: hidden;
            }

            .progress-bar {
                height: 100%;
                transition: width 0.3s ease;
                background: linear-gradient(90deg, #f56565, #f6ad55, #48bb78);
            }

            .password-hints {
                font-size: 0.8rem;
                color: var(--text);
                margin-top: 10px;
            }

            .password-hints ul {
                padding-left: 20px;
                margin-bottom: 0;
            }

            .password-hints li {
                margin-bottom: 5px;
                position: relative;
            }

            .password-hints li i {
                margin-right: 5px;
                font-size: 0.6rem;
            }

            .valid {
                color: var(--success);
            }

            .invalid {
                color: var(--text);
                opacity: 0.7;
            }

            .bus-decoration {
                position: absolute;
                width: 150px;
                height: 80px;
                background: url('https://cdn.dribbble.com/users/1753953/screenshots/15276156/media/0a2b8b9c5f8b4e8e8b0b0b0b0b0b0b0b.png') no-repeat center center;
                background-size: contain;
                opacity: 0.1;
                z-index: 0;
            }

            .bus-1 {
                top: 10%;
                left: 5%;
                animation: float 6s ease-in-out infinite;
            }

            .bus-2 {
                bottom: 10%;
                right: 5%;
                animation: float 6s ease-in-out infinite 1s;
            }

            @keyframes float {
                0% { transform: translateY(0) rotate(0deg); }
                50% { transform: translateY(-20px) rotate(2deg); }
                100% { transform: translateY(0) rotate(0deg); }
            }

            @media (max-width: 768px) {
                .register-container {
                    padding: 1rem;
                }

                .card-body {
                    padding: 1.5rem;
                }

                .bus-decoration {
                    display: none;
                }
            }
        </style>
    </head>
    <body>
        <div class="register-container">
            <!-- Decorative bus elements -->
            <div class="bus-decoration bus-1"></div>
            <div class="bus-decoration bus-2"></div>

            <div class="register-card" data-aos="zoom-in">
                <div class="card-header">
                    <h3>
                        <i class="fas fa-user-plus me-2"></i>Create Your Masar Account
                    </h3>
                    <p class="mb-0">Join thousands of travelers enjoying premium bus services</p>
                </div>

                <div class="card-body">
                    <form action="RegisterServlet" method="post" class="needs-validation" novalidate>
                        <div class="mb-4">
                            <label for="name" class="form-label">Full Name</label>
                            <div class="input-icon">
                                <input type="text" class="form-control" id="name" name="name" 
                                       placeholder="Enter your full name" required
                                       pattern="[A-Za-z ]{3,}">
                                <i class="fas fa-user"></i>
                            </div>
                            <div class="invalid-feedback">
                                Please provide your full name (letters only, min 3 characters).
                            </div>
                        </div>

                        <div class="mb-4">
                            <label for="email" class="form-label">Email Address</label>
                            <div class="input-icon">
                                <input type="email" class="form-control" id="email" name="email" 
                                       placeholder="Enter your email" required
                                       pattern="[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$">
                                <i class="fas fa-envelope"></i>
                            </div>
                            <div class="invalid-feedback">
                                Please provide a valid email address (e.g., user@example.com).
                            </div>
                        </div>

                        <div class="mb-4">
                            <label for="password" class="form-label">Password</label>
                            <div class="password-container">
                                <input type="password" class="form-control" id="password" name="password" 
                                       placeholder="Create a password" required
                                       minlength="8"
                                       pattern="^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$">
                                <i class="fas fa-eye password-toggle" id="togglePassword"></i>
                            </div>
                            <div class="progress mt-2 password-strength">
                                <div class="progress-bar" role="progressbar" style="width: 0%"></div>
                            </div>
                            <div class="password-hints">
                                <ul>
                                    <li class="invalid" id="length"><i class="fas fa-circle"></i> Minimum 8 characters</li>
                                    <li class="invalid" id="uppercase"><i class="fas fa-circle"></i> At least one uppercase letter</li>
                                    <li class="invalid" id="lowercase"><i class="fas fa-circle"></i> At least one lowercase letter</li>
                                    <li class="invalid" id="number"><i class="fas fa-circle"></i> At least one number</li>
                                    <li class="invalid" id="special"><i class="fas fa-circle"></i> At least one special character</li>
                                </ul>
                            </div>
                            <div class="invalid-feedback">
                                Password must be at least 8 characters with uppercase, lowercase, number, and special character.
                            </div>
                        </div>

                        <div class="d-grid mb-4">
                            <button type="submit" class="btn btn-register">
                                <i class="fas fa-user-plus me-2"></i>Register Now
                            </button>
                        </div>

                        <c:if test="${not empty error}">
                            <div class="alert alert-error alert-dismissible fade show text-center mb-4">
                                <i class="fas fa-exclamation-circle me-2"></i>${error}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <div class="footer-links">
                            <p class="mb-0">Already have an account? <a href="login.jsp">Sign in here</a></p>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Bootstrap JS Bundle with Popper -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <!-- AOS Animation -->
        <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
        <script>
                    // Initialize AOS animation
                    AOS.init({
                    once: true,
                            duration: 800
                    });
                    // Form validation
                            (function() {
                            'use strict'

                                    const forms = document.querySelectorAll('.needs-validation')

                                    Array.from(forms).forEach(form => {
                            form.addEventListener('submit', event => {
                            if (!form.checkValidity()) {
                            event.preventDefault()
                                    event.stopPropagation()
                            }

                            form.classList.add('was-validated')
                            }, false)
                            })
                            })()

                            // Password visibility toggle
                            const togglePassword = document.querySelector('#togglePassword');
                            const password = document.querySelector('#password');
                            togglePassword.addEventListener('click', function() {
                            const type = password.getAttribute('type') === 'password' ? 'text' : 'password';
                                    password.setAttribute('type', type);
                                    this.classList.toggle('fa-eye');
                                    this.classList.toggle('fa-eye-slash');
                            });
                            // Password strength meter
                            password.addEventListener('input', function() {
                            const value = password.value;
                                    const strengthBar = document.querySelector('.progress-bar');
                                    const hints = {
                                    length: document.getElementById('length'),
                                            uppercase: document.getElementById('uppercase'),
                                            lowercase: document.getElementById('lowercase'),
                                            number: document.getElementById('number'),
                                            special: document.getElementById('special')
                                    };
                                    // Check password requirements
                                    const hasLength = value.length >= 8;
                                    const hasUppercase = /[A-Z]/.test(value);
                                    const hasLowercase = /[a-z]/.test(value);
                                    const hasNumber = /\d/.test(value);
                                    const hasSpecial = /[@$!%*?&]/.test(value);
                                    // Update hints
                                    hints.length.classList.toggle('valid', hasLength);
                                    hints.uppercase.classList.toggle('valid', hasUppercase);
                                    hints.lowercase.classList.toggle('valid', hasLowercase);
                                    hints.number.classList.toggle('valid', hasNumber);
                                    hints.special.classList.toggle('valid', hasSpecial);
                                    // Calculate strength (0-100)
                                    let strength = 0;
                                    if (hasLength) strength += 20;
                                    if (hasUppercase) strength += 20;
                                    if (hasLowercase) strength += 20;
                                    if (hasNumber) strength += 20;
                                    if (hasSpecial) strength += 20;
                                    // Update strength bar
                                    strengthBar.style.width = strength + '%';
                                    // Change color based on strength
                                    if (strength < 40) {
                            strengthBar.style.background = '#f56565';
                            } else if (strength < 80) {
                            strengthBar.style.background = '#f6ad55';
                            } else {
                            strengthBar.style.background = '#48bb78';
                            }
                            });
                            // Add animation to error message if present
                            document.addEventListener('DOMContentLoaded', function() {
                            const errorAlert = document.querySelector('.alert-error');
                                    if (errorAlert) {
                            errorAlert.classList.add('animate__animated', 'animate__shakeX');
                            }
                            });
                            // 3D card effect
                            const card = document.querySelector('.register-card');
                            if (card) {
                    card.addEventListener('mousemove', (e) => {
                    const xAxis = (window.innerWidth / 2 - e.pageX) / 25;
                            const yAxis = (window.innerHeight / 2 - e.pageY) / 25;
                            card.style.transform = `rotateY(${xAxis}deg) rotateX(${yAxis}deg)`;
                    });
                            card.addEventListener('mouseenter', () => {
                            card.style.transition = 'none';
                            });
                            card.addEventListener('mouseleave', () => {
                            card.style.transition = 'all 0.5s ease';
                                    card.style.transform = 'rotateY(0deg) rotateX(0deg)';
                            });
                    }
        </script>
    </body>
</html>