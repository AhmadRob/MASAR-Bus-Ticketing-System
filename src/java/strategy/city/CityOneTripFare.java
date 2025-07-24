package strategy.city;


import strategy.FareStrategy;

// City One-Trip
public class CityOneTripFare implements FareStrategy {

    @Override
    public double calculateFare(double baseFare) {
        return baseFare;
    }

    @Override
    public String getDescription() {
        return "City One-Trip (Base Fare)";
    }
}
