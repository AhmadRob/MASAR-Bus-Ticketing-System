package factory;

import factory.ticket.intercity.InterCityDailyPassTicket;
import factory.ticket.intercity.InterCityMonthlyPassTicket;
import factory.ticket.intercity.InterCityOneTripTicket;
import factory.ticket.intercity.InterCityWeeklyPassTicket;
import domain.Ticket;

public class InterCityTicketFactory implements TicketFactory {

    @Override
    public Ticket createTicket(String ticketType, int userId, int tripId,
            String origin, String destination, java.sql.Date date) {
        switch (ticketType.toLowerCase()) {
            case "one_trip":
                return new InterCityOneTripTicket(userId, tripId, origin, destination, date);
            case "daily_pass":
                return new InterCityDailyPassTicket(userId, tripId, origin, destination, date);
            case "weekly_pass":
                return new InterCityWeeklyPassTicket(userId, tripId, origin, destination, date);
            case "monthly_pass":
                return new InterCityMonthlyPassTicket(userId, tripId, origin, destination, date);
            default:
                throw new IllegalArgumentException("Invalid inter-city ticket type");
        }
    }
}
