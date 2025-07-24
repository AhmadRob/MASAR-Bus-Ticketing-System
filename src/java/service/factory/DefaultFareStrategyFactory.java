package service.factory;


import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import service.request.TicketRequest;
import strategy.FareStrategy;
import strategy.city.CityOneTripFare;
import strategy.city.CityPassFare;
import strategy.intercity.InterCityOneTripFare;
import strategy.intercity.InterCityPassFare;

public class DefaultFareStrategyFactory implements FareStrategyFactory {

    private static final Map<String, Double> PASS_MULTIPLIERS;

    static {
        Map<String, Double> tempMap = new HashMap<>();
        tempMap.put("daily_pass", 5.0);
        tempMap.put("weekly_pass", 15.0);
        tempMap.put("monthly_pass", 50.0);
        PASS_MULTIPLIERS = Collections.unmodifiableMap(tempMap);  // Make immutable
    }

    @Override
    public FareStrategy createStrategy(TicketRequest request) {
        if (request.getTicketType().equalsIgnoreCase("one_trip")) {
            return request.getTripType().equalsIgnoreCase("city")
                    ? new CityOneTripFare()
                    : new InterCityOneTripFare();
        }

        String passType = determinePassType(request);
        double multiplier = PASS_MULTIPLIERS.getOrDefault(passType, 1.0);

        return request.getTripType().equalsIgnoreCase("city")
                ? new CityPassFare(multiplier, passType)
                : new InterCityPassFare(multiplier, passType);
    }

    private String determinePassType(TicketRequest request) {

        if (request.getTicketType().equalsIgnoreCase("daily_pass")) {
            return "daily_pass";
        } else if (request.getTicketType().equalsIgnoreCase("weekly_pass")) {
            return "weekly_pass";
        } else if (request.getTicketType().equalsIgnoreCase("monthly_pass")) {
            return "monthly_pass";
        } else {
            return "one_trip";
        }
    }
}
