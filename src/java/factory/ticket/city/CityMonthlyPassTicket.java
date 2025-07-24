package factory.ticket.city;

import domain.Ticket;

public class CityMonthlyPassTicket extends Ticket {

    public CityMonthlyPassTicket(int userId, int tripId, String origin,
            String destination, java.sql.Date date) {
        super(userId, tripId, origin, destination, date);
        this.travelType = "city";
        this.ticketType = "monthly_pass";
    }
}
