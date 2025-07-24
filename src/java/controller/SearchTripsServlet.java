package controller;

import dao.TripDAO;
import domain.Trip;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class SearchTripsServlet extends HttpServlet {

    private TripDAO tripDAO;

    @Override
    public void init() {
        tripDAO = new TripDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String origin = request.getParameter("origin");
        String destination = request.getParameter("destination");
        String travelType = request.getParameter("travelType");
        String travelDate = request.getParameter("travelDate");

        List<Trip> trips = tripDAO.searchTrips(origin, destination, travelType, travelDate);

        request.setAttribute("tripList", trips);
        request.getRequestDispatcher("passengerDashboard.jsp").forward(request, response);
    }
}
