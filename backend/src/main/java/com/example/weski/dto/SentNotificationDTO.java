package com.example.weski.dto;

import com.example.weski.data.model.Group;
import com.example.weski.data.model.Notification;
import com.example.weski.data.model.Users;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
public class SentNotificationDTO {
    private Users sender;
    private Users receiver;
    private Notification notification;
    private Group group;
}
