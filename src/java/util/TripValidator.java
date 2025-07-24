package util;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.Date;
import domain.Trip;
import java.time.LocalTime;

public class TripValidator {

    public static List<String> validateTrip(Trip trip) {
        List<String> errors = new ArrayList<>();

        if (trip.getOrigin() == null || trip.getOrigin().trim().isEmpty()) {
            errors.add("Origin is required.");
        }

        if (trip.getDestination() == null || trip.getDestination().trim().isEmpty()) {
            errors.add("Destination is required.");
        }

        if (trip.getDate() == null || !trip.getDate().toString().matches("\\d{4}-\\d{2}-\\d{2}")) {
            errors.add("Invalid date format. Use YYYY-MM-DD.");
        } else {
            // Check if the date is before tomorrow
            Calendar cal = Calendar.getInstance();
            cal.set(Calendar.HOUR_OF_DAY, 0);
            cal.set(Calendar.MINUTE, 0);
            cal.set(Calendar.SECOND, 0);
            cal.set(Calendar.MILLISECOND, 0);
            cal.add(Calendar.DATE, 1); // move to tomorrow
            Date tomorrow = cal.getTime();

            if (trip.getDate().before(tomorrow)) {
                errors.add("Trip date must be tomorrow or later.");
            }
        }

        // Fixed time validation
        if (trip.getTime() == null) {
            errors.add("Time cannot be empty");
        } else {
            try {
                // Convert Timestamp to LocalTime and validate
                LocalTime time = trip.getTime().toLocalDateTime().toLocalTime();

                // Optional: Validate time is within reasonable bounds
                if (time.isBefore(LocalTime.of(4, 0))) {
                    errors.add("Time cannot be before 4:00 AM");
                }
                if (time.isAfter(LocalTime.of(23, 59))) {
                    errors.add("Time cannot be after midnight");
                }

            } catch (Exception e) {
                errors.add("Invalid time format. Use HH:MM or HH:MM:SS");
            }
        }

        if (trip.getCapacity() <= 0) {
            errors.add("Capacity must be a positive number.");
        }

        if (trip.getTravelType() == null
                || !(trip.getTravelType().equals("city") || trip.getTravelType().equals("inter_city"))) {
            errors.add("Travel type must be either 'city' or 'inter_city'.");
        }

        return errors;
    }
}
