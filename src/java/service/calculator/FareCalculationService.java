package service.calculator;

import service.request.TicketRequest;

public interface FareCalculationService {

    public double calculateFare(TicketRequest request);
}
