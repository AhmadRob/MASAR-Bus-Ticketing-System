package factory.ticket.city;

import domain.Ticket;

public class CityOneTripTicket extends Ticket {

    public CityOneTripTicket(int userId, int tripId, String origin,
            String destination, java.sql.Date date) {
        super(userId, tripId, origin, destination, date);
        this.travelType = "city";
        this.ticketType = "one_trip";
    }
}
