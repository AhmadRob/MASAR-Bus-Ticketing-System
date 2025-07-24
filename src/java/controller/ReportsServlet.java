package controller;

import dao.TicketDAO;
import domain.Ticket;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

public class ReportsServlet extends HttpServlet {

    private static final SimpleDateFormat INPUT_DATE_FORMAT = new SimpleDateFormat("MMM dd, yyyy", Locale.ENGLISH);
    private static final SimpleDateFormat DATE_TO_STRING_FORMAT = new SimpleDateFormat("yyyy-MM-dd");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        TicketDAO ticketDAO = new TicketDAO();
        List<Ticket> filteredTickets = new ArrayList<>();
        String errorMessage = null;

        String range = request.getParameter("dateRange");
        System.out.println("range: " + range);
        String ticketType = request.getParameter("ticketType");
        String userCategory = request.getParameter("userCategory");

        try {
            // Get all tickets if no filters are specified
            if ((range == null || range.isEmpty())
                    && (ticketType == null || ticketType.isEmpty())
                    && (userCategory == null || userCategory.isEmpty())) {
                filteredTickets = ticketDAO.getAllTickets();
            } else {
                List<Ticket> workingList = ticketDAO.getAllTickets();

                // Apply date range filter if specified
                if (range != null && !range.isEmpty() && range.contains(" - ")) {
                    String[] parts = range.split(" - ");
                    if (parts.length == 2) {
                        Date startDate = INPUT_DATE_FORMAT.parse(parts[0].trim());
                        Date endDate = INPUT_DATE_FORMAT.parse(parts[1].trim());

                        // Format to full-day Timestamps
                        String startStr = DATE_TO_STRING_FORMAT.format(startDate) + " 00:00:00";
                        String endStr = DATE_TO_STRING_FORMAT.format(endDate) + " 23:59:59";

                        Timestamp sqlStartTimestamp = Timestamp.valueOf(startStr);
                        Timestamp sqlEndTimestamp = Timestamp.valueOf(endStr);

                        List<Ticket> dateFiltered = ticketDAO.getTicketsByDateRange(sqlStartTimestamp, sqlEndTimestamp);
                        
                        workingList.clear();
                        workingList.addAll(dateFiltered);
                        
                        System.out.println("workingList: " + workingList);
                    }
                }

                // Apply ticket type filter if specified
                if (ticketType != null && !ticketType.isEmpty()) {
                    workingList.removeIf(ticket ->
                            !ticketType.equalsIgnoreCase(ticket.getTicketType()));
                }

                // Apply user category filter if specified
                if (userCategory != null && !userCategory.isEmpty()) {
                    workingList.removeIf(ticket ->
                            !userCategory.equalsIgnoreCase(ticket.getUserCategory()));
                }

                filteredTickets = workingList;
            }

            // Calculate statistics
            double totalRevenue = filteredTickets.stream()
                    .filter(Objects::nonNull)
                    .mapToDouble(Ticket::getFare)
                    .sum();

            // Set request attributes
            request.setAttribute("commonTickets", filteredTickets);
            request.setAttribute("totalSoldTickets", filteredTickets.size());
            request.setAttribute("totalRevenue", String.format("%.2f", totalRevenue));
            request.setAttribute("adminPath", "admin/");

            // Pass back filter values
            request.setAttribute("dateRangeParam", range);
            request.setAttribute("ticketTypeParam", ticketType);
            request.setAttribute("userCategoryParam", userCategory);

        } catch (ParseException e) {
            errorMessage = "Invalid date format. Please use format like 'Apr 25, 2025 - Jun 24, 2025'";
        } catch (Exception e) {
            errorMessage = "System error: " + e.getMessage();
            e.printStackTrace();
        }

        if (errorMessage != null) {
            request.setAttribute("error", errorMessage);
        }

        request.getRequestDispatcher("admin/reports.jsp").forward(request, response);
    }
}
