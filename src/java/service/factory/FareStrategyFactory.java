package service.factory;


import service.request.TicketRequest;
import strategy.FareStrategy;

public interface FareStrategyFactory {

    FareStrategy createStrategy(TicketRequest ticket);
}
