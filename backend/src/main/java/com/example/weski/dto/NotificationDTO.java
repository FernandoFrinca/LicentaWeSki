package com.example.weski.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
public class NotificationDTO {
    private Long id;
    private Long sentNotificationId;
    private String content;
    private String senderName;
    private String groupName;

}
