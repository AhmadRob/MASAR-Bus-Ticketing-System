package decorator.impl;

import decorator.FareDecorator;
import strategy.FareStrategy;
import util.FareConfig;

// Student Discount
public class StudentDiscountDecorator extends FareDecorator {

    public StudentDiscountDecorator(FareStrategy decoratedStrategy) {
        super(decoratedStrategy);
    }

    @Override
    public double calculateFare(double baseFare) {
        return decoratedStrategy.calculateFare(baseFare) - (baseFare * FareConfig.getInstance().getStudentDiscount());
    }

    @Override
    public String getDescription() {
        return decoratedStrategy.getDescription() + " + Student Discount";
    }
}
