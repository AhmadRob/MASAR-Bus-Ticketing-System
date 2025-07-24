package service.request;


public class TicketRequest {

    private String origin;
    private String destination;
    private int passengerCount;
    private String tripType;
    private String ticketType;
    private String userCategory;
    private boolean evening;

    public TicketRequest() {
    }

    public TicketRequest(String origin, String destination, int passengerCount, String tripType, String ticketType, String userCategory, boolean isEvening) {
        this.origin = origin;
        this.destination = destination;
        this.passengerCount = passengerCount;
        this.tripType = tripType;
        this.ticketType = ticketType;
        this.userCategory = userCategory;
        this.evening = isEvening;
    }

    // Getters and setters for all
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

    public int getPassengerCount() {
        return passengerCount;
    }

    public void setPassengerCount(int passengerCount) {
        this.passengerCount = passengerCount;
    }

    public String getTripType() {
        return tripType;
    }

    public void setTripType(String tripType) {
        this.tripType = tripType;
    }

    public String getTicketType() {
        return ticketType;
    }

    public void setTicketType(String ticketType) {
        this.ticketType = ticketType;
    }

    public String getUserCategory() {
        return userCategory;
    }

    public void setUserCategory(String userCategory) {
        this.userCategory = userCategory;
    }

    public boolean isEvening() {
        return evening;
    }

    public void setEvening(boolean evening) {
        this.evening = evening;
    }

}
