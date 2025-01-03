package model;

import java.sql.Timestamp;

public class OrderDTO {
   private int id;
   private String username;
   private String email;
   private double totalAmount;
   private String status;
   private Timestamp createdAt;

   public OrderDTO() {}

   public int getId() {
       return id;
   }

   public void setId(int id) {
       this.id = id;
   }

   public String getUsername() {
       return username;
   }

   public void setUsername(String username) {
       this.username = username;
   }

   public String getEmail() {
       return email;
   }

   public void setEmail(String email) {
       this.email = email;
   }

   public double getTotalAmount() {
       return totalAmount;
   }

   public void setTotalAmount(double totalAmount) {
       this.totalAmount = totalAmount;
   }

   public String getStatus() {
       return status;
   }

   public void setStatus(String status) {
       this.status = status;
   }

   public Timestamp getCreatedAt() {
       return createdAt;
   }

   public void setCreatedAt(Timestamp createdAt) {
       this.createdAt = createdAt;
   }
}