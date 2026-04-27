package com.dao;

import com.model.FeePayment;
import com.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.math.BigDecimal;

public class FeePaymentDAO {
    
    // Add new fee payment - WITH AUTO-INCREMENT PAYMENT ID
    public boolean addFeePayment(FeePayment payment) {
        String query = "INSERT INTO FeePayments (StudentID, StudentName, PaymentDate, Amount, Status) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {  // ✅ Added RETURN_GENERATED_KEYS
            
            pstmt.setInt(1, payment.getStudentId());
            pstmt.setString(2, payment.getStudentName());
            pstmt.setDate(3, payment.getPaymentDate());
            pstmt.setBigDecimal(4, payment.getAmount());
            pstmt.setString(5, payment.getStatus());
            
            int affectedRows = pstmt.executeUpdate();
            
            if (affectedRows > 0) {
                // ✅ Retrieve the auto-generated PaymentID
                try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        payment.setPaymentId(generatedKeys.getInt(1));  // Auto-increment PaymentID set back to object
                    }
                }
                return true;
            }
            return false;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Update fee payment
    public boolean updateFeePayment(FeePayment payment) {
        String query = "UPDATE FeePayments SET StudentID=?, StudentName=?, PaymentDate=?, Amount=?, Status=? WHERE PaymentID=?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, payment.getStudentId());
            pstmt.setString(2, payment.getStudentName());
            pstmt.setDate(3, payment.getPaymentDate());
            pstmt.setBigDecimal(4, payment.getAmount());
            pstmt.setString(5, payment.getStatus());
            pstmt.setInt(6, payment.getPaymentId());
            
            return pstmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Delete fee payment
    public boolean deleteFeePayment(int paymentId) {
        String query = "DELETE FROM FeePayments WHERE PaymentID=?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, paymentId);
            return pstmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Get all fee payments
    public List<FeePayment> getAllFeePayments() {
        List<FeePayment> payments = new ArrayList<>();
        String query = "SELECT * FROM FeePayments ORDER BY PaymentDate DESC";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            
            while (rs.next()) {
                payments.add(extractPaymentFromResultSet(rs));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return payments;
    }
    
    // Get payment by ID
    public FeePayment getFeePaymentById(int paymentId) {
        String query = "SELECT * FROM FeePayments WHERE PaymentID = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, paymentId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return extractPaymentFromResultSet(rs);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    // Get overdue payments
    public List<FeePayment> getOverduePayments() {
        List<FeePayment> payments = new ArrayList<>();
        String query = "SELECT * FROM FeePayments WHERE Status = 'Overdue' ORDER BY PaymentDate DESC";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            
            while (rs.next()) {
                payments.add(extractPaymentFromResultSet(rs));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return payments;
    }
    
    // Get unpaid students in date range
    public List<FeePayment> getUnpaidStudents(Date startDate, Date endDate) {
        List<FeePayment> unpaidStudents = new ArrayList<>();
        String query = "SELECT DISTINCT StudentID, StudentName FROM FeePayments " +
                      "WHERE StudentID NOT IN (SELECT DISTINCT StudentID FROM FeePayments " +
                      "WHERE PaymentDate BETWEEN ? AND ? AND Status = 'Paid')";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setDate(1, startDate);
            pstmt.setDate(2, endDate);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                FeePayment payment = new FeePayment();
                payment.setStudentId(rs.getInt("StudentID"));
                payment.setStudentName(rs.getString("StudentName"));
                unpaidStudents.add(payment);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return unpaidStudents;
    }
    
    // Get total collection in date range
    public BigDecimal getTotalCollection(Date startDate, Date endDate) {
        String query = "SELECT COALESCE(SUM(Amount), 0) as Total FROM FeePayments " +
                      "WHERE PaymentDate BETWEEN ? AND ? AND Status = 'Paid'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setDate(1, startDate);
            pstmt.setDate(2, endDate);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getBigDecimal("Total");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return BigDecimal.ZERO;
    }
    
    // Get payment count in date range
    public int getPaymentCountInDateRange(Date startDate, Date endDate) {
        String query = "SELECT COUNT(*) as Count FROM FeePayments " +
                      "WHERE PaymentDate BETWEEN ? AND ? AND Status = 'Paid'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setDate(1, startDate);
            pstmt.setDate(2, endDate);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("Count");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return 0;
    }
    
    // Helper method to extract payment from ResultSet
    private FeePayment extractPaymentFromResultSet(ResultSet rs) throws SQLException {
        FeePayment payment = new FeePayment();
        payment.setPaymentId(rs.getInt("PaymentID"));
        payment.setStudentId(rs.getInt("StudentID"));
        payment.setStudentName(rs.getString("StudentName"));
        payment.setPaymentDate(rs.getDate("PaymentDate"));
        payment.setAmount(rs.getBigDecimal("Amount"));
        payment.setStatus(rs.getString("Status"));
        return payment;
    }
}