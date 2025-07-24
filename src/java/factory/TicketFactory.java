package factory;

import domain.Ticket;

public interface TicketFactory {

    public Ticket createTicket(String ticketType, int userId, int tripId, String origin,
            String destination, java.sql.Date date);
}
