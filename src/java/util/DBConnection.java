package util;

import java.sql.*;

public class DBConnection {

    private static final String DRIVER_URL = "oracle.jdbc.driver.OracleDriver";
    private static final String DB_URL = "jdbc:oracle:thin:@localhost:1521:XE";
    private static final String USER = "system";
    private static final String PASS = "156420156420";

    private static boolean isInitialized = false;

    public static Connection getConnection() {
        
        System.out.println("Getting Connection...");
        
        Connection conn = null;
        try {
            Class.forName(DRIVER_URL);
            conn = DriverManager.getConnection(DB_URL, USER, PASS);

            if (!isInitialized) {
                if (!doesUsersTableExist(conn)) {
                    System.out.println("USERS table not found. Initializing DB...");
                    DatabaseInitializer.initDatabase();
                } else {
                    System.out.println("USERS table exists. Skipping initialization.");
                }
                isInitialized = true;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return conn;
    }

    private static boolean doesUsersTableExist(Connection conn) {
        try {
            DatabaseMetaData dbMeta = conn.getMetaData();
            ResultSet tables = dbMeta.getTables(null, USER.toUpperCase(), "USERS", null);
            return tables.next(); // true if table exists
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
