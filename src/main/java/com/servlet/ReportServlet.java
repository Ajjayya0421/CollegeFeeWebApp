package com.servlet;

import com.dao.FeePaymentDAO;
import com.model.FeePayment;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/ReportServlet")
public class ReportServlet extends HttpServlet {
    
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect("reports.jsp");
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String reportType = request.getParameter("reportType");
        FeePaymentDAO dao = new FeePaymentDAO();
        
        try {
            if (reportType == null || reportType.isEmpty()) {
                throw new Exception("No report type selected");
            }
            
            // REPORT 1: OVERDUE PAYMENTS
            if ("overdue".equals(reportType)) {
                List<FeePayment> overduePayments = dao.getOverduePayments();
                
                if (overduePayments != null && !overduePayments.isEmpty()) {
                    request.setAttribute("reportData", overduePayments);
                    request.setAttribute("recordCount", overduePayments.size());
                    
                    BigDecimal totalOverdue = BigDecimal.ZERO;
                    for (FeePayment payment : overduePayments) {
                        totalOverdue = totalOverdue.add(payment.getAmount());
                    }
                    request.setAttribute("totalOverdue", totalOverdue);
                    request.setAttribute("hasData", true);
                } else {
                    request.setAttribute("hasData", false);
                    request.setAttribute("message", "No overdue payments found.");
                }
                request.setAttribute("reportTitle", "📌 Students with Overdue Payments");
                request.setAttribute("reportType", "overdue");
            }
            
            // REPORT 2: UNPAID STUDENTS
            else if ("unpaid".equals(reportType)) {
                String startDateStr = request.getParameter("startDate");
                String endDateStr = request.getParameter("endDate");
                
                if (startDateStr == null || startDateStr.isEmpty() || 
                    endDateStr == null || endDateStr.isEmpty()) {
                    throw new Exception("Please select both start and end dates");
                }
                
                Date startDate = Date.valueOf(startDateStr);
                Date endDate = Date.valueOf(endDateStr);
                
                if (startDate.after(endDate)) {
                    throw new Exception("Start date cannot be after end date");
                }
                
                List<FeePayment> unpaidStudents = dao.getUnpaidStudents(startDate, endDate);
                
                if (unpaidStudents != null && !unpaidStudents.isEmpty()) {
                    request.setAttribute("reportData", unpaidStudents);
                    request.setAttribute("recordCount", unpaidStudents.size());
                    request.setAttribute("hasData", true);
                } else {
                    request.setAttribute("hasData", false);
                    request.setAttribute("message", "All students have paid in this period.");
                }
                request.setAttribute("reportTitle", "📌 Students Who Haven't Paid");
                request.setAttribute("reportType", "unpaid");
                request.setAttribute("dateRange", startDateStr + " to " + endDateStr);
            }
            
            // REPORT 3: TOTAL COLLECTION (Simplified - without count method)
            else if ("collection".equals(reportType)) {
                String startDateStr = request.getParameter("startDate");
                String endDateStr = request.getParameter("endDate");
                
                if (startDateStr == null || startDateStr.isEmpty() || 
                    endDateStr == null || endDateStr.isEmpty()) {
                    throw new Exception("Please select both start and end dates");
                }
                
                Date startDate = Date.valueOf(startDateStr);
                Date endDate = Date.valueOf(endDateStr);
                
                if (startDate.after(endDate)) {
                    throw new Exception("Start date cannot be after end date");
                }
                
                BigDecimal totalCollection = dao.getTotalCollection(startDate, endDate);
                
                request.setAttribute("totalCollection", totalCollection);
                request.setAttribute("reportTitle", "💰 Total Fee Collection Report");
                request.setAttribute("reportType", "collection");
                request.setAttribute("dateRange", startDateStr + " to " + endDateStr);
                request.setAttribute("hasData", true);
            }
            
            else {
                throw new Exception("Invalid report type: " + reportType);
            }
            
            request.setAttribute("generatedDate", new java.util.Date());
            request.getRequestDispatcher("report_result.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
            request.getRequestDispatcher("reports.jsp").forward(request, response);
        }
    }
}