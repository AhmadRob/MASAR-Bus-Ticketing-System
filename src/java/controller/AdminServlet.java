package controller;

import dao.FareDAO;
import dao.TripDAO;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import domain.Trip;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import util.TripValidator;

public class AdminServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        TripDAO tripDAO = new TripDAO();
        List<Trip> trips = tripDAO.getAllTrips();
        int tripCount = trips.size();

        request.getSession().setAttribute("trips", trips);
        request.setAttribute("tripCount", tripCount);

        request.setAttribute("adminPath", "admin/");
        request.getRequestDispatcher("admin/adminDashboard.jsp").forward(request, response);

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("Entering doPost in AdminServlet");

        String action = request.getParameter("action");

        TripDAO tripDAO = new TripDAO();
        FareDAO fareDAO = new FareDAO();

        switch (action) {
            case "addTrip":
                try {
                    Trip t = new Trip();
                    t.setCapacity(Integer.parseInt(request.getParameter("capacity")));
                    t.setAvailableSeats(t.getCapacity());

                    // Date handling (unchanged)
                    String dateStr = request.getParameter("date");
                    java.sql.Date sqlDate = java.sql.Date.valueOf(dateStr); // simpler conversion
                    t.setDate(sqlDate);

                    // Origin and Destination
                    t.setDestination(request.getParameter("destination"));
                    t.setOrigin(request.getParameter("origin"));
                    t.setTravelType(request.getParameter("travel_type"));

                    // Time handling - fixed version
                    String timeStr = request.getParameter("time"); // e.g., "14:30" or "02:30 PM"

                    // Parse time properly
                    LocalTime localTime;
                    if (timeStr.contains(" ")) { // If it has AM/PM
                        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("hh:mm a");
                        localTime = LocalTime.parse(timeStr.toUpperCase(), formatter);
                    } else { // 24-hour format
                        localTime = LocalTime.parse(timeStr);
                    }

                    System.out.println(localTime);

                    // Combine with date to create Timestamp
                    LocalDateTime dateTime = sqlDate.toLocalDate().atTime(localTime);
                    Timestamp timestamp = Timestamp.valueOf(dateTime);
                    t.setTime(timestamp);

                    List<String> errors = TripValidator.validateTrip(t);
                    if (!errors.isEmpty()) {
                        request.setAttribute("errors", errors);
                        request.setAttribute("trip", t);
                        request.getRequestDispatcher("admin/manageTrips.jsp").forward(request, response);
                        return;
                    }

                    tripDAO.addTrip(t);
                    response.sendRedirect("admin/manageTrips.jsp");
                } catch (Exception e) {
                    e.printStackTrace();
                    request.setAttribute("error", "Failed to add trip: " + e.getMessage());
                    request.getRequestDispatcher("admin/manageTrips.jsp").forward(request, response);
                }
                break;

            case "updateTrip":
                try {
                    int tripId = Integer.parseInt(request.getParameter("tripId"));
                    String origin = request.getParameter("origin");
                    String destination = request.getParameter("destination");
                    String dateStr = request.getParameter("date");
                    String timeStr = request.getParameter("time");
                    int capacity = Integer.parseInt(request.getParameter("capacity"));
                    String travelType = request.getParameter("travel_type");

                    java.sql.Date date = java.sql.Date.valueOf(dateStr);

                    // Parse time the same way as in addTrip
                    LocalTime localTime;
                    if (timeStr.contains(" ")) {
                        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("hh:mm a");
                        localTime = LocalTime.parse(timeStr.toUpperCase(), formatter);
                    } else {
                        localTime = LocalTime.parse(timeStr);
                    }

                    LocalDateTime dateTime = date.toLocalDate().atTime(localTime);
                    Timestamp timestamp = Timestamp.valueOf(dateTime);

                    Trip updatedTrip = new Trip(tripId, origin, destination, date, timestamp, capacity, travelType);
                    updatedTrip.setAvailableSeats(capacity);

                    List<String> errors = TripValidator.validateTrip(updatedTrip);
                    if (!errors.isEmpty()) {
                        request.setAttribute("errors", errors);
                        request.setAttribute("trip", updatedTrip);
                        request.getRequestDispatcher("admin/manageTrips.jsp").forward(request, response);
                        return;
                    }

                    if (tripDAO.updateTrip(updatedTrip)) {
                        request.setAttribute("success", "Trip updated successfully");
                    } else {
                        request.setAttribute("error", "Failed to update trip");
                    }
                    response.sendRedirect("admin/manageTrips.jsp");
                } catch (Exception e) {
                    e.printStackTrace();
                    request.setAttribute("error", "Failed to update trip: " + e.getMessage());
                    request.getRequestDispatcher("admin/manageTrips.jsp").forward(request, response);
                }
                break;
            case "deleteTrip":

                int tripId = Integer.parseInt(request.getParameter("tripId"));
                TripDAO dao = new TripDAO();
                boolean deleted = dao.deleteTrip(tripId);
                if (deleted) {
                    System.out.println("Trip deleted successfully.");
                } else {
                    System.out.println("Failed to delete trip.");
                }
                response.sendRedirect("admin/manageTrips.jsp");

                break;
            case "updateFare":
                try {

                    System.out.println("updateFare in AdminServlet");

                    String configType = request.getParameter("configType");

                    switch (configType) {
                        case "baseFare":
                            // Handle base fare updates
                            double cityFare = Double.parseDouble(request.getParameter("cityFare"));
                            double interCityFare = Double.parseDouble(request.getParameter("interCityFare"));

                            // Validate fares
                            if (cityFare <= 0 || interCityFare <= 0) {
                                request.setAttribute("error", "Fares must be positive values");
                                break;
                            }

                            boolean baseFareUpdated = fareDAO.updateFareRule("cityFare", cityFare) && fareDAO.updateFareRule("interCityFare", interCityFare);

                            if (baseFareUpdated) {
                                request.setAttribute("message", "Base fares updated successfully");
                            } else {
                                request.setAttribute("error", "Failed to update base fares");
                            }
                            break;

                        case "discounts":

                            try {

                                // Handle discount updates
                                double studentDiscount = Double.parseDouble(request.getParameter("studentDiscount"));
                                double seniorDiscount = Double.parseDouble(request.getParameter("seniorDiscount"));
                                double eveningDiscount = Double.parseDouble(request.getParameter("eveningDiscount"));
                            // boolean discountCap = request.getParameter("discountCap") != null;

                                // Validate discounts
                                if (studentDiscount < 0 || studentDiscount > 100
                                        || seniorDiscount < 0 || seniorDiscount > 100
                                        || eveningDiscount < 0 || eveningDiscount > 100) {
                                    request.setAttribute("error", "Discounts must be between 0 and 100 percent");
                                    break;
                                }

                                // Update in database
                                boolean discountsUpdated = fareDAO.updateFareRule("studentDiscount", studentDiscount / 100)
                                        && fareDAO.updateFareRule("seniorDiscount", seniorDiscount / 100) && fareDAO.updateFareRule("eveningDiscount", eveningDiscount / 100);

                                if (discountsUpdated) {
                                    request.setAttribute("message", "Discount settings updated successfully");
                                } else {
                                    request.setAttribute("error", "Failed to update discount settings");
                                }

                                break;
                            } catch (Exception e) {
                                e.printStackTrace();
                            }

                        default:
                            request.setAttribute("error", "Invalid configuration type");
                    }

                    request.setAttribute("adminPath", "admin/");
                    request.getRequestDispatcher("admin/configureFare.jsp").forward(request, response);

                } catch (NumberFormatException e) {
                    request.setAttribute("error", "Invalid number format: " + e.getMessage());
                    request.getRequestDispatcher("admin/configureFare.jsp").forward(request, response);
                } catch (Exception e) {
                    e.printStackTrace();
                    request.setAttribute("error", "Error updating fare configuration: " + e.getMessage());
                    request.getRequestDispatcher("admin/configureFare.jsp").forward(request, response);
                }
                break;
            default:
                response.sendRedirect("admin/manageTrips.jsp");
        }
    }

}
