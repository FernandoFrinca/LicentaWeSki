package com.example.weski.mapper.to.dto;

import com.example.weski.data.model.Users;
import com.example.weski.dto.UsersDTO;
import org.springframework.stereotype.Component;

import java.util.function.Function;

@Component
public class UserDTOMapper implements Function<Users, UsersDTO> {
    @Override
    public UsersDTO apply(Users users) {
        UsersDTO usersDTO = new UsersDTO();
        usersDTO.setUsername(users.getUsername());
        usersDTO.setId(users.getId());
        usersDTO.setEmail(users.getEmail());
        usersDTO.setCategory(users.getCategory());
        usersDTO.setGender(users.getGender());
        usersDTO.setAge(users.getAge());
        return usersDTO;
    }
}
