package domain;

import java.sql.Timestamp;

public class Trip {

    private int id;
    private String origin;
    private String destination;
    private String travelType;
    private java.sql.Date date;
    private Timestamp time;
    private int capacity;
    private int availableSeats;

    public Trip() {
    }

    public Trip(int id, String origin, String destination, java.sql.Date date, Timestamp time,
            int capacity, String travelType) {
        this.id = id;
        this.origin = origin;
        this.destination = destination;
        this.date = date;
        this.time = time;
        this.capacity = capacity;
        this.travelType = travelType;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getOrigin() {
        return origin;
    }

    public void setOrigin(String origin) {
        this.origin = origin;
    }

    public String getDestination() {
        return destination;
    }

    public void setDestination(String destination) {
        this.destination = destination;
    }

    public java.sql.Date getDate() {
        return date;
    }

    public void setDate(java.sql.Date date) {
        this.date = date;
    }

    public Timestamp getTime() {
        return time;
    }

    public void setTime(Timestamp time) {
        this.time = time;
    }

    public int getCapacity() {
        return capacity;
    }

    public void setCapacity(int capacity) {
        this.capacity = capacity;
    }

    public void setTravelType(String tripType) {
        this.travelType = tripType;
    }

    public String getTravelType() {
        return travelType;
    }

    public int getAvailableSeats() {
        return availableSeats;
    }

    public void setAvailableSeats(int availableSeats) {
        this.availableSeats = availableSeats;
    }
}
