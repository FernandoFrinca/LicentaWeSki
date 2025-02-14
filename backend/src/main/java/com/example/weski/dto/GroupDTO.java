package com.example.weski.dto;

import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
public class GroupDTO {
    private Long id;
    private String name;
    private List<UsersDTO> users;
    private Long creator_id;
}
