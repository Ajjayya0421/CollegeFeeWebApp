<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Report Form</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        .container {
            max-width: 900px;
            margin: 0 auto;
        }
        h2 {
            text-align: center;
            color: white;
            margin-bottom: 30px;
        }
        .form-container {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
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
        button {
            width: 100%;
            padding: 12px;
            background: #667eea;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
            margin-top: 10px;
        }
        button:hover { background: #5a67d8; }
        .back-link {
            display: inline-block;
            margin-top: 20px;
            padding: 10px 20px;
            background: white;
            color: #667eea;
            text-decoration: none;
            border-radius: 5px;
        }
        hr {
            margin: 20px 0;
            border: none;
            border-top: 1px solid #ddd;
        }
        .report-option {
            padding: 15px;
            background: #f8f9fa;
            border-radius: 10px;
            margin-bottom: 20px;
        }
        .report-option h3 {
            color: #333;
            margin-bottom: 10px;
        }
    </style>
    <script>
        function showReportForm(reportType) {
            document.getElementById('overdueForm').style.display = 'none';
            document.getElementById('unpaidForm').style.display = 'none';
            document.getElementById('collectionForm').style.display = 'none';
            
            if(reportType === 'overdue') {
                document.getElementById('overdueForm').style.display = 'block';
                document.getElementById('reportType').value = 'overdue';
            } else if(reportType === 'unpaid') {
                document.getElementById('unpaidForm').style.display = 'block';
                document.getElementById('reportType').value = 'unpaid';
            } else if(reportType === 'collection') {
                document.getElementById('collectionForm').style.display = 'block';
                document.getElementById('reportType').value = 'collection';
            }
        }
    </script>
</head>
<body>
    <div class="container">
        <h2> Fee Management Reports</h2>
        
        <div class="form-container">
            <input type="hidden" name="reportType" id="reportType">
            
            <div class="report-option" onclick="showReportForm('overdue')">
                <h3>1. Students with Overdue Payments</h3>
                <p>View all students who have overdue fee payments</p>
            </div>
            
            <div class="report-option" onclick="showReportForm('unpaid')">
                <h3>2. Students Who Haven't Paid in a Period</h3>
                <p>Find students who have not made any payment in selected date range</p>
            </div>
            
            <div class="report-option" onclick="showReportForm('collection')">
                <h3>3. Total Fee Collection Over Date Range</h3>
                <p>Calculate total fee collection for a specific period</p>
            </div>
            
            <hr>
            
            <!-- Overdue Report Form -->
            <form id="overdueForm" action="ReportServlet" method="post" style="display: none;">
                <input type="hidden" name="reportType" value="overdue">
                <button type="submit">Generate Overdue Report</button>
            </form>
            
            <!-- Unpaid Report Form -->
            <form id="unpaidForm" action="ReportServlet" method="post" style="display: none;">
                <input type="hidden" name="reportType" value="unpaid">
                <div class="form-group">
                    <label>Start Date:</label>
                    <input type="date" name="startDate" required>
                </div>
                <div class="form-group">
                    <label>End Date:</label>
                    <input type="date" name="endDate" required>
                </div>
                <button type="submit">Generate Unpaid Report</button>
            </form>
            
            <!-- Collection Report Form -->
            <form id="collectionForm" action="ReportServlet" method="post" style="display: none;">
                <input type="hidden" name="reportType" value="collection">
                <div class="form-group">
                    <label>Start Date:</label>
                    <input type="date" name="startDate" required>
                </div>
                <div class="form-group">
                    <label>End Date:</label>
                    <input type="date" name="endDate" required>
                </div>
                <button type="submit">Generate Collection Report</button>
            </form>
        </div>
        
        <a href="index.jsp" class="back-link">← Back to Dashboard</a>
    </div>
</body>
</html>