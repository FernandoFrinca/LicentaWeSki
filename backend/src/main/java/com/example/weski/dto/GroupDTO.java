package com.example.weski.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
public class GroupDTO {
    private Long id;
    private String name;
    private List<UsersDTO> users;
    private Long creator_id;
    private String group_picture;
}
