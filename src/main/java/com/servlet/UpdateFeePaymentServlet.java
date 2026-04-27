package com.servlet;

import com.dao.FeePaymentDAO;
import com.model.FeePayment;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/UpdateFeePaymentServlet")
public class UpdateFeePaymentServlet extends HttpServlet {
    
    private static final long serialVersionUID = 1L;
    
    // Handle GET - Search for payment
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String paymentIdParam = request.getParameter("id");
        
        if (paymentIdParam != null && !paymentIdParam.isEmpty()) {
            try {
                int paymentId = Integer.parseInt(paymentIdParam);
                FeePaymentDAO dao = new FeePaymentDAO();
                FeePayment payment = dao.getFeePaymentById(paymentId);
                
                if (payment != null) {
                    request.setAttribute("payment", payment);
                    request.setAttribute("message", "✅ Record found! You can now update.");
                    request.setAttribute("messageType", "success");
                } else {
                    request.setAttribute("message", "❌ No record found with Payment ID: " + paymentId);
                    request.setAttribute("messageType", "error");
                    // Get all payments to show available IDs
                    request.setAttribute("allPayments", dao.getAllFeePayments());
                }
            } catch (NumberFormatException e) {
                request.setAttribute("message", "❌ Invalid Payment ID! Please enter a number.");
                request.setAttribute("messageType", "error");
            }
        }
        
        request.getRequestDispatcher("feepaymentupdate.jsp").forward(request, response);
    }
    
    // Handle POST - Update payment
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // Get parameters
            int paymentId = Integer.parseInt(request.getParameter("paymentId"));
            int studentId = Integer.parseInt(request.getParameter("studentId"));
            String studentName = request.getParameter("studentName");
            Date paymentDate = Date.valueOf(request.getParameter("paymentDate"));
            BigDecimal amount = new BigDecimal(request.getParameter("amount"));
            String status = request.getParameter("status");
            
            // Create payment object
            FeePayment payment = new FeePayment();
            payment.setPaymentId(paymentId);
            payment.setStudentId(studentId);
            payment.setStudentName(studentName);
            payment.setPaymentDate(paymentDate);
            payment.setAmount(amount);
            payment.setStatus(status);
            
            // Update in database
            FeePaymentDAO dao = new FeePaymentDAO();
            boolean isUpdated = dao.updateFeePayment(payment);
            
            if (isUpdated) {
                request.setAttribute("message", "✅ Fee payment updated successfully!");
                request.setAttribute("messageType", "success");
                // Fetch updated record to display
                request.setAttribute("payment", dao.getFeePaymentById(paymentId));
            } else {
                request.setAttribute("message", "❌ Failed to update fee payment!");
                request.setAttribute("messageType", "error");
            }
            
        } catch (Exception e) {
            request.setAttribute("message", "❌ Error: " + e.getMessage());
            request.setAttribute("messageType", "error");
            e.printStackTrace();
        }
        
        request.getRequestDispatcher("feepaymentupdate.jsp").forward(request, response);
    }
}