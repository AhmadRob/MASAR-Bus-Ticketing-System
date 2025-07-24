<%@page import="dao.TripDAO"%>
<%@page import="dao.TicketDAO"%>
<%@page import="domain.Trip"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="domain.Ticket" %>
<%@ page import="domain.User" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"passenger".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<Ticket> tickets = (List<Ticket>) request.getAttribute("tickets");
    List<Trip> trips = (List<Trip>) request.getAttribute("trips");

    SimpleDateFormat dateFormat = new SimpleDateFormat("EEE, MMM d, yyyy");
    SimpleDateFormat timeFormat = new SimpleDateFormat("h:mm a");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="icon" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/icons/train-front.svg" type="image/svg+xml">
        <title>My Tickets | MASAR</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
        <style>
            :root {
                --primary: #1a365d;
                --secondary: #FFD700; /* Bright gold */
                --accent: #FFC000; /* Slightly deeper gold */
                --light: #f8f9fa;
                --dark: #1a202c;
                --gold-light: #FFF5BA;
                --gold-dark: #D4A017;
                --gold-gradient: linear-gradient(135deg, #FFD700, #FFC000, #FFD700);
                --gold-text-gradient: linear-gradient(135deg, #FFD700, #FFC000);
            }

            body {
                background-color: #f5f7fa;
                font-family: 'Inter', sans-serif;
            }

            /* MASAR Branding */
            .masar-brand {
                font-family: 'Playfair Display', serif;
                font-weight: 700;
                background: var(--gold-text-gradient);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                text-shadow: 0 2px 4px rgba(0,0,0,0.1);
                letter-spacing: 1px;
                position: relative;
            }

            .masar-brand::after {
                content: '';
                position: absolute;
                bottom: -5px;
                left: 0;
                width: 100%;
                height: 2px;
                background: var(--gold-gradient);
                border-radius: 2px;
            }

            /* Ticket Styling */
            .ticket-card {
                border-left: 5px solid var(--accent);
                border-radius: 12px;
                transition: all 0.3s ease;
                overflow: hidden;
                position: relative;
                background: white;
                box-shadow: 0 4px 20px rgba(0,0,0,0.05);
                border-top: 1px solid var(--gold-light);
            }

            .ticket-card::before {
                content: "";
                position: absolute;
                top: 0;
                bottom: 0;
                left: 20px;
                width: 2px;
                background: repeating-linear-gradient(
                    to bottom,
                    transparent,
                    transparent 10px,
                    var(--gold-light) 10px,
                    var(--gold-light) 20px
                    );
            }

            .ticket-card:hover {
                transform: translateY(-5px) scale(1.02);
                box-shadow: 0 10px 25px rgba(0,0,0,0.1), 0 0 20px rgba(255, 215, 0, 0.3);
            }

            .badge-city {
                background: linear-gradient(135deg, var(--primary), #63b3ed);
                color: white;
            }

            .badge-intercity {
                background: var(--gold-gradient);
                color: var(--dark);
                font-weight: bold;
                text-shadow: 0 1px 1px rgba(0,0,0,0.1);
                border: 1px solid rgba(255,255,255,0.3);
            }

            .qr-code {
                width: 80px;
                height: 80px;
                background: linear-gradient(135deg, var(--gold-light), white);
                display: flex;
                align-items: center;
                justify-content: center;
                border-radius: 8px;
                border: 1px dashed var(--accent);
                box-shadow: 0 2px 8px rgba(255, 215, 0, 0.2);
            }

            /* Golden Accents */
            .gold-divider {
                height: 3px;
                background: var(--gold-gradient);
                border: none;
                margin: 15px 0;
                opacity: 0.8;
            }

            .gold-text {
                background: var(--gold-text-gradient);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                font-weight: bold;
            }

            /* Ticket Perforation Animation */
            @keyframes ticketReveal {
                0% { transform: scaleY(0); opacity: 0; }
                50% { transform: scaleY(0.5); opacity: 0.5; }
                100% { transform: scaleY(1); opacity: 1; }
            }

            .ticket-animate {
                animation: ticketReveal 0.8s cubic-bezier(0.175, 0.885, 0.32, 1.275) forwards;
                transform-origin: top center;
                opacity: 0;
            }

            /* Header Styling */
            .navbar {
                background: linear-gradient(135deg, var(--primary), #2c5282);
                box-shadow: 0 2px 15px rgba(26, 54, 93, 0.2);
                border-bottom: 2px solid var(--accent);
            }

            .navbar-brand {
                font-weight: 700;
                font-size: 1.5rem;
            }

            /* Section Styling */
            .tickets-section {
                background: url('data:image/svg+xml;utf8,<svg width="100" height="100" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><path d="M0 0 L100 0 L100 100 L0 100 Z" fill="none" stroke="%23e2e8f0" stroke-width="0.5" stroke-dasharray="5,5"/></svg>');
            }

            /* Empty State */
            .empty-state {
                background: white;
                border-radius: 16px;
                box-shadow: 0 5px 15px rgba(0,0,0,0.05);
                border: 1px solid var(--gold-light);
            }

            /* Button Styling */
            .btn-outline-primary {
                border-color: var(--accent);
                color: var(--accent);
                background: transparent;
            }

            .btn-outline-primary:hover {
                background: var(--gold-gradient);
                color: var(--dark);
                border-color: transparent;
                box-shadow: 0 4px 12px rgba(255, 215, 0, 0.3);
            }

            /* Golden Price Tag */
            .gold-price {
                background: var(--gold-text-gradient);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                font-weight: bold;
                font-size: 1.5rem;
                text-shadow: 0 1px 2px rgba(0,0,0,0.1);
            }

            /* 3D Effect for Tickets */
            .ticket-3d {
                position: relative;
                z-index: 1;
            }

            .ticket-3d::after {
                content: '';
                position: absolute;
                top: 5px;
                left: 5px;
                right: 5px;
                bottom: 0;
                background: linear-gradient(to bottom, rgba(255, 215, 0, 0.1), rgba(255, 215, 0, 0.3));
                border-radius: 8px;
                z-index: -1;
                filter: blur(8px);
                opacity: 0;
                transition: opacity 0.3s ease;
            }

            .ticket-3d:hover::after {
                opacity: 0.6;
            }

            /* MASAR Logo Effect */
            .masar-logo {
                position: relative;
                display: inline-block;
            }

            /* Scissors animation for empty state */
            @keyframes scissorsCut {
                0% { transform: translateY(0) rotate(0deg); }
                100% { transform: translateY(-10px) rotate(10deg); }
            }

            /* Staggered ticket animation */
            @keyframes ticketReveal {
                0% { 
                    transform: perspective(500px) rotateX(90deg);
                    opacity: 0;
                }
                100% { 
                    transform: perspective(500px) rotateX(0);
                    opacity: 1;
                }
            }

            /* MASAR brand glow */
            @keyframes masarGlow {
                0% { text-shadow: 0 0 5px rgba(255, 215, 0, 0.5); }
                50% { text-shadow: 0 0 15px rgba(255, 215, 0, 0.8); }
                100% { text-shadow: 0 0 5px rgba(255, 215, 0, 0.5); }
            }

            /* Enhanced gold elements */
            .gold-bg {
                background: var(--gold-gradient);
            }

            .gold-hover:hover {
                box-shadow: 0 0 15px rgba(255, 215, 0, 0.4);
            }

            .gold-border {
                border: 1px solid var(--accent);
            }

            /* Enhanced ticket header */
            .ticket-header {
                background: linear-gradient(to right, white, var(--gold-light), white);
                border-bottom: 1px solid var(--gold-light);
            }
        </style>
    </head>
    <body>
        <!-- Navigation -->
        <nav class="navbar navbar-expand-lg navbar-dark">
            <div class="container">
                <a class="navbar-brand fw-bold" href="#">
                    <i class="bi bi-train-front me-2 gold-text"></i> <span class="masar-brand masar-logo">MASAR</span>
                </a>
                <div class="d-flex align-items-center">
                    <div class="dropdown">
                        <button class="btn btn-link text-white dropdown-toggle" type="button" id="userMenu" data-bs-toggle="dropdown">
                            <i class="bi bi-person-circle me-1"></i> <%= user.getName()%>
                        </button>
                        <ul class="dropdown-menu dropdown-menu-end shadow">
                            <li><a class="dropdown-item" href="passengerDashboard.jsp"><i class="bi bi-house-door me-2"></i>Dashboard</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li>
                                <form action="${pageContext.request.contextPath}/LogoutServlet" method="post">
                                    <button type="submit" class="dropdown-item text-danger"><i class="bi bi-box-arrow-right me-2"></i>Logout</button>
                                </form>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </nav>

        <!-- Main Content -->
        <div class="container py-5">
            <!-- Header with Animation -->
            <div class="d-flex justify-content-between align-items-center mb-5 animate__animated animate__fadeInDown">
                <div>
                    <h1 class="fw-bold mb-2"><i class="bi bi-ticket-perforated me-3 gold-text"></i> <span class="masar-brand">My Tickets</span></h1>
                    <p class="text-muted">View and manage your upcoming journeys with MASAR</p>
                </div>
                <a href="passengerDashboard.jsp" class="btn btn-outline-primary">
                    <i class="bi bi-arrow-left me-1"></i> Back to Dashboard
                </a>
            </div>

            <!-- Tickets List -->
            <div class="tickets-section">
                <% if (tickets != null && !tickets.isEmpty()) { %>
                <div class="row row-cols-1 row-cols-md-2 g-4" id="ticketsContainer">
                    <% for (int i = 0; i < tickets.size(); i++) {
                            Ticket ticket = tickets.get(i);
                            Trip trip = trips.get(i);
                    %>
                    <div class="col">
                        <div class="ticket-card ticket-animate ticket-3d" style="animation-delay: <%= i * 0.1%>s">
                            <div class="card-body p-4">
                                <div class="d-flex justify-content-between">
                                    <div>
                                        <span class="badge <%= ticket.getTravelType().equals("city") ? "badge-city" : "badge-intercity"%> mb-2 rounded-pill">
                                            <%= ticket.getTravelType().equals("city") ? "City Bus" : "Inter-City"%>
                                        </span>
                                        <h5 class="card-title mb-1"><%= ticket.getOrigin()%> → <%= ticket.getDestination()%></h5>
                                        <p class="text-muted small mb-2">Ticket #<%= ticket.getId()%></p>
                                    </div>
                                    <div class="qr-code gold-hover">
                                        <i class="bi bi-qr-code" style="font-size: 2rem; color: var(--gold-dark);"></i>
                                    </div>
                                </div>

                                <hr class="gold-divider">

                                <div class="row mt-4">
                                    <div class="col-6">
                                        <p class="small text-muted mb-1">Departure</p>
                                        <p class="mb-0"><strong><%= timeFormat.format(trip.getTime())%></strong></p>
                                        <p class="small"><%= dateFormat.format(trip.getDate())%></p>
                                    </div>
                                    <div class="col-6">
                                        <p class="small text-muted mb-1">Purchase Date</p>
                                        <p class="mb-0"><strong><%= timeFormat.format(ticket.getPurchaseDate())%></strong></p>
                                        <p class="small"><%= dateFormat.format(ticket.getPurchaseDate())%></p>
                                    </div>
                                </div>

                                <div class="d-flex justify-content-between align-items-center mt-4 pt-3 border-top">
                                    <div>
                                        <span class="badge bg-success rounded-pill">Confirmed</span>
                                        <span class="badge bg-light text-dark ms-2 rounded-pill"><%= ticket.getSeats()%> seat(s)</span>
                                    </div>
                                    <h5 class="gold-price mb-0">$<%= String.format("%.2f", ticket.getFare())%></h5>
                                </div>
                            </div>
                            <div class="card-footer bg-white border-0 d-flex justify-content-between pt-0">
                                <button class="btn btn-sm btn-outline-primary rounded-pill ms-4 mb-2">
                                    <i class="bi bi-printer me-1"></i> Print
                                </button>
                                <button class="btn btn-sm btn-outline-danger rounded-pill me-2 mb-2">
                                    <i class="bi bi-x-circle me-1"></i> Cancel
                                </button>
                            </div>
                        </div>
                    </div>
                    <% } %>
                </div>
                <% } else { %>
                <div class="empty-state animate__animated animate__fadeIn">
                    <div class="card-body text-center py-5">
                        <div class="mb-4">
                            <i class="bi bi-ticket-perforated" style="font-size: 3rem; color: var(--accent);"></i>
                            <div class="position-relative d-inline-block">
                                <div class="scissors-animate" style="position: absolute; top: -20px; right: -30px;">
                                    <i class="bi bi-scissors text-danger" style="font-size: 1.5rem;"></i>
                                </div>
                            </div>
                        </div>
                        <h4 class="mt-3">No Tickets Found</h4>
                        <p class="text-muted">You haven't purchased any tickets yet with MASAR.</p>
                        <a href="passengerDashboard.jsp" class="btn btn-primary mt-3 rounded-pill gold-bg border-0">
                            <i class="bi bi-search me-1"></i> Find Trips
                        </a>
                    </div>
                </div>
                <% }%>
            </div>
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                    document.addEventListener('DOMContentLoaded', function() {
                    const scissors = document.querySelector('.scissors-animate');
                            if (scissors) {
                    scissors.style.animation = 'scissorsCut 1s ease-in-out infinite alternate';
                    }

                    const masarBrand = document.querySelector('.masar-brand');
                            if (masarBrand) {
                    masarBrand.addEventListener('mouseover', function() {
                    this.style.animation = 'masarGlow 1.5s infinite';
                    });
                            masarBrand.addEventListener('mouseout', function() {
                            this.style.animation = 'none';
                            });
                    }

                    document.querySelectorAll('.badge-intercity').forEach(badge = > {
                    badge.addEventListener('mouseover', function() {
                    this.style.boxShadow = '0 0 10px rgba(255, 215, 0, 0.7)';
                    });
                            badge.addEventListener('mouseout', function() {
                            this.style.boxShadow = 'none';
                            });
                    });
                    });
        </script>
    </body>
</html>