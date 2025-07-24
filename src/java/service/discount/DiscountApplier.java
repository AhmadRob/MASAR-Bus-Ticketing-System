package service.discount;

import service.request.TicketRequest;
import strategy.FareStrategy;

public interface DiscountApplier {

    FareStrategy applyDiscounts(FareStrategy strategy, TicketRequest ticket);
};
