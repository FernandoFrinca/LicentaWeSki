package com.example.weski.mapper.to.entity;

import com.example.weski.data.model.SentNotification;
import com.example.weski.dto.SentNotificationDTO;
import org.springframework.stereotype.Component;

import java.util.function.Function;

@Component
public class SentNotificationDTOMapper implements Function<SentNotificationDTO, SentNotification> {
    @Override
    public SentNotification apply(SentNotificationDTO sentNotificationDTO) {
        SentNotification sentNotification = new SentNotification();
        sentNotification.setSender(sentNotificationDTO.getSender());
        sentNotification.setReceiver(sentNotificationDTO.getReceiver());
        sentNotification.setNotification(sentNotificationDTO.getNotification());
        sentNotification.setGroup(sentNotificationDTO.getGroup());
        return sentNotification;
    }

}
