package service.calculator;

import service.discount.DiscountApplier;
import service.factory.FareStrategyFactory;
import service.request.TicketRequest;
import strategy.FareStrategy;
import util.FareConfig;

public class FareCalculator implements FareCalculationService {

    private final FareStrategyFactory strategyFactory;
    private final DiscountApplier discountApplier;
    private final FareConfig fareConfig;

    public FareCalculator(FareStrategyFactory strategyFactory,
            DiscountApplier discountApplier,
            FareConfig fareConfig) {
        this.strategyFactory = strategyFactory;
        this.discountApplier = discountApplier;
        this.fareConfig = fareConfig;
    }

    @Override
    public double calculateFare(TicketRequest request) {
        FareStrategy strategy = strategyFactory.createStrategy(request);
        strategy = discountApplier.applyDiscounts(strategy, request);

        // Fare for all tickets
        double totalBaseFares = getBaseFare(request) * request.getPassengerCount();

        return strategy.calculateFare(totalBaseFares);
    }

    private double getBaseFare(TicketRequest request) {
        return request.getTripType().equalsIgnoreCase("city")
                ? fareConfig.getCityBaseFare()
                : fareConfig.getInterCityBaseFare();
    }
}
