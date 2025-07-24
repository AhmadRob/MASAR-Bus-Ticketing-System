package controller;

import service.TicketPurchaseService;
import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

public class PurchaseTicketServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("userId") == null) {
                response.sendRedirect("login.jsp");
                return;
            }

            int userId = (int) session.getAttribute("userId");
            int tripId = Integer.parseInt(request.getParameter("tripId"));
            int reservedSeats = Integer.parseInt(request.getParameter("seats"));
            String ticketType = request.getParameter("ticketType");
            String passengerClass = request.getParameter("passengerClass");

            TicketPurchaseService purchaseService = new TicketPurchaseService();
            boolean success = purchaseService.purchaseTicket(userId, tripId, reservedSeats, ticketType, passengerClass);

            System.out.println("success: " + success);
            
            if (success) {
                request.getRequestDispatcher("TicketServlet").forward(request, response);
            } else {
                request.setAttribute("error", "Ticket purchase failed.");
                request.getRequestDispatcher("error.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Something went wrong during ticket purchase.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }
}
