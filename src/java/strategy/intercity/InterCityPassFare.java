package strategy.intercity;


import strategy.FareStrategy;

// Inter-City Pass
public class InterCityPassFare implements FareStrategy {

    private final double multiplier;
    private final String passType;

    public InterCityPassFare(double multiplier, String passType) {
        this.multiplier = multiplier;
        this.passType = passType;
    }

    @Override
    public double calculateFare(double baseFare) {
        return baseFare * multiplier;
    }

    @Override
    public String getDescription() {
        return String.format("Inter-City %s Pass (%.1fx Base)", passType, multiplier);
    }
}
