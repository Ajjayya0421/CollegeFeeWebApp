<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.dao.FeePaymentDAO, com.model.FeePayment, java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Fee Payment</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        .container {
            max-width: 600px;
            margin: 0 auto;
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        }
        h2 { text-align: center; color: #333; margin-bottom: 30px; }
        .form-group { margin-bottom: 20px; }
        label { display: block; margin-bottom: 5px; color: #555; font-weight: 500; }
        input, select {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 16px;
        }
        button {
            width: 100%;
            padding: 12px;
            background: #4CAF50;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
        }
        button:hover { background: #45a049; }
        .message {
            padding: 10px;
            margin-bottom: 20px;
            border-radius: 5px;
            text-align: center;
        }
        .success { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .error { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
        .back-link { display: block; text-align: center; margin-top: 20px; color: #667eea; text-decoration: none; }
        .back-link:hover { text-decoration: underline; }
        .payment-list {
            margin-top: 30px;
            border-top: 2px solid #eee;
            padding-top: 20px;
        }
        .payment-item {
            background: #f9f9f9;
            padding: 10px;
            margin-bottom: 10px;
            border-radius: 5px;
            border-left: 4px solid #4CAF50;
        }
    </style>
    <script>
        function validateForm() {
            var studentId = document.getElementById('studentId').value;
            var studentName = document.getElementById('studentName').value;
            var amount = document.getElementById('amount').value;
            var paymentDate = document.getElementById('paymentDate').value;
            
            if(studentId == "" || studentId <= 0) {
                alert('Please enter valid Student ID');
                return false;
            }
            if(studentName.trim() == "") {
                alert('Please enter Student Name');
                return false;
            }
            if(paymentDate == "") {
                alert('Please select Payment Date');
                return false;
            }
            if(amount == "" || amount <= 0) {
                alert('Please enter valid Amount');
                return false;
            }
            return true;
        }
    </script>
</head>
<body>
    <div class="container">
        <h2>💰 Add New Fee Payment</h2>
        
        <% 
            String message = request.getParameter("message");
            String error = request.getParameter("error");
            
            if(message != null) {
                out.println("<div class='message success'>✅ " + message + "</div>");
            }
            if(error != null) {
                out.println("<div class='message error'>❌ " + error + "</div>");
            }
        %>
        
        <form method="post" action="AddFeePaymentServlet" onsubmit="return validateForm()">
            <div class="form-group">
                <label>Student ID:</label>
                <input type="number" name="studentId" id="studentId" required placeholder="Enter Student ID (e.g., 1001)">
            </div>
            
            <div class="form-group">
                <label>Student Name:</label>
                <input type="text" name="studentName" id="studentName" required placeholder="Enter Student Name">
            </div>
            
            <div class="form-group">
                <label>Payment Date:</label>
                <input type="date" name="paymentDate" id="paymentDate" required>
            </div>
            
            <div class="form-group">
                <label>Amount (₹):</label>
                <input type="number" step="0.01" name="amount" id="amount" required placeholder="Enter Amount">
            </div>
            
            <div class="form-group">
                <label>Status:</label>
                <select name="status">
                    <option value="Paid">✅ Paid</option>
                    <option value="Pending">⏳ Pending</option>
                    <option value="Overdue">⚠️ Overdue</option>
                </select>
            </div>
            
            <button type="submit">💾 Add Payment</button>
        </form>
        
        <!-- Display payment history from DATABASE -->
        <div class="payment-list">
            <h3>📋 Recent Payments</h3>
            <%
                FeePaymentDAO dao = new FeePaymentDAO();
                List<FeePayment> paymentList = dao.getAllFeePayments();
                
                if(paymentList != null && !paymentList.isEmpty()) {
                    int count = 0;
                    // Show last 5 payments (most recent first)
                    for(int i = paymentList.size() - 1; i >= 0 && count < 5; i--, count++) {
                        FeePayment payment = paymentList.get(i);
                        out.println("<div class='payment-item'>");
                        out.println("<strong>Student:</strong> " + payment.getStudentName() + " (ID: " + payment.getStudentId() + ")<br>");
                        out.println("<strong>Payment ID:</strong> " + payment.getPaymentId() + "<br>");
                        out.println("<strong>Amount:</strong> ₹" + payment.getAmount() + "<br>");
                        out.println("<strong>Date:</strong> " + payment.getPaymentDate() + "<br>");
                        out.println("<strong>Status:</strong> " + payment.getStatus());
                        out.println("</div>");
                    }
                } else {
                    out.println("<p>No payments recorded yet.</p>");
                }
            %>
        </div>
        
        <a href="index.jsp" class="back-link">← Back to Dashboard</a>
    </div>
</body>
</html>