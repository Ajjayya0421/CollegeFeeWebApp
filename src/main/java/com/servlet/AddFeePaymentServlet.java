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

@WebServlet("/AddFeePaymentServlet")
public class AddFeePaymentServlet extends HttpServlet {
    
    private static final long serialVersionUID = 1L;
    private FeePaymentDAO feePaymentDAO = new FeePaymentDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/feepaymentadd.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // Get form parameters
            String studentIdStr = request.getParameter("studentId");
            String studentName = request.getParameter("studentName");
            String paymentDateStr = request.getParameter("paymentDate");
            String amountStr = request.getParameter("amount");
            String status = request.getParameter("status");
            
            // Validation
            if (studentIdStr == null || studentIdStr.trim().isEmpty() ||
                studentName == null || studentName.trim().isEmpty() ||
                paymentDateStr == null || paymentDateStr.trim().isEmpty() ||
                amountStr == null || amountStr.trim().isEmpty()) {
                
                request.setAttribute("message", "❌ All fields are required!");
                request.setAttribute("messageType", "error");
                request.getRequestDispatcher("/feepaymentadd.jsp").forward(request, response);
                return;
            }
            
            // Parse values
            int studentId = Integer.parseInt(studentIdStr);
            double amountValue = Double.parseDouble(amountStr);
            
            if (studentId <= 0) {
                request.setAttribute("message", "❌ Student ID must be greater than 0!");
                request.setAttribute("messageType", "error");
                request.getRequestDispatcher("/feepaymentadd.jsp").forward(request, response);
                return;
            }
            
            if (amountValue <= 0) {
                request.setAttribute("message", "❌ Amount must be greater than 0!");
                request.setAttribute("messageType", "error");
                request.getRequestDispatcher("/feepaymentadd.jsp").forward(request, response);
                return;
            }
            
            // Create FeePayment object
            FeePayment payment = new FeePayment();
            payment.setStudentId(studentId);
            payment.setStudentName(studentName.trim());
            payment.setPaymentDate(Date.valueOf(paymentDateStr));
            payment.setAmount(BigDecimal.valueOf(amountValue));
            payment.setStatus(status);
            
            // Save to database
            boolean isSaved = feePaymentDAO.addFeePayment(payment);
            
            if (isSaved) {
                request.setAttribute("message", "✅ Payment added successfully!");
                request.setAttribute("messageType", "success");
                request.setAttribute("recordAdded", true);
            } else {
                request.setAttribute("message", "❌ Failed to save payment. Please check database connection!");
                request.setAttribute("messageType", "error");
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("message", "❌ Invalid Student ID or Amount format!");
            request.setAttribute("messageType", "error");
        } catch (IllegalArgumentException e) {
            request.setAttribute("message", "❌ Invalid date format! Use YYYY-MM-DD.");
            request.setAttribute("messageType", "error");
        } catch (Exception e) {
            request.setAttribute("message", "❌ Error: " + e.getMessage());
            request.setAttribute("messageType", "error");
            e.printStackTrace();
        }
        
        request.getRequestDispatcher("/feepaymentadd.jsp").forward(request, response);
    }
}