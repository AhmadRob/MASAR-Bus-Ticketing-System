package factory.ticket.intercity;

import domain.Ticket;

public class InterCityOneTripTicket extends Ticket {

    public InterCityOneTripTicket(int userId, int tripId, String origin,
            String destination, java.sql.Date date) {
        super(userId, tripId, origin, destination, date);
        this.travelType = "inter_city";
        this.ticketType = "one_trip";
    }
}
