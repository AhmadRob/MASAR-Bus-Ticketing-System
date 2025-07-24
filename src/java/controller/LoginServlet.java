/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import dao.UserDAO;
import javax.servlet.http.HttpSession;
import domain.User;

public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        UserDAO dao = new UserDAO();
        User user = dao.login(email, password);

        HttpSession session = request.getSession();

        if (user != null) {
            if ("admin".equalsIgnoreCase(user.getRole())) {
                session.invalidate();
                request.setAttribute("error", "Admins must use admin login");
                request.getRequestDispatcher("admin/adminLogin.jsp").forward(request, response);
            } else {
                request.getSession().setAttribute("user", user);
                session.setAttribute("userId", user.getId());
                response.sendRedirect("passengerDashboard.jsp");
            }
        } else {
            request.setAttribute("error", "Invalid email or password.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }

    }
}
