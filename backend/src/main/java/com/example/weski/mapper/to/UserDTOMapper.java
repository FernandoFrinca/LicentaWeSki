package com.example.weski.mapper.to;

import com.example.weski.data.model.Users;
import com.example.weski.dto.UsersDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import java.util.function.Function;

@Component
public class UserDTOMapper implements Function<Users, UsersDTO> {

    private final PasswordEncoder encoderPass;


    @Autowired
    public UserDTOMapper(PasswordEncoder encoderPass) {
        this.encoderPass = encoderPass;
    }

    @Override
    public UsersDTO apply(Users users) {
        UsersDTO usersDTO = new UsersDTO();
        usersDTO.setUsername(users.getUsername());
        usersDTO.setId(users.getId());
        usersDTO.setEmail(users.getEmail());
        usersDTO.setCategory(users.getCategory());
        return usersDTO;
    }

    public Users DTOtoEntity(UsersDTO usersDTO) {
        Users users = new Users();
        users.setId(null);
        users.setUsername(usersDTO.getUsername());
        users.setPassword(encoderPass.encode(usersDTO.getPassword()));
        users.setEmail(usersDTO.getEmail());
        users.setCategory(usersDTO.getCategory());
        return users;
    }

}
