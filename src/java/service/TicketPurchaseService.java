package service;

import dao.TicketDAO;
import dao.TicketHistoryDAO;
import dao.TripDAO;
import domain.Ticket;
import domain.Trip;
import factory.TicketFactory;
import service.calculator.FareCalculationService;
import service.calculator.FareCalculator;
import service.discount.DefaultDiscountApplier;
import service.discount.DiscountApplier;
import service.factory.DefaultFareStrategyFactory;
import service.factory.FareStrategyFactory;
import service.factory.TicketFactoryProducer;
import service.request.TicketRequest;
import util.FareConfig;

import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.concurrent.ConcurrentHashMap;

public class TicketPurchaseService {

    private static final ConcurrentHashMap<Integer, Object> tripLocks = new ConcurrentHashMap<>();

    public boolean purchaseTicket(int userId, int tripId, int reservedSeats,
            String ticketType, String passengerClass) throws Exception {

        Object tripLock = tripLocks.computeIfAbsent(tripId, k -> new Object());

        synchronized (tripLock) {

            try {
                TripDAO tripDAO = new TripDAO();
                Trip trip = tripDAO.getTripById(tripId);

                if (trip == null) {
                    throw new Exception("Trip not found.");
                }

                // Early availability check
                if (trip.getAvailableSeats() < reservedSeats) {
                    throw new Exception("Not enough available seats.");
                }

                // Proceed with ticket creation
                TicketFactory ticketFactory = TicketFactoryProducer.getFactory(
                        trip.getTravelType().equalsIgnoreCase("city")
                );

                Ticket ticket = ticketFactory.createTicket(
                        ticketType,
                        userId,
                        trip.getId(),
                        trip.getOrigin(),
                        trip.getDestination(),
                        trip.getDate()
                );

                ticket.setSeats(reservedSeats);
                ticket.setUserCategory(passengerClass);

                // Determine if it's evening
                Timestamp timestamp = trip.getTime();
                LocalDateTime dateTime = timestamp.toLocalDateTime();
                LocalTime travelTime = dateTime.toLocalTime();
                boolean isEvening = travelTime.isAfter(LocalTime.of(19, 0));

                // Build ticket request for pricing
                TicketRequest ticketRequest = new TicketRequest();
                ticketRequest.setOrigin(trip.getOrigin());
                ticketRequest.setDestination(trip.getDestination());
                ticketRequest.setPassengerCount(reservedSeats);
                ticketRequest.setTripType(trip.getTravelType());
                ticketRequest.setTicketType(ticketType);
                ticketRequest.setUserCategory(passengerClass);
                ticketRequest.setEvening(isEvening);

                // Fare calculation
                FareStrategyFactory fareStrategyFactory = new DefaultFareStrategyFactory();
                DiscountApplier discountApplier = new DefaultDiscountApplier();
                FareCalculationService calculator = new FareCalculator(fareStrategyFactory, discountApplier, FareConfig.getInstance());
                PricingService pricingService = new PricingService(calculator);
                double finalFare = pricingService.calculateFare(ticketRequest);

                ticket.setFare(finalFare);

                // Save ticket and update trip
                TicketDAO ticketDAO = new TicketDAO();
                TicketHistoryDAO historyDAO = new TicketHistoryDAO();

                if (ticketDAO.bookTicket(ticket)) {
                    trip.setAvailableSeats(trip.getAvailableSeats() - reservedSeats);
                    tripDAO.updateTrip(trip);

                    int ticketId = ticketDAO.getTicketIdByUserAndTrip(userId, tripId);
                    historyDAO.addTicketHistory(ticketId, userId);
                    return true;
                }

                return false;
            } catch (Exception e) {
                e.printStackTrace();
                return false;
            }
        }
    }
}
