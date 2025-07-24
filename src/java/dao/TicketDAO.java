package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import domain.Ticket;
import domain.Trip;
import factory.TicketFactory;
import java.sql.SQLException;
import service.factory.TicketFactoryProducer;
import util.DBConnection;

public class TicketDAO {

    public boolean bookTicket(Ticket ticket) {
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "INSERT INTO tickets (user_id, trip_id, ticket_type, user_category, price, seats, purchase_date) VALUES (?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, ticket.getUserId());
            stmt.setInt(2, ticket.getTripId());
            stmt.setString(3, ticket.getTicketType());
            stmt.setString(4, ticket.getUserCategory());
            stmt.setDouble(5, ticket.getFare());
            stmt.setInt(6, ticket.getSeats());
            stmt.setTimestamp(7, new Timestamp(System.currentTimeMillis()));
            System.out.println(stmt.executeUpdate() > 0);
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            return false;
        }
    }

    public List<Ticket> getTicketsByUserId(int userId) {
        List<Ticket> tickets = new ArrayList<>();

        String sql = "SELECT t.id, t.trip_id, t.ticket_type, t.user_category, t.price, t.seats, t.purchase_date "
                + "FROM tickets t "
                + "JOIN ticket_history th ON t.id = th.ticket_id "
                + "WHERE th.user_id = ? "
                + "ORDER BY th.purchase_time DESC";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);

            TripDAO tripDao = new TripDAO();

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {

                    Trip trip = tripDao.getTripById(rs.getInt("trip_id"));
                    TicketFactory ticketFactory = TicketFactoryProducer.getFactory(trip
                            .getTravelType()
                            .equalsIgnoreCase("city"));

                    Ticket ticket = ticketFactory.createTicket(rs.getString("ticket_type"), userId, trip.getId(), trip.getOrigin(), trip.getDestination(), trip.getDate());

                    ticket.setId(rs.getInt("id"));
                    ticket.setFare(rs.getDouble("price"));
                    ticket.setSeats(rs.getInt("seats"));
                    ticket.setPurchaseDate(rs.getDate("purchase_date"));
                    ticket.setUserCategory(rs.getString("user_category"));

                    tickets.add(ticket);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return tickets;
    }

    public Ticket getTicketById(int ticketId) {
        Ticket ticket = null;

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT * FROM tickets WHERE id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, ticketId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                int id = rs.getInt("id");
                int userId = rs.getInt("user_id");
                int tripId = rs.getInt("trip_id");
                String ticketType = rs.getString("ticket_type");
                double price = rs.getDouble("price");
                int seats = rs.getInt("seats");
                String userCategory = rs.getString("user_category");
                java.sql.Date purchaseDate = rs.getDate("purchase_date");

                TripDAO tripDao = new TripDAO();
                Trip trip = tripDao.getTripById(tripId);
                String travelType = trip.getTravelType();
                boolean isCity = travelType.equalsIgnoreCase("city");

                String origin = trip.getOrigin();
                String destination = trip.getDestination();

                TicketFactory ticketFactory = TicketFactoryProducer.getFactory(isCity);

                ticket = ticketFactory.createTicket(ticketType, userId, tripId, origin, destination, purchaseDate);

                ticket.setId(id);
                ticket.setTravelType(travelType);
                ticket.setUserCategory(userCategory);
                ticket.setFare(price);
                ticket.setSeats(seats);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return ticket;
    }

    public int getTicketIdByUserAndTrip(int userId, int tripId) {
        int ticketId = -1;

        String sql = "SELECT id FROM tickets WHERE user_id = ? AND trip_id = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            stmt.setInt(2, tripId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    ticketId = rs.getInt("id");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return ticketId;
    }

    public List<Ticket> getAllTickets() {
        List<Ticket> tickets = new ArrayList<>();

        String sql = "SELECT * FROM tickets";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {

            TripDAO tripDao = new TripDAO();

            while (rs.next()) {
                int id = rs.getInt("id");
                int userId = rs.getInt("user_id");
                int tripId = rs.getInt("trip_id");
                String ticketType = rs.getString("ticket_type");
                String userCategory = rs.getString("user_category");
                double price = rs.getDouble("price");
                int seats = rs.getInt("seats");
                java.sql.Date purchaseDate = rs.getDate("purchase_date");

                Trip trip = tripDao.getTripById(tripId);
                String travelType = trip.getTravelType();
                boolean isCity = travelType.equalsIgnoreCase("city");

                TicketFactory ticketFactory = TicketFactoryProducer.getFactory(isCity);
                Ticket ticket = ticketFactory.createTicket(ticketType, userId, tripId, trip.getOrigin(), trip.getDestination(), purchaseDate);

                ticket.setId(id);
                ticket.setTravelType(travelType);
                ticket.setUserCategory(userCategory);
                ticket.setFare(price);
                ticket.setSeats(seats);

                tickets.add(ticket);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return tickets;
    }

    public int getTicketsCount() {
        int count = 0;
        String sql = "SELECT COUNT(*) AS total FROM tickets";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                count = rs.getInt("total");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return count;
    }

    public List<Ticket> getAllTicketsByType(String ticketType) {
        List<Ticket> tickets = new ArrayList<>();

        String sql = "SELECT * FROM tickets WHERE ticket_type = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, ticketType);
            ResultSet rs = stmt.executeQuery();

            TripDAO tripDao = new TripDAO();

            while (rs.next()) {
                int id = rs.getInt("id");
                int userId = rs.getInt("user_id");
                int tripId = rs.getInt("trip_id");
                double price = rs.getDouble("price");
                String userCategory = rs.getString("user_category");
                int seats = rs.getInt("seats");
                java.sql.Date purchaseDate = rs.getDate("purchase_date");

                Trip trip = tripDao.getTripById(tripId);
                String travelType = trip.getTravelType();
                boolean isCity = travelType.equalsIgnoreCase("city");

                TicketFactory ticketFactory = TicketFactoryProducer.getFactory(isCity);
                Ticket ticket = ticketFactory.createTicket(ticketType, userId, tripId, trip.getOrigin(), trip.getDestination(), purchaseDate);

                ticket.setId(id);
                ticket.setTravelType(travelType);
                ticket.setUserCategory(userCategory);
                ticket.setFare(price);
                ticket.setSeats(seats);

                tickets.add(ticket);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return tickets;
    }

    public List<Ticket> getAllTicketsByUserCategory(String userCategory) {
        List<Ticket> tickets = new ArrayList<>();

        String sql = "SELECT * FROM tickets WHERE user_category = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, userCategory);
            ResultSet rs = stmt.executeQuery();

            TripDAO tripDao = new TripDAO();

            while (rs.next()) {
                int id = rs.getInt("id");
                int userId = rs.getInt("user_id");
                int tripId = rs.getInt("trip_id");
                String ticketType = rs.getString("ticket_type");
                double price = rs.getDouble("price");
                int seats = rs.getInt("seats");
                java.sql.Date purchaseDate = rs.getDate("purchase_date");

                Trip trip = tripDao.getTripById(tripId);
                String travelType = trip.getTravelType();
                boolean isCity = travelType.equalsIgnoreCase("city");

                TicketFactory ticketFactory = TicketFactoryProducer.getFactory(isCity);
                Ticket ticket = ticketFactory.createTicket(ticketType, userId, tripId, trip.getOrigin(), trip.getDestination(), purchaseDate);

                ticket.setId(id);
                ticket.setTravelType(travelType);
                ticket.setUserCategory(userCategory);
                ticket.setFare(price);
                ticket.setSeats(seats);

                tickets.add(ticket);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return tickets;
    }

    public List<Ticket> getTicketsByDateRange(Timestamp startDate, Timestamp endDate) {
        List<Ticket> tickets = new ArrayList<>();

        String sql = "SELECT * FROM tickets WHERE purchase_date BETWEEN ? AND ? ORDER BY purchase_date";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            System.out.println("Querying tickets between: " + startDate + " and " + endDate);

            stmt.setTimestamp(1, startDate);
            stmt.setTimestamp(2, endDate);

            ResultSet rs = stmt.executeQuery();
            TripDAO tripDao = new TripDAO();

            while (rs.next()) {
                int id = rs.getInt("id");
                int userId = rs.getInt("user_id");
                int tripId = rs.getInt("trip_id");
                String ticketType = rs.getString("ticket_type");
                String userCategory = rs.getString("user_category");
                double price = rs.getDouble("price");
                int seats = rs.getInt("seats");

                Timestamp purchaseTimestamp = rs.getTimestamp("purchase_date");

                Trip trip = tripDao.getTripById(tripId);
                String travelType = trip.getTravelType();
                boolean isCity = travelType.equalsIgnoreCase("city");

                TicketFactory ticketFactory = TicketFactoryProducer.getFactory(isCity);
                Ticket ticket = ticketFactory.createTicket(
                        ticketType, userId, tripId,
                        trip.getOrigin(), trip.getDestination(),
                        new java.sql.Date(purchaseTimestamp.getTime())
                );

                ticket.setId(id);
                ticket.setTravelType(travelType);
                ticket.setUserCategory(userCategory);
                ticket.setFare(price);
                ticket.setSeats(seats);

            // Optional: Keep timestamp precision
                // ticket.setPurchaseTimestamp(purchaseTimestamp);
                tickets.add(ticket);
            }

        } catch (SQLException e) {
            System.err.println("Error fetching tickets by date range: " + e.getMessage());
            e.printStackTrace();
        }

        System.out.println("Found " + tickets.size() + " tickets in date range");
        return tickets;
    }
    
    public boolean deleteTicketsByTripId(int tripId) {
    String sql = "DELETE FROM tickets WHERE trip_id = ?";

    try (Connection conn = DBConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {

        stmt.setInt(1, tripId);
        int rowsAffected = stmt.executeUpdate();

        return rowsAffected > 0; // true if at least one ticket was deleted

    } catch (SQLException e) {
        e.printStackTrace();
    }

    return false; // false if an error occurs
}


}
