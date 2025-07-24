package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import domain.Trip;
import util.DBConnection;
import static util.DBConnection.getConnection;

public class TripDAO {

    public boolean addTrip(Trip trip) throws IllegalArgumentException {

        if (trip.getCapacity() <= 0) {
            throw new IllegalArgumentException("Capacity must be positive");
        }

        String sql = "INSERT INTO trips (origin, destination, trip_date, departure_time, capacity, available_seats, travel_type) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, trip.getOrigin());
            stmt.setString(2, trip.getDestination());
            stmt.setDate(3, trip.getDate());
            stmt.setTimestamp(4, trip.getTime());
            stmt.setInt(5, trip.getCapacity());
            stmt.setInt(6, trip.getCapacity());
            stmt.setString(7, trip.getTravelType());

            return stmt.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Trip> getAllTrips() {
        List<Trip> trips = new ArrayList<>();
        String sql = "SELECT * FROM trips";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Trip t = new Trip();
                t.setId(rs.getInt("id"));
                t.setOrigin(rs.getString("origin"));
                t.setDestination(rs.getString("destination"));
                t.setDate(rs.getDate("trip_date"));
                t.setTime(rs.getTimestamp("departure_time"));
                t.setCapacity(rs.getInt("capacity"));
                t.setAvailableSeats(rs.getInt("available_seats"));
                t.setTravelType(rs.getString("travel_type"));
                trips.add(t);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return trips;
    }

    public boolean deleteTrip(int tripId) {
        
//        TicketDAO ticketDAO = new TicketDAO();
//        ticketDAO.deleteTicketsByTripId(tripId);
        
        String sql = "DELETE FROM trips WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, tripId);
            return stmt.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public Trip getTripById(int id) {
        String sql = "SELECT * FROM trips WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Trip trip = new Trip();
                trip.setId(rs.getInt("id"));
                trip.setOrigin(rs.getString("origin"));
                trip.setDestination(rs.getString("destination"));
                trip.setTravelType(rs.getString("travel_type"));
                trip.setDate(rs.getDate("trip_date"));
                trip.setTime(rs.getTimestamp("departure_time"));
                trip.setCapacity(rs.getInt("capacity"));
                trip.setAvailableSeats(rs.getInt("available_seats"));
                return trip;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateTrip(Trip trip) {
        String sql = "UPDATE trips SET origin = ?, destination = ?, trip_date = ?, departure_time = ?, capacity = ?, available_seats = ?, travel_type = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, trip.getOrigin());
            stmt.setString(2, trip.getDestination());
            stmt.setDate(3, trip.getDate());
            stmt.setTimestamp(4, trip.getTime());
            stmt.setInt(5, trip.getCapacity());
            stmt.setInt(6, trip.getAvailableSeats());
            stmt.setString(7, trip.getTravelType());
            stmt.setInt(8, trip.getId());

            System.out.println("Trip ID: " + trip.getId());

            return stmt.executeUpdate() > 0;

        } catch (Exception e) {
            return false;
        }
    }
    
public List<Trip> searchTrips(String origin, String destination, String travelType, String travelDate) {
    List<Trip> trips = new ArrayList<>();
    StringBuilder sql = new StringBuilder("SELECT * FROM trips WHERE 1=1");

    List<Object> parameters = new ArrayList<>();

    if (origin != null && !origin.isEmpty()) {
        sql.append(" AND origin = ?");
        parameters.add(origin);
    }

    if (destination != null && !destination.isEmpty()) {
        sql.append(" AND destination = ?");
        parameters.add(destination);
    }

    if (travelType != null && !travelType.isEmpty()) {
        sql.append(" AND travel_type = ?");
        parameters.add(travelType);
    }

    if (travelDate != null && !travelDate.isEmpty()) {
        sql.append(" AND trip_date = ?");
        parameters.add(java.sql.Date.valueOf(travelDate)); // Convert String to SQL Date
    }

    try (Connection conn = getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

        for (int i = 0; i < parameters.size(); i++) {
            Object param = parameters.get(i);
            if (param instanceof java.sql.Date) {
                stmt.setDate(i + 1, (java.sql.Date) param);
            } else {
                stmt.setString(i + 1, param.toString());
            }
        }

        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            Trip tr = new Trip();
            tr.setId(rs.getInt("id"));
            tr.setOrigin(rs.getString("origin"));
            tr.setDestination(rs.getString("destination"));
            tr.setDate(rs.getDate("trip_date")); // Corrected
            tr.setTime(rs.getTimestamp("departure_time"));
            tr.setCapacity(rs.getInt("capacity"));
            tr.setAvailableSeats(rs.getInt("available_seats"));
            tr.setTravelType(rs.getString("travel_type"));

            trips.add(tr);
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return trips;
}


}
