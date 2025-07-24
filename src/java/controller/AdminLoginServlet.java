package controller;

import domain.User;
import dao.UserDAO;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class AdminLoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        UserDAO userDAO = new UserDAO();
        User admin = userDAO.login(email, password);

        if (admin != null && "admin".equalsIgnoreCase(admin.getRole())) {
            HttpSession session = request.getSession();
            session.setAttribute("user", admin);
            response.sendRedirect("AdminServlet");
        } else {
            request.setAttribute("error", "Invalid admin credentials");
            RequestDispatcher dispatcher = request.getRequestDispatcher("admin/adminLogin.jsp");
            dispatcher.forward(request, response);
        }
    }
}
