package strategy.city;


import strategy.FareStrategy;

// City Pass (handles Daily/Weekly/Monthly)
public class CityPassFare implements FareStrategy {

    private final double multiplier;
    private final String passType;

    public CityPassFare(double multiplier, String passType) {
        this.multiplier = multiplier;
        this.passType = passType;
    }

    @Override
    public double calculateFare(double baseFare) {
        return baseFare * multiplier;
    }

    @Override
    public String getDescription() {
        return String.format("City %s Pass (%.1fx Base)", passType, multiplier);
    }
}
