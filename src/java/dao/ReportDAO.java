package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import util.DBConnection;

public class ReportDAO {
    public int getTotalTicketsSold() {
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT COUNT(*) AS total FROM tickets";
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public double getTotalRevenue() {
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT SUM(f.fare) AS total FROM tickets t JOIN trips tr ON t.trip_id = tr.id JOIN fares f ON tr.origin = f.origin AND tr.destination = f.destination";
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getDouble("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0.0;
    }
}