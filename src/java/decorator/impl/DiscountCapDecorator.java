package decorator.impl;


import decorator.FareDecorator;
import strategy.FareStrategy;

// Discount Cap
public class DiscountCapDecorator extends FareDecorator {

    private static final double MAX_DISCOUNT = 0.5;

    public DiscountCapDecorator(FareStrategy decoratedStrategy) {
        super(decoratedStrategy);
    }

    @Override
    public double calculateFare(double baseFare) {
        double discounted = decoratedStrategy.calculateFare(baseFare);
        double minFare = baseFare * (1 - MAX_DISCOUNT);
        return Math.max(discounted, minFare);
    }

    @Override
    public String getDescription() {
        double sampleBase = 100;
        double discounted = decoratedStrategy.calculateFare(sampleBase);
        if (discounted < sampleBase * (1 - MAX_DISCOUNT)) {
            return decoratedStrategy.getDescription() + " (capped at 50% total discount)";
        }
        return decoratedStrategy.getDescription();
    }
}
