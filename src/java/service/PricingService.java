package service;

import service.request.TicketRequest;
import service.calculator.FareCalculationService;

public class PricingService {

    private final FareCalculationService fareCalculator;

    public PricingService(FareCalculationService calculator) {
        this.fareCalculator = calculator;
    }

    public double calculateFare(TicketRequest request) {

        return fareCalculator.calculateFare(request);
    }
}
