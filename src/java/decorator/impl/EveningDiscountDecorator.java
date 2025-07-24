package decorator.impl;


import decorator.FareDecorator;
import strategy.intercity.InterCityOneTripFare;
import strategy.FareStrategy;
import strategy.city.CityOneTripFare;
import util.FareConfig;

// Evening Discount
public class EveningDiscountDecorator extends FareDecorator {

    public EveningDiscountDecorator(FareStrategy decoratedStrategy) {
        super(decoratedStrategy);
    }

    @Override
    public double calculateFare(double baseFare) {
        // Only applies to one-trip tickets
        if (decoratedStrategy instanceof CityOneTripFare
                || decoratedStrategy instanceof InterCityOneTripFare) {
            return decoratedStrategy.calculateFare(baseFare) - (baseFare*FareConfig.getInstance().getEveningDiscount());
        }
        return decoratedStrategy.calculateFare(baseFare);
    }

    @Override
    public String getDescription() {
        if (decoratedStrategy instanceof CityOneTripFare
                || decoratedStrategy instanceof InterCityOneTripFare) {
            return decoratedStrategy.getDescription() + " + Evening Discount";
        }
        return decoratedStrategy.getDescription();
    }
}
