package strategy;

// Base interface
public interface FareStrategy {

    double calculateFare(double baseFare);

    String getDescription();
}
