package util;

import dao.FareDAO;
import javax.servlet.ServletContext;

public class FareConfig {

    private static FareConfig instance;
    private static FareDAO fareDao;

    private FareConfig() {
        // Private constructor to prevent instantiation
        FareConfig.fareDao = new FareDAO(); // Initialize DAO
    }

    public static FareConfig getInstance() {
        if (instance == null) {
            throw new IllegalStateException("FareConfig not initialized. Call init(context) first.");
        }
        return instance;
    }

    public static synchronized void init(ServletContext context) {
        if (instance == null) {
            instance = new FareConfig();

            // Initialize with context params
            double cityFare = Double.parseDouble(context.getInitParameter("cityBaseFare"));
            double interCityFare = Double.parseDouble(context.getInitParameter("interCityBaseFare"));
            double studentDiscount = Double.parseDouble(context.getInitParameter("studentDiscount"));
            double seniorDiscount = Double.parseDouble(context.getInitParameter("seniorDiscount"));
            double eveningDiscount = Double.parseDouble(context.getInitParameter("eveningDiscount"));
            double weeklyDiscount = Double.parseDouble(context.getInitParameter("weeklyDiscount"));

            // Set via DAO
            fareDao.setFareRules(cityFare, interCityFare, studentDiscount, seniorDiscount,
                    eveningDiscount, weeklyDiscount);

        }
    }

    // Getters for base fares
    public double getCityBaseFare() {
        return fareDao.getFareRule("cityFare");
    }

    public double getInterCityBaseFare() {
        return fareDao.getFareRule("interCityFare");
    }

    // Getters for discounts
    public double getStudentDiscount() {
        return fareDao.getFareRule("studentDiscount");
    }

    public double getSeniorDiscount() {
        return fareDao.getFareRule("seniorDiscount");
    }

    public double getEveningDiscount() {
        return fareDao.getFareRule("eveningDiscount");
    }

    public double getWeeklyDiscount() {
        return fareDao.getFareRule("weeklyDiscount");
    }

    // Setters
    public void setCityBaseFare(double cityFare) {
        fareDao.updateFareRule("cityFare", cityFare);
    }

    public void setInterCityBaseFare(double interCityFare) {
        fareDao.updateFareRule("interCityFare", interCityFare);
    }

    public void setStudentDiscount(double studentDiscount) {
        fareDao.updateFareRule("studentDiscount", studentDiscount);
    }

    public void setSeniorDiscount(double seniorDiscount) {
        fareDao.updateFareRule("seniorDiscount", seniorDiscount);
    }
    
    public void setEveningDiscount(double eveningDiscount) {
        fareDao.updateFareRule("eveningDiscount", eveningDiscount);
    }
    
    public void setWeeklyDiscount(double weeklyDiscount) {
        fareDao.updateFareRule("weeklyDiscount", weeklyDiscount);
    }
    
    

}
