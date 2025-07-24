package controller;

import dao.TicketDAO;
import dao.TicketHistoryDAO;
import dao.TripDAO;
import domain.Ticket;
import domain.Trip;
import domain.User;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class PassengerTicketHistoryServlet extends HttpServlet {

    private final TicketDAO ticketDAO = new TicketDAO();
    private final TripDAO tripDAO = new TripDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        if (user == null || !"passenger".equals(user.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Step 1: Get all tickets for the user
        List<Ticket> tickets = ticketDAO.getTicketsByUserId(user.getId());

        // Step 2: For each ticket, get its related trip
        List<Trip> trips = new ArrayList<>();
        for (Ticket ticket : tickets) {
            Trip trip = tripDAO.getTripById(ticket.getTripId());
            if (trip != null) {
                trips.add(trip);
            }
        }

        // Step 3: Pass both lists to the JSP
        request.setAttribute("ticketList", tickets);
        request.setAttribute("tripList", trips);
        request.getRequestDispatcher("myTickets.jsp").forward(request, response);
    }
}
