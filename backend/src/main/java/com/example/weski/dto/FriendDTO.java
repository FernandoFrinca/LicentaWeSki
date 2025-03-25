package com.example.weski.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
public class FriendDTO {
    Long id;
    String username;
    String category;
    String profile_picture;
}
