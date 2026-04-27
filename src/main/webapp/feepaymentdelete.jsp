<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Delete Fee Payment</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        .container {
            max-width: 500px;
            margin: 0 auto;
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        }
        h2 { text-align: center; color: #333; margin-bottom: 30px; }
        .form-group { margin-bottom: 20px; }
        label { display: block; margin-bottom: 5px; color: #555; font-weight: 500; }
        input {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 16px;
        }
        button {
            width: 100%;
            padding: 12px;
            background: #f44336;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
        }
        button:hover { background: #da190b; }
        .message {
            padding: 10px;
            margin-bottom: 20px;
            border-radius: 5px;
            text-align: center;
        }
        .success { background: #d4edda; color: #155724; }
        .error { background: #f8d7da; color: #721c24; }
        .back-link { display: block; text-align: center; margin-top: 20px; color: #667eea; text-decoration: none; }
        .back-link:hover { text-decoration: underline; }
        .warning {
            background: #fff3cd;
            color: #856404;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 20px;
            text-align: center;
        }
    </style>
    <script>
        function confirmDelete() {
            var paymentId = document.getElementById('paymentId').value;
            if(paymentId == "" || paymentId <= 0) {
                alert('Please enter a valid Payment ID');
                return false;
            }
            return confirm('⚠️ Are you sure you want to delete payment record #' + paymentId + '? This action cannot be undone!');
        }
    </script>
</head>
<body>
    <div class="container">
        <h2> Delete Fee Payment</h2>
        
        <div class="warning">
             Warning: Deletion is permanent and cannot be reversed!
        </div>
        
        <% 
            String message = (String) request.getAttribute("message");
            String messageType = (String) request.getAttribute("messageType");
            if (message != null) {
        %>
            <div class="message <%= messageType %>">
                <%= message %>
            </div>
        <% } %>
        
        <form action="DeleteFeePaymentServlet" method="post" onsubmit="return confirmDelete()">
            <div class="form-group">
                <label>Payment ID to Delete:</label>
                <input type="number" name="paymentId" id="paymentId" required placeholder="Enter Payment ID">
            </div>
            
            <button type="submit">Delete Payment</button>
        </form>
        
        <a href="index.jsp" class="back-link">← Back to Dashboard</a>
    </div>
</body>
</html>