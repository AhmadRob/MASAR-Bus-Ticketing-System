package factory.ticket.city;

import domain.Ticket;

public class CityDailyPassTicket extends Ticket {

    public CityDailyPassTicket(int userId, int tripId, String origin,
            String destination, java.sql.Date date) {
        super(userId, tripId, origin, destination, date);
        this.travelType = "city";
        this.ticketType = "daily_pass";
    }
}
