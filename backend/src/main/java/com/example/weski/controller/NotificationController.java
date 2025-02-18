package com.example.weski.controller;

import com.example.weski.data.model.Notification;
import com.example.weski.dto.NotificationDTO;
import com.example.weski.repository.NotificationRepository;
import com.example.weski.service.NotificationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.Set;

@RestController
@RequestMapping("/api/notifications")
public class NotificationController {
    @Autowired
    private NotificationService notificationService;

    @GetMapping("/getAll")
    public List<NotificationDTO> getAllNotifications(){
        return notificationService.getAllNotifications();
    }

    @GetMapping("/user/{userId}")
    public List<NotificationDTO> getUserNotifications(@PathVariable Long userId) {
        return notificationService.getNotificationsForUser(userId);
    }

    @PostMapping("/sentNotification")
    public ResponseEntity<?> sentNotification(@RequestBody Map<String, Long> sentNotif) {
        Long groupId = sentNotif.get("groupId");
        Long senderId = sentNotif.get("senderId");
        Long receiverId = sentNotif.get("receiverId");
        Long notificationId = sentNotif.get("notificationId");

        notificationService.sentNotification(groupId, senderId, receiverId, notificationId);
        return ResponseEntity.ok("Notificare trimisa!");
    }

    @PostMapping("/sentNotification/group")
    public ResponseEntity<?> sentNotificationToGroup(@RequestBody Map<String, Long> sentNotif) {
        Long groupId = sentNotif.get("groupId");
        Long senderId = sentNotif.get("senderId");
        Long notificationId = sentNotif.get("notificationId");
        notificationService.sentNotificationToGroup(groupId, senderId, notificationId);
        return ResponseEntity.ok("Notificare grup!");
    }

    @DeleteMapping("/deleteNotifications")
    public ResponseEntity<?> deleteNotifications(@RequestBody List<Long> notificationsIds) {
        notificationService.deleteNotifications(notificationsIds);
        return ResponseEntity.ok("Notificari eliminate");
    }



}
