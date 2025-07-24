package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import domain.User;
import util.DBConnection;

public class UserDAO {

    public boolean registerUser(User user) {
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "INSERT INTO users (name, email, password, role) VALUES (?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            System.out.println(user.getName());
            stmt.setString(1, user.getName());
            System.out.println(user.getEmail());
            stmt.setString(2, user.getEmail());
            System.out.println(user.getPassword());
            stmt.setString(3, user.getPassword());
            stmt.setString(4, "passenger");
            int rows = stmt.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            System.out.println("Registering user didnt work");
            e.printStackTrace();
            return false;
        }
    }

    public User login(String email, String password) {
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT * FROM users WHERE email=? AND password=?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, email);
            stmt.setString(2, password);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setName(rs.getString("name"));
                u.setEmail(rs.getString("email"));
                u.setRole(rs.getString("role"));
                return u;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public int getUserCount() {
    int count = 0;
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement("SELECT COUNT(*) AS total FROM users");
         ResultSet rs = stmt.executeQuery()) {
        if (rs.next()) {
            count = rs.getInt("total");
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return count;
}
    
    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement("SELECT * FROM users");
                ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setName(rs.getString("name"));
                user.setEmail(rs.getString("email"));
                user.setRole(rs.getString("role"));
                users.add(user);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return users;
    }


}

