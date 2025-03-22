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
    private Integer age;
    private Integer gender;
    private Long id;
    private String profile_picture;
}

