<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.model.FeePayment" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Report Result - Fee Management System</title>
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
            margin-top: 20px;
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
        .total-amount {
            margin-top: 20px;
            padding: 20px;
            background: #e8f5e9;
            border-radius: 10px;
            text-align: center;
        }
        .total-amount h3 {
            color: #2e7d32;
            font-size: 28px;
        }
        .back-link {
            display: inline-block;
            margin-top: 20px;
            padding: 12px 24px;
            background: #667eea;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            margin-right: 10px;
        }
        .back-link:hover { background: #5a67d8; }
        .print-btn {
            background: #4CAF50;
        }
        .print-btn:hover { background: #45a049; }
        .no-data {
            text-align: center;
            padding: 50px;
            color: #666;
            font-size: 18px;
        }
        .error-message {
            background: #f8d7da;
            color: #721c24;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            text-align: center;
        }
        .status-paid { color: #4CAF50; font-weight: bold; }
        .status-overdue { color: #f44336; font-weight: bold; }
        .report-header {
            text-align: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #667eea;
        }
        .summary-box {
            background: #f0f4ff;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        @media print {
            body { background: white; padding: 0; }
            .container { box-shadow: none; padding: 20px; }
            .back-link, .print-btn { display: none; }
        }
    </style>
    <script>
        function printReport() {
            window.print();
        }
    </script>
</head>
<body>
    <div class="container">
        <%
            String reportTitle = (String) request.getAttribute("reportTitle");
            String reportType = (String) request.getAttribute("reportType");
            String dateRange = (String) request.getAttribute("dateRange");
            String error = (String) request.getAttribute("error");
            Boolean hasData = (Boolean) request.getAttribute("hasData");
            java.util.Date generatedDate = (java.util.Date) request.getAttribute("generatedDate");
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy hh:mm a");
            
            if (error != null) {
        %>
            <div class="error-message">
                <strong>❌ Error:</strong> <%= error %>
            </div>
        <% } %>
        
        <div class="report-header">
            <h2>📊 <%= (reportTitle != null) ? reportTitle : "Fee Report" %></h2>
            <h3>Alva's Institute of Engineering & Technology, Mijar</h3>
            <p>Department of Computer Science & Engineering</p>
            <% if(dateRange != null) { %>
                <p><strong>📅 Period:</strong> <%= dateRange %></p>
            <% } %>
            <p><strong>🕐 Generated on:</strong> <%= (generatedDate != null) ? sdf.format(generatedDate) : new java.util.Date().toString() %></p>
        </div>
        
        <%
            // REPORT 1: OVERDUE PAYMENTS
            if ("overdue".equals(reportType)) {
                List<FeePayment> overduePayments = (List<FeePayment>) request.getAttribute("reportData");
                if (overduePayments != null && !overduePayments.isEmpty()) {
                    double totalOverdue = 0;
        %>
            <div class="summary-box">
                <strong>📋 Summary:</strong> Found <%= overduePayments.size() %> student(s) with overdue payments
            </div>
            <div style="overflow-x: auto;">
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
                            for (FeePayment payment : overduePayments) {
                                totalOverdue += payment.getAmount().doubleValue();
                        %>
                            <tr>
                                <td><%= payment.getPaymentId() %></td>
                                <td><%= payment.getStudentId() %></td>
                                <td><%= payment.getStudentName() %></td>
                                <td><%= payment.getPaymentDate() %></td>
                                <td>₹ <%= String.format("%,.2f", payment.getAmount()) %></td>
                                <td class="status-overdue">⚠️ <%= payment.getStatus() %></td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
            <div class="total-amount">
                <h3>💰 Total Overdue Amount: ₹ <%= String.format("%,.2f", totalOverdue) %></h3>
            </div>
        <% } else { %>
            <div class="no-data">
                ✅ <strong>No overdue payments found!</strong><br>
                All students have paid their fees on time.
            </div>
        <% }
            // REPORT 2: UNPAID STUDENTS
            } else if ("unpaid".equals(reportType)) {
                List<FeePayment> unpaidStudents = (List<FeePayment>) request.getAttribute("reportData");
                if (unpaidStudents != null && !unpaidStudents.isEmpty()) {
        %>
            <div class="summary-box">
                <strong>📋 Summary:</strong> Found <%= unpaidStudents.size() %> student(s) who haven't paid in this period
            </div>
            <div style="overflow-x: auto;">
                <table>
                    <thead>
                        <tr>
                            <th>Sl No.</th>
                            <th>Student ID</th>
                            <th>Student Name</th>
                            <th>Status</th>
                            <th>Action Required</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            int slNo = 1;
                            for (FeePayment student : unpaidStudents) {
                        %>
                            <tr>
                                <td><%= slNo++ %></td>
                                <td><%= student.getStudentId() %></td>
                                <td><%= student.getStudentName() %></td>
                                <td class="status-overdue">⚠️ Not Paid</td>
                                <td>Send Reminder</td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
            <div class="total-amount">
                <h3>📊 Total Unpaid Students: <%= unpaidStudents.size() %></h3>
            </div>
        <% } else { %>
            <div class="no-data">
                ✅ <strong>All students have paid within this period!</strong><br>
                No unpaid students found for the selected date range.
            </div>
        <% }
            // REPORT 3: TOTAL COLLECTION
            } else if ("collection".equals(reportType)) {
                BigDecimal totalCollection = (BigDecimal) request.getAttribute("totalCollection");
                Integer paymentCount = (Integer) request.getAttribute("paymentCount");
                if (totalCollection == null) totalCollection = BigDecimal.ZERO;
                if (paymentCount == null) paymentCount = 0;
        %>
            <div class="summary-box">
                <strong>📋 Collection Summary for:</strong> <%= dateRange %>
            </div>
            <div class="total-amount">
                <h3>💰 Total Fee Collection: ₹ <%= String.format("%,.2f", totalCollection) %></h3>
                <p style="margin-top: 10px;">📊 Number of Payments: <%= paymentCount %></p>
            </div>
            
            <div style="overflow-x: auto;">
                <table style="margin-top: 30px;">
                    <thead>
                        <tr>
                            <th>Report Details</th>
                            <th>Information</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><strong>Report Period</strong></td>
                            <td><%= dateRange %></td>
                        </tr>
                        <tr>
                            <td><strong>Total Collection</strong></td>
                            <td>₹ <%= String.format("%,.2f", totalCollection) %></td>
                        </tr>
                        <tr>
                            <td><strong>Number of Payments</strong></td>
                            <td><%= paymentCount %></td>
                        </tr>
                        <tr>
                            <td><strong>Report Generated On</strong></td>
                            <td><%= new java.util.Date().toString() %></td>
                        </tr>
                    </tbody>
                </table>
            </div>
        <% } else { %>
            <div class="no-data">
                📭 <strong>No data available for this report.</strong><br>
                Please go back and select a report type.
            </div>
        <% } %>
        
        <div style="margin-top: 30px;">
            <a href="reports.jsp" class="back-link">← Back to Reports</a>
            <a href="index.jsp" class="back-link">← Dashboard</a>
            <button onclick="printReport()" class="back-link print-btn">🖨️ Print Report</button>
        </div>
    </div>
</body>
</html>