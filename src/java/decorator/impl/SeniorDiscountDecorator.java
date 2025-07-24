package decorator.impl;


import decorator.FareDecorator;
import strategy.FareStrategy;
import util.FareConfig;

// Senior Discount
public class SeniorDiscountDecorator extends FareDecorator {

    public SeniorDiscountDecorator(FareStrategy decoratedStrategy) {
        super(decoratedStrategy);
    }

    @Override
    public double calculateFare(double baseFare) {
        return decoratedStrategy.calculateFare(baseFare) - (baseFare * FareConfig.getInstance().getSeniorDiscount());
    }

    @Override
    public String getDescription() {
        return decoratedStrategy.getDescription() + " + Senior Discount";
    }
}
