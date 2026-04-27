<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.dao.FeePaymentDAO, com.model.FeePayment, java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>All Fee Payment Records</title>
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
        .college-name { text-align: center; color: #666; margin-bottom: 30px; }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        th {
            background: #4CAF50;
            color: white;
            font-weight: bold;
        }
        tr:hover {
            background: #f5f5f5;
        }
        .btn {
            display: inline-block;
            padding: 10px 20px;
            margin: 20px 10px 0 0;
            background: #667eea;
            color: white;
            text-decoration: none;
            border-radius: 5px;
        }
        .btn-add {
            background: #4CAF50;
        }
        .btn-back {
            background: #666;
        }
        .btn:hover {
            opacity: 0.8;
        }
        .no-data {
            text-align: center;
            padding: 40px;
            color: #666;
            font-size: 18px;
        }
        .status-paid {
            color: green;
            font-weight: bold;
        }
        .status-pending {
            color: orange;
            font-weight: bold;
        }
        .status-overdue {
            color: red;
            font-weight: bold;
        }
        .total-box {
            margin-top: 20px;
            padding: 15px;
            background: #f0f0f0;
            border-radius: 5px;
            text-align: right;
            font-size: 18px;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>📋 All Fee Payment Records</h2>
        <div class="college-name">Alva's Institute of Engineering & Technology</div>
        
        <%
            FeePaymentDAO dao = new FeePaymentDAO();
            List<FeePayment> paymentList = dao.getAllFeePayments();
            
            if(paymentList != null && !paymentList.isEmpty()) {
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
                    for(FeePayment payment : paymentList) {
                        totalAmount += payment.getAmount().doubleValue();
                        
                        String statusClass = "";
                        if(payment.getStatus().equals("Paid")) statusClass = "status-paid";
                        else if(payment.getStatus().equals("Pending")) statusClass = "status-pending";
                        else if(payment.getStatus().equals("Overdue")) statusClass = "status-overdue";
                %>
                <tr>
                    <td><%= payment.getPaymentId() %></td>
                    <td><%= payment.getStudentId() %></td>
                    <td><%= payment.getStudentName() %></td>
                    <td><%= payment.getPaymentDate() %></td>
                    <td>₹ <%= String.format("%.2f", payment.getAmount()) %></td>
                    <td class="<%= statusClass %>"><%= payment.getStatus() %></td>
                </tr>
                <% } %>
            </tbody>
        </table>
        
        <div class="total-box">
            Total Collection: ₹ <%= String.format("%.2f", totalAmount) %>
        </div>
        
        <% } else { %>
            <div class="no-data">
                📭 No payment records found.<br><br>
                Click "Add Fee Payment" to add new records.
            </div>
        <% } %>
        
        <div style="margin-top: 30px; text-align: center;">
            <a href="feepaymentadd.jsp" class="btn btn-add">➕ Add Fee Payment</a>
            <a href="index.jsp" class="btn btn-back">← Back to Dashboard</a>
        </div>
    </div>
</body>
</html>