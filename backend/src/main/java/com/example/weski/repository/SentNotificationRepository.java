package com.example.weski.repository;

import com.example.weski.data.model.SentNotification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface SentNotificationRepository extends JpaRepository<SentNotification, Long> {
    List<SentNotification> findByReceiverId(Long receiverId);
}
