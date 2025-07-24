package domain;

public abstract class Ticket {

    private int id;
    private int userId;
    private int tripId;
    private String origin;
    private String destination;
    private java.sql.Date purchaseDate;
    protected String travelType;
    protected String ticketType;
    private String userCategory;
    private double fare;
    private int seats;

    public Ticket() {
    }

    public Ticket(int userId, int tripId, String origin,
            String destination, java.sql.Date purchaseDate) {

        this.userId = userId;
        this.tripId = tripId;
        this.origin = origin;
        this.destination = destination;
        this.purchaseDate = purchaseDate;
    }

    // Getters and Setters
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

    public String getTravelType() {
        return travelType;
    }

    public void setTravelType(String travelType) {
        this.travelType = travelType;
    }

    public String getTicketType() {
        return ticketType;
    }

    public void setTicketType(String ticketType) {
        this.ticketType = ticketType;
    }

    public double getFare() {
        return fare;
    }

    public void setFare(double fare) {
        this.fare = fare;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getTripId() {
        return tripId;
    }

    public void setTripId(int tripId) {
        this.tripId = tripId;
    }

    public java.sql.Date getPurchaseDate() {
        return purchaseDate;
    }

    public void setPurchaseDate(java.sql.Date purchaseDate) {
        this.purchaseDate = purchaseDate;
    }

    public int getSeats() {
        return seats;
    }

    public void setSeats(int seats) {
        this.seats = seats;
    }

    public String getUserCategory() {
        return userCategory;
    }

    public void setUserCategory(String userCategory) {
        this.userCategory = userCategory;
    }
}
