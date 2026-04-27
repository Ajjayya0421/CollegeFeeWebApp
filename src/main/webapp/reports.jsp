<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Reports - Fee Management System</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
        }
        h2 {
            text-align: center;
            color: white;
            margin-bottom: 30px;
        }
        .report-card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 25px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            transition: transform 0.3s;
        }
        .report-card:hover {
            transform: translateY(-3px);
        }
        .report-card h3 {
            color: #333;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 2px solid #667eea;
        }
        .form-group {
            margin-bottom: 15px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            color: #555;
            font-weight: 500;
        }
        input {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
        }
        button {
            padding: 12px 24px;
            background: #667eea;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            font-weight: bold;
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
        .back-link:hover { background: #f0f0f0; }
        .date-row {
            display: flex;
            gap: 15px;
        }
        .date-row .form-group {
            flex: 1;
        }
        .info-text {
            color: #666;
            font-size: 13px;
            margin-top: 5px;
        }
    </style>
    <script>
        function validateDateRange(startDateId, endDateId) {
            var startDate = document.getElementById(startDateId).value;
            var endDate = document.getElementById(endDateId).value;
            
            if(startDate && endDate) {
                if(new Date(startDate) > new Date(endDate)) {
                    alert('❌ End Date must be after Start Date');
                    return false;
                }
            }
            return true;
        }
    </script>
</head>
<body>
    <div class="container">
        <h2>📊 Fee Management Reports</h2>
        
        <!-- Report 1: Overdue Payments -->
        <div class="report-card">
            <h3>1. 📌 Students with Overdue Payments</h3>
            <p style="margin-bottom: 15px; color: #666;">Get list of all students who have overdue fee payments.</p>
            <form action="ReportServlet" method="post">
                <input type="hidden" name="reportType" value="overdue">
                <button type="submit">📄 Generate Overdue Report</button>
            </form>
        </div>
        
        <!-- Report 2: Unpaid Students -->
        <div class="report-card">
            <h3>2. ⏰ Students Who Haven't Paid in a Period</h3>
            <p style="margin-bottom: 15px; color: #666;">Find students who have not made any payment in the selected date range.</p>
            <form action="ReportServlet" method="post" onsubmit="return validateDateRange('startDate1', 'endDate1')">
                <input type="hidden" name="reportType" value="unpaid">
                <div class="date-row">
                    <div class="form-group">
                        <label>📅 Start Date:</label>
                        <input type="date" name="startDate" id="startDate1" required>
                    </div>
                    <div class="form-group">
                        <label>📅 End Date:</label>
                        <input type="date" name="endDate" id="endDate1" required>
                    </div>
                </div>
                <button type="submit" style="margin-top: 15px;">📄 Generate Unpaid Report</button>
            </form>
        </div>
        
        <!-- Report 3: Total Collection -->
        <div class="report-card">
            <h3>3. 💰 Total Fee Collection Over Date Range</h3>
            <p style="margin-bottom: 15px; color: #666;">Calculate total fee collection amount for a specific period.</p>
            <form action="ReportServlet" method="post" onsubmit="return validateDateRange('startDate2', 'endDate2')">
                <input type="hidden" name="reportType" value="collection">
                <div class="date-row">
                    <div class="form-group">
                        <label>📅 Start Date:</label>
                        <input type="date" name="startDate" id="startDate2" required>
                    </div>
                    <div class="form-group">
                        <label>📅 End Date:</label>
                        <input type="date" name="endDate" id="endDate2" required>
                    </div>
                </div>
                <button type="submit" style="margin-top: 15px;">📄 Generate Collection Report</button>
            </form>
        </div>
        
        <br>
        <a href="index.jsp" class="back-link">← Back to Dashboard</a>
    </div>
</body>
</html>