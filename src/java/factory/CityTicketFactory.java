package factory;

import factory.ticket.city.CityOneTripTicket;
import factory.ticket.city.CityMonthlyPassTicket;
import factory.ticket.city.CityWeeklyPassTicket;
import factory.ticket.city.CityDailyPassTicket;
import domain.Ticket;

public class CityTicketFactory implements TicketFactory {

    @Override
    public Ticket createTicket(String ticketType, int userId, int tripId,
            String origin, String destination, java.sql.Date date) {

        switch (ticketType.toLowerCase()) {
            case "one_trip":
                return new CityOneTripTicket(userId, tripId, origin, destination, date);
            case "daily_pass":
                return new CityDailyPassTicket(userId, tripId, origin, destination, date);
            case "weekly_pass":
                return new CityWeeklyPassTicket(userId, tripId, origin, destination, date);
            case "monthly_pass":
                return new CityMonthlyPassTicket(userId, tripId, origin, destination, date);
            default:
                throw new IllegalArgumentException("Invalid city ticket type");
        }

    }
}
