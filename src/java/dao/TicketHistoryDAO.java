package dao;

import domain.TicketHistory;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import util.DBConnection;

public class TicketHistoryDAO {

    public List<TicketHistory> getTicketHistoryByUserId(int userId) {
        List<TicketHistory> historyList = new ArrayList<>();

        String sql = "SELECT th.id, th.ticket_id, th.user_id, th.purchase_time, "
                + "t.trip_id, t.ticket_type, t.price, t.purchase_date "
                + "FROM ticket_history th "
                + "JOIN tickets t ON th.ticket_id = t.id "
                + "WHERE th.user_id = ? "
                + "ORDER BY th.purchase_time DESC";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    TicketHistory history = new TicketHistory();
                    history.setId(rs.getInt("id"));
                    history.setTicketId(rs.getInt("ticket_id"));
                    history.setUserId(rs.getInt("user_id"));
                    history.setPurchaseTime(rs.getTimestamp("purchase_time"));

                    historyList.add(history);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return historyList;
    }

    public void addTicketHistory(int ticketId, int userId) {
        String sql = "INSERT INTO ticket_history (id, ticket_id, user_id, purchase_time) "
                + "VALUES (ticket_history_seq.NEXTVAL, ?, ?, SYSTIMESTAMP)";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, ticketId);
            pstmt.setInt(2, userId);
            pstmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

}
