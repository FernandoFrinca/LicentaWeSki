package com.example.weski.mapper.to.dto;

import com.example.weski.data.model.Notification;
import com.example.weski.dto.NotificationDTO;
import org.springframework.stereotype.Component;

import java.util.function.Function;

@Component
public class NotificationDTOMapper implements Function<Notification, NotificationDTO> {
    @Override
    public NotificationDTO apply(Notification notification) {
        if (notification == null) {
            return null;
        }
        NotificationDTO notificationDTO = new NotificationDTO();
        notificationDTO.setId(notification.getId());
        notificationDTO.setContent(notification.getContent());
        return notificationDTO;
    }
}

