package com.servlet;

import com.dao.FeePaymentDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/DeleteFeePaymentServlet")
public class DeleteFeePaymentServlet extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            int paymentId = Integer.parseInt(request.getParameter("paymentId"));
            
            if (paymentId <= 0) {
                request.setAttribute("message", "Invalid Payment ID!");
                request.setAttribute("messageType", "error");
                request.getRequestDispatcher("feepaymentdelete.jsp").forward(request, response);
                return;
            }
            
            FeePaymentDAO dao = new FeePaymentDAO();
            boolean isDeleted = dao.deleteFeePayment(paymentId);
            
            if (isDeleted) {
                request.setAttribute("message", " Fee payment deleted successfully!");
                request.setAttribute("messageType", "success");
            } else {
                request.setAttribute("message", " Failed to delete fee payment! Payment ID not found.");
                request.setAttribute("messageType", "error");
            }
            
        } catch (Exception e) {
            request.setAttribute("message", " Error: " + e.getMessage());
            request.setAttribute("messageType", "error");
        }
        
        request.getRequestDispatcher("feepaymentdelete.jsp").forward(request, response);
    }
}