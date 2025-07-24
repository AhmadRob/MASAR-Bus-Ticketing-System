package factory.ticket.city;

import domain.Ticket;

public class CityWeeklyPassTicket extends Ticket {

    public CityWeeklyPassTicket(int userId, int tripId, String origin,
            String destination, java.sql.Date date) {
        super(userId, tripId, origin, destination, date);
        this.travelType = "city";
        this.ticketType = "weekly_pass";
    }
}
