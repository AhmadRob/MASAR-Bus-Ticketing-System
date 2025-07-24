package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import util.DBConnection;

public class FareDAO {

    public double getFareRule(String category) {
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT discount_percentage FROM fare_rules WHERE category = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, category);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getDouble("discount_percentage");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    public boolean setFareRules(double cityFare, double interCityFare, double studentDiscount,
                                double seniorDiscount, double eveningDiscount, double weeklyDiscount) {
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false); // Start transaction

            PreparedStatement selectStmt = conn.prepareStatement(
                "SELECT id FROM fare_rules WHERE category = ?"
            );
            PreparedStatement updateStmt = conn.prepareStatement(
                "UPDATE fare_rules SET discount_percentage = ? WHERE category = ?"
            );
            PreparedStatement insertStmt = conn.prepareStatement(
                "INSERT INTO fare_rules (category, discount_percentage) VALUES (?, ?)"
            );

            Object[][] fareData = {
                {"cityFare", cityFare},
                {"interCityFare", interCityFare},
                {"studentDiscount", studentDiscount},
                {"seniorDiscount", seniorDiscount},
                {"eveningDiscount", eveningDiscount},
                {"weeklyDiscount", weeklyDiscount}
            };

            for (Object[] rule : fareData) {
                String category = (String) rule[0];
                double value = (double) rule[1];

                selectStmt.setString(1, category);
                ResultSet rs = selectStmt.executeQuery();

                if (rs.next()) {
                    // Update existing rule
                    updateStmt.setDouble(1, value);
                    updateStmt.setString(2, category);
                    updateStmt.executeUpdate();
                } else {
                    // Insert new rule
                    insertStmt.setString(1, category);
                    insertStmt.setDouble(2, value);
                    insertStmt.executeUpdate();
                }

                rs.close();
            }

            conn.commit(); // Commit transaction
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            try (Connection conn = DBConnection.getConnection()) {
                conn.rollback(); // Rollback transaction on error
            } catch (SQLException rollbackEx) {
                rollbackEx.printStackTrace();
            }
            return false;
        }
    }

    public boolean updateFareRule(String category, double newDiscount) {
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "UPDATE fare_rules SET discount_percentage = ? WHERE category = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setDouble(1, newDiscount);
            stmt.setString(2, category);

            int rowsUpdated = stmt.executeUpdate();
            return rowsUpdated > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
