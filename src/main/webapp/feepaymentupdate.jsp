<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Date" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="com.dao.FeePaymentDAO" %>
<%@ page import="com.model.FeePayment" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Update Fee Payment</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        .container {
            max-width: 700px;
            margin: 0 auto;
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        }
        h2 { text-align: center; color: #333; margin-bottom: 10px; }
        .warning {
            background: #fff3cd;
            border: 1px solid #ffc107;
            color: #856404;
            padding: 12px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        .error {
            background: #f8d7da;
            border: 1px solid #f5c6cb;
            color: #721c24;
            padding: 12px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        .success {
            background: #d4edda;
            border: 1px solid #c3e6cb;
            color: #155724;
            padding: 12px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            color: #555;
            font-weight: 500;
        }
        input, select {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 16px;
        }
        button, .btn {
            padding: 12px 20px;
            background: #4CAF50;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
        }
        button:hover { background: #45a049; }
        .btn-back {
            background: #666;
            margin-left: 10px;
        }
        .btn-search {
            background: #667eea;
            width: auto;
        }
        .existing-ids {
            background: #e7f3ff;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            border-left: 4px solid #2196F3;
        }
        .id-badge {
            display: inline-block;
            background: #2196F3;
            color: white;
            padding: 5px 10px;
            margin: 5px;
            border-radius: 20px;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>✏️ Update Fee Payment</h2>
        
        <div class="warning">
            ⚠️ <strong>IMPORTANT:</strong> Search using PAYMENT ID, NOT Student ID!
        </div>
        
        <%
            FeePaymentDAO dao = new FeePaymentDAO();
            String paymentIdParam = request.getParameter("paymentId");
            String action = request.getParameter("action");
            String message = request.getParameter("message");
            String error = request.getParameter("error");
            
            // Display messages
            if(message != null) {
                out.println("<div class='success'>✅ " + message + "</div>");
            }
            if(error != null) {
                out.println("<div class='error'>❌ " + error + "</div>");
            }
            
            // Show existing Payment IDs
            List<FeePayment> allPayments = dao.getAllFeePayments();
            if(allPayments != null && !allPayments.isEmpty()) {
                out.println("<div class='existing-ids'>");
                out.println("<strong>📋 Available Payment IDs in Database:</strong><br>");
                for(FeePayment p : allPayments) {
                    out.println("<span class='id-badge'>Payment ID: " + p.getPaymentId() + " (Student: " + p.getStudentName() + ")</span>");
                }
                out.println("<br><small style='color:#666;'>💡 Use these Payment IDs to search</small>");
                out.println("</div>");
            } else {
                out.println("<div class='error'>❌ No records found! Please add a payment first.</div>");
                out.println("<div style='text-align:center; margin-top:20px;'>");
                out.println("<a href='feepaymentadd.jsp' class='btn'>➕ Add New Payment</a>");
                out.println("</div>");
            }
            
            // Handle search
            if(paymentIdParam != null && !paymentIdParam.isEmpty() && action == null) {
                try {
                    int paymentId = Integer.parseInt(paymentIdParam);
                    FeePayment payment = dao.getFeePaymentById(paymentId);
                    
                    if(payment != null) {
                        // Display update form with data
        %>
        
        <div class="success">
            ✅ Record found for Payment ID: <%= paymentId %>
        </div>
        
        <form action="feepaymentupdate.jsp" method="post">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="paymentId" value="<%= payment.getPaymentId() %>">
            
            <div class="form-group">
                <label>Payment ID (Read Only):</label>
                <input type="text" value="<%= payment.getPaymentId() %>" readonly disabled>
            </div>
            
            <div class="form-group">
                <label>Student ID:</label>
                <input type="number" name="studentId" value="<%= payment.getStudentId() %>" required>
            </div>
            
            <div class="form-group">
                <label>Student Name:</label>
                <input type="text" name="studentName" value="<%= payment.getStudentName() %>" required>
            </div>
            
            <div class="form-group">
                <label>Payment Date:</label>
                <input type="date" name="paymentDate" value="<%= payment.getPaymentDate() %>" required>
            </div>
            
            <div class="form-group">
                <label>Amount (₹):</label>
                <input type="number" step="0.01" name="amount" value="<%= payment.getAmount() %>" required>
            </div>
            
            <div class="form-group">
                <label>Status:</label>
                <select name="status">
                    <option value="Paid" <%= payment.getStatus().equals("Paid") ? "selected" : "" %>>✅ Paid</option>
                    <option value="Pending" <%= payment.getStatus().equals("Pending") ? "selected" : "" %>>⏳ Pending</option>
                    <option value="Overdue" <%= payment.getStatus().equals("Overdue") ? "selected" : "" %>>⚠️ Overdue</option>
                </select>
            </div>
            
            <button type="submit">💾 Update Payment</button>
            <a href="feepaymentupdate.jsp" class="btn btn-back">↺ New Search</a>
        </form>
        
        <%
                    } else {
                        out.println("<div class='error'>❌ No record found with Payment ID: " + paymentId + "</div>");
                    }
                } catch(NumberFormatException e) {
                    out.println("<div class='error'>❌ Invalid Payment ID format!</div>");
                }
            }
            
            // Handle update
            if("update".equals(action)) {
                try {
                    int paymentId = Integer.parseInt(request.getParameter("paymentId"));
                    int studentId = Integer.parseInt(request.getParameter("studentId"));
                    String studentName = request.getParameter("studentName");
                    Date paymentDate = Date.valueOf(request.getParameter("paymentDate"));
                    BigDecimal amount = new BigDecimal(request.getParameter("amount"));
                    String status = request.getParameter("status");
                    
                    FeePayment payment = new FeePayment();
                    payment.setPaymentId(paymentId);
                    payment.setStudentId(studentId);
                    payment.setStudentName(studentName);
                    payment.setPaymentDate(paymentDate);
                    payment.setAmount(amount);
                    payment.setStatus(status);
                    
                    boolean updated = dao.updateFeePayment(payment);
                    
                    if(updated) {
                        response.sendRedirect("feepaymentupdate.jsp?message=Payment ID " + paymentId + " updated successfully!");
                    } else {
                        response.sendRedirect("feepaymentupdate.jsp?error=Failed to update payment ID " + paymentId);
                    }
                } catch(Exception e) {
                    response.sendRedirect("feepaymentupdate.jsp?error=" + e.getMessage());
                }
            }
        %>
        
        <!-- Search Form -->
        <div style="margin-top: 30px; border-top: 1px solid #eee; padding-top: 20px;">
            <h3>🔍 Step 1: Search by Payment ID</h3>
            <form action="feepaymentupdate.jsp" method="get" style="margin-top: 15px;">
                <div class="form-group">
                    <label>Payment ID:</label>
                    <input type="number" name="paymentId" placeholder="Enter Payment ID (1, 2, 3...)" required>
                    <small style="color: #666;">💡 Payment IDs are 1, 2, 3... (NOT 1001, 1002...)</small>
                </div>
                <button type="submit" class="btn-search">🔍 Search</button>
                <a href="viewpayments.jsp" class="btn btn-back">📋 View All Payments</a>
            </form>
        </div>
        
        <div style="margin-top: 30px; text-align: center;">
            <a href="index.jsp" class="btn btn-back">← Back to Dashboard</a>
        </div>
    </div>
</body>
</html>