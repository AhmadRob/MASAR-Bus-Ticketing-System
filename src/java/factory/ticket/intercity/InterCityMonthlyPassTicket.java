package factory.ticket.intercity;

import domain.Ticket;

public class InterCityMonthlyPassTicket extends Ticket {

    public InterCityMonthlyPassTicket(int userId, int tripId, String origin,
            String destination, java.sql.Date date) {
        super(userId, tripId, origin, destination, date);
        this.travelType = "inter_city";
        this.ticketType = "monthly_pass";
    }
}
