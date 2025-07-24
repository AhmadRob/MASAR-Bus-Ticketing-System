/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import dao.UserDAO;
import domain.User;
import util.DatabaseInitializer;

/**
 *
 * @author Ahmad
 */
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User u = new User();
        u.setName(request.getParameter("name"));
        u.setEmail(request.getParameter("email"));
        u.setPassword(request.getParameter("password"));
        
        UserDAO dao = new UserDAO();
        boolean success = dao.registerUser(u);

        if (success) {
            response.sendRedirect("login.jsp");
        } else {
            request.setAttribute("error", "Registration failed!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}
