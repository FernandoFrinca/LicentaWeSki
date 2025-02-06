package com.example.weski.data.model;

import jakarta.persistence.*;

@Entity
@Table(name = "friends")
public class Friends {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "user_id_1")
    private Long userId1;

    @Column(name = "user_id_2")
    private Long userId2;

    @Column(name = "request_status", nullable = false)
    private boolean requestStatus = false;

    public Friends() {

    }

    public Friends(Long userId1, Long userId2, boolean requestStatus) {
        this.userId1 = userId1;
        this.userId2 = userId2;
        this.requestStatus = requestStatus;
    }
    public Long getUserId1() {
        return userId1;
    }

    public void setUserId1(Long userId1) {
        this.userId1 = userId1;
    }

    public Long getUserId2() {
        return userId2;
    }

    public void setUserId2(Long userId2) {
        this.userId2 = userId2;
    }

    public boolean isRequestStatus() {
        return requestStatus;
    }

    public void setRequestStatus(boolean requestStatus) {
        this.requestStatus = requestStatus;
    }
}
