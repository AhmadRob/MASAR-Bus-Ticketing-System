package factory.ticket.intercity;

import domain.Ticket;

public class InterCityWeeklyPassTicket extends Ticket {

    public InterCityWeeklyPassTicket(int userId, int tripId, String origin,
            String destination, java.sql.Date date) {
        super(userId, tripId, origin, destination, date);
        this.travelType = "inter_city";
        this.ticketType = "weekly_pass";
    }
}
