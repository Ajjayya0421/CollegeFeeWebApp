package com.model;

import java.math.BigDecimal;
import java.sql.Date;

public class FeePayment {
    private int paymentId;
    private int studentId;
    private String studentName;
    private Date paymentDate;
    private BigDecimal amount;
    private String status;
    
    // Default Constructor
    public FeePayment() {}
    
    // Parameterized Constructor with validation
    public FeePayment(int paymentId, int studentId, String studentName, 
                      Date paymentDate, BigDecimal amount, String status) {
        setPaymentId(paymentId);      // Uses validation in setter
        setStudentId(studentId);      // Uses validation in setter
        this.studentName = studentName;
        this.paymentDate = paymentDate;
        setAmount(amount);            // Uses validation in setter
        this.status = status;
    }
    
    // Getter and Setter for PaymentId (NO NEGATIVE VALUES)
    public int getPaymentId() {
        return paymentId;
    }
    
    public void setPaymentId(int paymentId) {
        if (paymentId < 0) {
            throw new IllegalArgumentException("Payment ID cannot be negative! Payment ID: " + paymentId);
        }
        this.paymentId = paymentId;
    }
    
    // Getter and Setter for StudentId (NO NEGATIVE VALUES)
    public int getStudentId() {
        return studentId;
    }
    
    public void setStudentId(int studentId) {
        if (studentId < 0) {
            throw new IllegalArgumentException("Student ID cannot be negative! Student ID: " + studentId);
        }
        this.studentId = studentId;
    }
    
    // Getter and Setter for StudentName
    public String getStudentName() {
        return studentName;
    }
    
    public void setStudentName(String studentName) {
        if (studentName == null || studentName.trim().isEmpty()) {
            throw new IllegalArgumentException("Student name cannot be null or empty!");
        }
        this.studentName = studentName;
    }
    
    // Getter and Setter for PaymentDate
    public Date getPaymentDate() {
        return paymentDate;
    }
    
    public void setPaymentDate(Date paymentDate) {
        if (paymentDate == null) {
            throw new IllegalArgumentException("Payment date cannot be null!");
        }
        this.paymentDate = paymentDate;
    }
    
    // Getter and Setter for Amount (NO NEGATIVE VALUES)
    public BigDecimal getAmount() {
        return amount;
    }
    
    public void setAmount(BigDecimal amount) {
        if (amount == null) {
            throw new IllegalArgumentException("Amount cannot be null!");
        }
        if (amount.compareTo(BigDecimal.ZERO) < 0) {
            throw new IllegalArgumentException("Amount cannot be negative! Amount: " + amount);
        }
        this.amount = amount;
    }
    
    // Getter and Setter for Status
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        if (status == null || status.trim().isEmpty()) {
            throw new IllegalArgumentException("Status cannot be null or empty!");
        }
        // Optional: Validate status is one of allowed values
        String allowedStatuses = "Paid,Pending,Overdue";
        if (!allowedStatuses.contains(status)) {
            throw new IllegalArgumentException("Status must be Paid, Pending, or Overdue! Got: " + status);
        }
        this.status = status;
    }
    
    // Helper method to check if payment is valid
    public boolean isValid() {
        return paymentId >= 0 && 
               studentId >= 0 && 
               studentName != null && !studentName.trim().isEmpty() &&
               paymentDate != null &&
               amount != null && amount.compareTo(BigDecimal.ZERO) >= 0 &&
               status != null && !status.trim().isEmpty();
    }
    
    @Override
    public String toString() {
        return "FeePayment{" +
               "paymentId=" + paymentId +
               ", studentId=" + studentId +
               ", studentName='" + studentName + '\'' +
               ", paymentDate=" + paymentDate +
               ", amount=" + amount +
               ", status='" + status + '\'' +
               '}';
    }
}