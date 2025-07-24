package controller;

import dao.TicketDAO;
import dao.TripDAO;
import domain.Ticket;
import domain.Trip;
import domain.User;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class TicketServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        User user = (User) request.getSession().getAttribute("user");
        
        TicketDAO ticketDAO = new TicketDAO();
        TripDAO tripDAO = new TripDAO();
        
        List<Ticket> tickets = ticketDAO.getTicketsByUserId(user.getId());
        List<Trip> trips = new ArrayList<>();
        
        for (Ticket ticket : tickets) {
            trips.add(tripDAO.getTripById(ticket.getTripId()));
        }
        
        request.setAttribute("tickets", tickets);
        request.setAttribute("trips", trips);
        
        System.out.println("Tickets size: " + tickets.size());
        System.out.println("Trips size: " + trips.size());
        
        request.getRequestDispatcher("myTickets.jsp").forward(request, response);
        
    }
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }
    
}
