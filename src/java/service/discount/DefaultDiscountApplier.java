package service.discount;

import decorator.impl.DiscountCapDecorator;
import service.request.TicketRequest;
import strategy.FareStrategy;
import decorator.impl.StudentDiscountDecorator;
import decorator.impl.SeniorDiscountDecorator;
import decorator.impl.EveningDiscountDecorator;

public class DefaultDiscountApplier implements DiscountApplier {

    @Override
    public FareStrategy applyDiscounts(FareStrategy strategy, TicketRequest request) {
        if (request.getUserCategory().equalsIgnoreCase("student")) {
            strategy = new StudentDiscountDecorator(strategy);
        } else if (request.getUserCategory().equalsIgnoreCase("senior")) {
            strategy = new SeniorDiscountDecorator(strategy);
        }

        if (request.isEvening()) {
            strategy = new EveningDiscountDecorator(strategy);
        }

        return new DiscountCapDecorator(strategy); // Always apply cap
    }
}
