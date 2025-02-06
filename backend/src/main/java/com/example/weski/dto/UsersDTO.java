package com.example.weski.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class UsersDTO {

    private String username;
    private String password;
    private String email;

    private String category;

    private Long id;

}
