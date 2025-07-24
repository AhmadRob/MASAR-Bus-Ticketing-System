package strategy.intercity;


import strategy.FareStrategy;

// Inter-City One-Trip
public class InterCityOneTripFare implements FareStrategy {

    @Override
    public double calculateFare(double baseFare) {
        return baseFare;
    }

    @Override
    public String getDescription() {
        return "Inter-City One-Trip (1.5x Base)";
    }
}
