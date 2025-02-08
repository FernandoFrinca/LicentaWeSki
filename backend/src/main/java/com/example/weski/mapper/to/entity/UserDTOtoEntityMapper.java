package com.example.weski.mapper.to.entity;

import com.example.weski.data.model.Users;
import com.example.weski.dto.UsersDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import java.util.function.Function;

@Component
public class UserDTOtoEntityMapper implements Function<UsersDTO, Users> {
    private final PasswordEncoder encoderPass;

    @Autowired
    public UserDTOtoEntityMapper(PasswordEncoder encoderPass) {
        this.encoderPass = encoderPass;
    }

    @Override
    public Users apply(UsersDTO usersDTO) {
        Users users = new Users();
        users.setId(null);
        users.setUsername(usersDTO.getUsername());
        users.setPassword(encoderPass.encode(usersDTO.getPassword()));
        users.setEmail(usersDTO.getEmail());
        users.setCategory(usersDTO.getCategory());
        return users;
    }

}
