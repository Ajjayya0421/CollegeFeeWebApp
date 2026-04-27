<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.model.FeePayment" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>All Fee Payments</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        }
        h2 { text-align: center; color: #333; margin-bottom: 10px; }
        .subtitle { text-align: center; color: #666; margin-bottom: 30px; }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        th {
            background: #667eea;
            color: white;
            font-weight: 600;
        }
        tr:hover { background: #f5f5f5; }
        .status-paid { color: #4CAF50; font-weight: bold; }
        .status-overdue { color: #f44336; font-weight: bold; }
        .back-link {
            display: inline-block;
            margin-top: 20px;
            padding: 10px 20px;
            background: #667eea;
            color: white;
            text-decoration: none;
            border-radius: 5px;
        }
        .back-link:hover { background: #5a67d8; }
        .no-data {
            text-align: center;
            padding: 40px;
            color: #666;
        }
        .total-records {
            margin-top: 20px;
            padding: 10px;
            background: #e8f5e9;
            border-radius: 5px;
            text-align: right;
            font-weight: bold;
        }
        @media (max-width: 768px) {
            th, td { padding: 8px; font-size: 12px; }
            .container { padding: 15px; }
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>📋 All Fee Payment Records</h2>
        <div class="subtitle">Alva's Institute of Engineering & Technology</div>
        
        <%
            List<FeePayment> payments = (List<FeePayment>) request.getAttribute("payments");
            if (payments != null && !payments.isEmpty()) {
        %>
            <table>
                <thead>
                    <tr>
                        <th>Payment ID</th>
                        <th>Student ID</th>
                        <th>Student Name</th>
                        <th>Payment Date</th>
                        <th>Amount (₹)</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        double totalAmount = 0;
                        for (FeePayment payment : payments) {
                            totalAmount += payment.getAmount().doubleValue();
                    %>
                        <tr>
                            <td><%= payment.getPaymentId() %></td>
                            <td><%= payment.getStudentId() %></td>
                            <td><%= payment.getStudentName() %></td>
                            <td><%= payment.getPaymentDate() %></td>
                            <td>₹ <%= String.format("%,.2f", payment.getAmount()) %></td>
                            <td class="<%= payment.getStatus().equals("Paid") ? "status-paid" : "status-overdue" %>">
                                <%= payment.getStatus() %>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
            <div class="total-records">
                Total Records: <%= payments.size() %> | Total Amount: ₹ <%= String.format("%,.2f", totalAmount) %>
            </div>
        <% } else { %>
            <div class="no-data">
                <p>📭 No payment records found.</p>
                <p>Click "Add Fee Payment" to add new records.</p>
            </div>
        <% } %>
        
        <br>
        <a href="index.jsp" class="back-link">← Back to Dashboard</a>
    </div>
</body>
</html>