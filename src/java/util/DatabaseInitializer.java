package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

public class DatabaseInitializer {

    private static final String DRIVER_URL = "oracle.jdbc.driver.OracleDriver";
    private static final String DB_URL = "jdbc:oracle:thin:@localhost:1521:XE";
    private static final String USER = "system";
    private static final String PASS = "156420156420";

    public static void initDatabase() {
        try {
            Class.forName(DRIVER_URL);
            try (Connection conn = DriverManager.getConnection(DB_URL, USER, PASS); Statement stmt = conn.createStatement()) {

                // USERS table
                stmt.executeUpdate(
                        "BEGIN EXECUTE IMMEDIATE 'CREATE TABLE users ("
                        + "id NUMBER PRIMARY KEY, "
                        + "name VARCHAR2(100), "
                        + "email VARCHAR2(100) UNIQUE, "
                        + "password VARCHAR2(100), "
                        + "role VARCHAR2(20) DEFAULT ''passenger'' CHECK (role IN (''passenger'', ''admin''))"
                        + ")'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;"
                );
                stmt.executeUpdate(
                        "BEGIN EXECUTE IMMEDIATE 'CREATE SEQUENCE users_seq START WITH 1 INCREMENT BY 1'; "
                        + "EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;"
                );
                stmt.executeUpdate(
                        "BEGIN EXECUTE IMMEDIATE 'CREATE OR REPLACE TRIGGER users_trigger BEFORE INSERT ON users "
                        + "FOR EACH ROW BEGIN SELECT users_seq.NEXTVAL INTO :new.id FROM dual; END;'; END;"
                );

                // TRIPS table
                stmt.executeUpdate(
                        "BEGIN EXECUTE IMMEDIATE 'CREATE TABLE trips ("
                        + "id NUMBER PRIMARY KEY, "
                        + "origin VARCHAR2(100), "
                        + "destination VARCHAR2(100), "
                        + "departure_time TIMESTAMP, "
                        + "trip_date DATE, "
                        + "capacity NUMBER, "
                        + "available_seats NUMBER, "
                        + "travel_type VARCHAR2(20) CHECK (travel_type IN (''city'', ''inter_city'')) "
                        + ")'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;"
                );

                stmt.executeUpdate(
                        "BEGIN EXECUTE IMMEDIATE 'CREATE SEQUENCE trips_seq START WITH 1 INCREMENT BY 1'; "
                        + "EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;"
                );
                stmt.executeUpdate(
                        "BEGIN EXECUTE IMMEDIATE 'CREATE OR REPLACE TRIGGER trips_trigger BEFORE INSERT ON trips "
                        + "FOR EACH ROW BEGIN SELECT trips_seq.NEXTVAL INTO :new.id FROM dual; END;'; END;"
                );

                // TICKETS table
                stmt.executeUpdate(
                        "BEGIN EXECUTE IMMEDIATE 'CREATE TABLE tickets ("
                        + "id NUMBER PRIMARY KEY, "
                        + "user_id NUMBER, "
                        + "trip_id NUMBER, "
                        + "ticket_type VARCHAR2(20) CHECK (ticket_type IN (''one_trip'', ''daily_pass'', ''weekly_pass'', ''monthly_pass'')), "
                        + "user_category VARCHAR2(20) CHECK (user_category IN (''regular'', ''student'', ''senior'')), "
                        + "price NUMBER(10,2), "
                        + "seats NUMBER, "
                        + "purchase_date TIMESTAMP, "
                        + "FOREIGN KEY (user_id) REFERENCES users(id), "
                        + "FOREIGN KEY (trip_id) REFERENCES trips(id) ON DELETE CASCADE"
                        + ")'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;"
                );

                stmt.executeUpdate(
                        "BEGIN EXECUTE IMMEDIATE 'CREATE SEQUENCE tickets_seq START WITH 1 INCREMENT BY 1'; "
                        + "EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;"
                );
                stmt.executeUpdate(
                        "BEGIN EXECUTE IMMEDIATE 'CREATE OR REPLACE TRIGGER tickets_trigger BEFORE INSERT ON tickets "
                        + "FOR EACH ROW BEGIN SELECT tickets_seq.NEXTVAL INTO :new.id FROM dual; END;'; END;"
                );

                // FARE_RULES table
                stmt.executeUpdate(
                        "BEGIN EXECUTE IMMEDIATE 'CREATE TABLE fare_rules ("
                        + "id NUMBER PRIMARY KEY, "
                        + "category VARCHAR2(50) UNIQUE, "
                        + "discount_percentage NUMBER(5,2)"
                        + ")'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;"
                );
                stmt.executeUpdate(
                        "BEGIN EXECUTE IMMEDIATE 'CREATE SEQUENCE fare_rules_seq START WITH 1 INCREMENT BY 1'; "
                        + "EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;"
                );
                stmt.executeUpdate(
                        "BEGIN EXECUTE IMMEDIATE 'CREATE OR REPLACE TRIGGER fare_rules_trigger BEFORE INSERT ON fare_rules "
                        + "FOR EACH ROW BEGIN SELECT fare_rules_seq.NEXTVAL INTO :new.id FROM dual; END;'; END;"
                );

                // TICKET_HISTORY table
                stmt.executeUpdate(
                        "BEGIN EXECUTE IMMEDIATE 'CREATE TABLE ticket_history ("
                        + "id NUMBER PRIMARY KEY, "
                        + "ticket_id NUMBER, "
                        + "user_id NUMBER, "
                        + "purchase_time TIMESTAMP, "
                        + "FOREIGN KEY (ticket_id) REFERENCES tickets(id) ON DELETE CASCADE, "
                        + "FOREIGN KEY (user_id) REFERENCES users(id)"
                        + ")'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;"
                );
                stmt.executeUpdate(
                        "BEGIN EXECUTE IMMEDIATE 'CREATE SEQUENCE ticket_history_seq START WITH 1 INCREMENT BY 1'; "
                        + "EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;"
                );
                stmt.executeUpdate(
                        "BEGIN EXECUTE IMMEDIATE 'CREATE OR REPLACE TRIGGER ticket_history_trigger BEFORE INSERT ON ticket_history "
                        + "FOR EACH ROW BEGIN SELECT ticket_history_seq.NEXTVAL INTO :new.id FROM dual; END;'; END;"
                );

                stmt.executeUpdate(
                        "BEGIN "
                        + "   DECLARE "
                        + "       v_count NUMBER := 0; "
                        + "   BEGIN "
                        + "       SELECT COUNT(*) INTO v_count FROM users WHERE email = 'admin@bus.com'; "
                        + "       IF v_count = 0 THEN "
                        + "           INSERT INTO users (id, name, email, password, role) "
                        + "           VALUES (users_seq.NEXTVAL, 'Administrator', 'admin@bus.com', '1234', 'admin'); "
                        + "       END IF; "
                        + "   END; "
                        + "END;"
                );

                System.out.println("✅ Oracle XE tables, sequences, and triggers created successfully!");

            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
    }
}
