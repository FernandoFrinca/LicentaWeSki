package com.example.weski.service;


import com.example.weski.data.model.Group;
import com.example.weski.data.model.Notification;
import com.example.weski.data.model.SentNotification;
import com.example.weski.data.model.Users;
import com.example.weski.dto.NotificationDTO;
import com.example.weski.dto.SentNotificationDTO;
import com.example.weski.error.NotFoundException;
import com.example.weski.mapper.to.dto.NotificationDTOMapper;
import com.example.weski.mapper.to.entity.SentNotificationDTOMapper;
import com.example.weski.repository.GroupRepository;
import com.example.weski.repository.NotificationRepository;
import com.example.weski.repository.SentNotificationRepository;
import com.example.weski.repository.UsersRepository;
import org.springframework.data.jpa.repository.support.SimpleJpaRepository;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
public class NotificationService {

    private final NotificationRepository notificationRepository;
    private final SentNotificationRepository sentNotificationRepository;
    private final UsersRepository userRepository;

    private final GroupRepository groupRepository;
    private final NotificationDTOMapper notificationDTOMapper;
    private final SentNotificationDTOMapper  sentNotificationDTOMapper;

    public NotificationService(NotificationRepository notificationRepository,
                               SentNotificationRepository sentNotificationRepository,
                               UsersRepository userRepository, GroupRepository groupRepository,
                               NotificationDTOMapper notificationDTOMapper, SentNotificationDTOMapper sentNotificationDTOMapper) {
        this.notificationRepository = notificationRepository;
        this.sentNotificationRepository = sentNotificationRepository;
        this.userRepository = userRepository;
        this.groupRepository = groupRepository;
        this.notificationDTOMapper = notificationDTOMapper;
        this.sentNotificationDTOMapper = sentNotificationDTOMapper;
    }

    public List<NotificationDTO> getAllNotifications(){
        List<Notification> notificationList = notificationRepository.findAll();
        return notificationList.stream()
                .map(notificationDTOMapper)
                .toList();
    }

    public List<NotificationDTO> getNotificationsForUser(Long userId) {
        List<SentNotification> sentNotifications = sentNotificationRepository.findByReceiverId(userId);
        List<NotificationDTO> notificationDTOList = new ArrayList<>();

        for (SentNotification sentNotif : sentNotifications) {
            Notification notification = sentNotif.getNotification();
            NotificationDTO dto = notificationDTOMapper.apply(notification);

            dto.setSenderName(sentNotif.getSender().getUsername());
            dto.setGroupName(sentNotif.getGroup().getName());
            dto.setSentNotificationId(sentNotif.getId());

            notificationDTOList.add(dto);
        }

        return notificationDTOList;
    }



    public void sentNotification(Long groupId, Long senderId, Long receiverId, Long notificationId) {
        Group group = groupRepository.findById(groupId).orElseThrow(() -> new NotFoundException("Group not found"));
        Users sender = userRepository.findById(senderId).orElseThrow(() -> new NotFoundException("Sender not found"));
        Users receiver = userRepository.findById(receiverId).orElseThrow(() -> new NotFoundException("Receiver not found"));
        Notification notification = notificationRepository.findById(notificationId).orElseThrow(() -> new NotFoundException("Notification not found"));

        SentNotificationDTO sentNotificationDTO = new SentNotificationDTO(sender, receiver, notification, group);
        SentNotification sentNotification = sentNotificationDTOMapper.apply(sentNotificationDTO);
        sentNotificationRepository.save(sentNotification);
    }

    public void sentNotificationToGroup(Long groupId, Long senderId, Long notificationId) {
        Group group = groupRepository.findById(groupId).orElseThrow(() -> new NotFoundException("Group not found"));
        Users sender = userRepository.findById(senderId).orElseThrow(() -> new NotFoundException("Sender not found"));
        Notification notification = notificationRepository.findById(notificationId).orElseThrow(() -> new NotFoundException("Notification not found"));

        List<SentNotification> sentNotifications = new ArrayList<>();
        for (Users receiver : group.getGroupMembers()) {
            if (receiver.getId().equals(senderId)) {
                continue;
            }
            SentNotificationDTO sentNotificationDTO = new SentNotificationDTO(sender, receiver, notification, group);
            SentNotification sentNotification = sentNotificationDTOMapper.apply(sentNotificationDTO);
            sentNotifications.add(sentNotification);
        }
        sentNotificationRepository.saveAll(sentNotifications);
    }

    public void deleteNotifications(List<Long> notificationsIds) {
        sentNotificationRepository.deleteAllById(notificationsIds);
    }

}
