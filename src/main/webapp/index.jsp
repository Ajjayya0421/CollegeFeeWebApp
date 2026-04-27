<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>College Fee Management System - AIET</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        /* Full Page Background Image */
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            /* Option 1: Image from local folder */
            background-image: url('images/background.jpg');
            /* Option 2: If image is in WebContent root folder */
            /* background-image: url('background.jpg'); */
            
            /* Background styling */
            background-size: cover;           /* Cover entire page */
            background-position: center;      /* Center the image */
            background-repeat: no-repeat;     /* Don't repeat */
            background-attachment: fixed;     /* Fixed background while scrolling */
            min-height: 100vh;
        }
        
        /* Add overlay for better text readability */
        body::before {
            content: '';
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);  /* Dark overlay - adjust opacity */
            z-index: -1;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
            position: relative;
            z-index: 1;
        }
        
        /* Header Styles */
        .header {
            text-align: center;
            color: white;
            padding: 30px 0;
            background: rgba(0,0,0,0.6);
            border-radius: 15px;
            margin-bottom: 30px;
            backdrop-filter: blur(5px);
        }
        
        .logo {
            width: 80px;
            height: 80px;
            margin-bottom: 15px;
            background: white;
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 40px;
        }
        
        .header h1 {
            font-size: 1.8em;
            margin-bottom: 5px;
        }
        
        .header h2 {
            font-size: 1.3em;
            margin-top: 10px;
            color: #ffd700;
        }
        
        .header h3 {
            font-size: 1.1em;
            margin-bottom: 5px;
        }
        
        .header p {
            font-size: 0.9em;
            opacity: 0.9;
        }
        
        /* Dashboard Cards */
        .dashboard {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 25px;
            margin: 40px 0;
        }
        
        .card {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            padding: 30px 20px;
            text-align: center;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            cursor: pointer;
            text-decoration: none;
            color: #333;
            display: block;
            backdrop-filter: blur(10px);
        }
        
        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
            background: white;
        }
        
        .card-icon {
            font-size: 48px;
            margin-bottom: 15px;
        }
        
        .card h3 {
            font-size: 1.3em;
            margin-bottom: 10px;
        }
        
        .card p {
            color: #666;
            font-size: 0.85em;
        }
        
        .card.add { border-top: 5px solid #4CAF50; }
        .card.update { border-top: 5px solid #2196F3; }
        .card.delete { border-top: 5px solid #f44336; }
        .card.display { border-top: 5px solid #FF9800; }
        .card.reports { border-top: 5px solid #9C27B0; }
        
        .footer {
            text-align: center;
            color: white;
            padding: 20px;
            margin-top: 40px;
            background: rgba(0,0,0,0.6);
            border-radius: 10px;
        }
        
        @media (max-width: 768px) {
            .dashboard {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div class="logo">🏫</div>
            <h1>ALVA'S INSTITUTE OF ENGINEERING & TECHNOLOGY</h1>
            <h3>Department of Computer Science & Engineering</h3>
            <p>Shobhavana Campus, Mijar, Moodbidri, D.K. – 574225</p>
            <h2>College Fee Payment Management System</h2>
        </div>
        
        <div class="dashboard">
            <div class="card add" onclick="location.href='feepaymentadd.jsp'">
                <div class="card-icon">💰</div>
                <h3>Add Fee Payment</h3>
                <p>Record new fee payments from students</p>
            </div>
            
            <div class="card update" onclick="location.href='feepaymentupdate.jsp'">
                <div class="card-icon">✏️</div>
                <h3>Update Payment</h3>
                <p>Modify existing payment records</p>
            </div>
            
            <div class="card delete" onclick="location.href='feepaymentdelete.jsp'">
                <div class="card-icon">🗑️</div>
                <h3>Delete Payment</h3>
                <p>Remove payment records</p>
            </div>
            
            <div class="card display" onclick="location.href='DisplayFeePaymentsServlet'">
                <div class="card-icon">📋</div>
                <h3>View Payments</h3>
                <p>Display all payment records</p>
            </div>
            
            <div class="card reports" onclick="location.href='reports.jsp'">
                <div class="card-icon">📊</div>
                <h3>Reports</h3>
                <p>Generate various reports</p>
            </div>
        </div>
        
        <div class="footer">
            <p>© 2026 AIET, Mijar, Mangalore | Developed for Academic Project</p>
        </div>
    </div>
</body>
</html>