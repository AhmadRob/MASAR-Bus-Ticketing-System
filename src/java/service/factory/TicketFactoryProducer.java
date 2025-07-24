package service.factory;

import factory.CityTicketFactory;
import factory.InterCityTicketFactory;
import factory.TicketFactory;

public class TicketFactoryProducer {

    public static TicketFactory getFactory(boolean isCity) {
        return isCity ? new CityTicketFactory() : new InterCityTicketFactory();
    }
}
