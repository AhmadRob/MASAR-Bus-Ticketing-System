package service.calculator;

public class FareResult {
    private final double fare;
    private final String calculationDetails;
    
    // Constructor, getters

    public FareResult(double fare, String calculationDetails) {
        this.fare = fare;
        this.calculationDetails = calculationDetails;
    }

    public double getFare() {
        return fare;
    }

    public String getCalculationDetails() {
        return calculationDetails;
    }
    
    
}