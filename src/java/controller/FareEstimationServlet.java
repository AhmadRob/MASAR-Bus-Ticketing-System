package controller;

import java.io.IOException;
import java.time.LocalTime;
import java.time.format.DateTimeParseException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import service.PricingService;
import service.calculator.FareCalculationService;
import service.calculator.FareCalculator;
import service.discount.DiscountApplier;
import service.factory.DefaultFareStrategyFactory;
import service.factory.FareStrategyFactory;
import service.request.TicketRequest;
import service.discount.DefaultDiscountApplier;
import util.FareConfig;


public class FareEstimationServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Read request parameters from the form
        String origin = request.getParameter("origin");
        String destination = request.getParameter("destination");
        int passengers = Integer.parseInt(request.getParameter("passengers"));
        String tripType = request.getParameter("tripType");           // "city" or "inter-city"
        String ticketType = request.getParameter("ticketType");       // "oneTrip", "weekly", etc.
        String userCategory = request.getParameter("userCategory");   // "student", "senior", etc.
        String travelTimeRaw = request.getParameter("travelTime");    // expects HH:mm

        // 2. Determine if it's evening
        boolean isEvening = false;
        try {
            LocalTime travelTime = LocalTime.parse(travelTimeRaw); // Format must be HH:mm
            System.out.println(travelTime.toString());
            isEvening = travelTime.isAfter(LocalTime.of(19, 0)); 
            System.out.println(isEvening);// After 7:00 PM
        } catch (DateTimeParseException e) {
            e.printStackTrace(); // Optional: log the error
        }

        // 3. Construct TicketRequest
        TicketRequest ticketRequest = new TicketRequest();
        ticketRequest.setOrigin(origin);
        ticketRequest.setDestination(destination);
        ticketRequest.setPassengerCount(passengers);
        ticketRequest.setTripType(tripType);
        ticketRequest.setTicketType(ticketType);
        ticketRequest.setUserCategory(userCategory);
        ticketRequest.setEvening(isEvening);

        // 4. Get base strategy factory
        FareStrategyFactory fareStrategyFactory = new DefaultFareStrategyFactory();

        // 5. Get discount applier
        DiscountApplier discountApplier = new DefaultDiscountApplier();

        // 6. Create a calculator
        FareCalculationService calculator = new FareCalculator(fareStrategyFactory,
                discountApplier, FareConfig.getInstance());
        
        // 7. Final fare
        PricingService pricingService = new PricingService(calculator);
        double finalFare = pricingService.calculateFare(ticketRequest);

        // 7. Set attributes for JSP
        request.setAttribute("estimatedFare", finalFare);
        
        request.setAttribute("activeTab", "estimate");
        
        // 8. Forward to the JSP
        request.getRequestDispatcher("passengerDashboard.jsp").forward(request, response);
    }

}
