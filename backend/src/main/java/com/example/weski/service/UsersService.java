package com.example.weski.service;


import com.example.weski.data.model.Users;
import com.example.weski.dto.UsersDTO;
import com.example.weski.mapper.to.dto.UserDTOMapper;
import com.example.weski.mapper.to.entity.UserDTOtoEntityMapper;
import com.example.weski.repository.UsersRepository;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@Service
public class UsersService {

    private final UsersRepository usersRepository;

    private final UserDTOMapper usersMapper;

    private final UserDTOtoEntityMapper usersEntityMapper;


    @Autowired
    private PasswordEncoder passEncoder;


    @Autowired
    public UsersService(UsersRepository usersRepository, UserDTOMapper usersMapper, UserDTOtoEntityMapper usersEntityMapper) {
        this.usersRepository = usersRepository;
        this.usersMapper = usersMapper;
        this.usersEntityMapper = usersEntityMapper;
    }


    public List<UsersDTO> getAllUsers() {
        List<Users> usersList = usersRepository.findAll();
        return usersList.stream().map(usersMapper).toList();
    }

    @Transactional
    public UsersDTO createUser(UsersDTO dto) {
        Users user = usersEntityMapper.apply(dto);
        Users savedUser = usersRepository.save(user);
        return usersMapper.apply(savedUser);
    }

    public UsersDTO userLogin(String username, String password) {
        Users user = usersRepository.findByUsername(username).orElse(null);

        if (user == null) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "User not found");
        } else if (!passEncoder.matches(password, user.getPassword())) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Invalid credentials");
        }

        return usersMapper.apply(user);
    }

    public void resetPassword(Long userId, String newPassword ,String confirmPassword) {
        if (newPassword.equals(confirmPassword)) {
            Users user = usersRepository.findById(userId).orElse(null);
            if (user == null) {
                throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "User not found");
            }
            user.setPassword(passEncoder.encode(newPassword));
            usersRepository.save(user);
        }
    }

    public void updateUser(Long userId, UsersDTO dto) {
        Users user = usersRepository.findById(userId).orElse(null);
        if (user == null) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "User not found");
        }

        if (dto.getUsername() != null) {
            user.setUsername(dto.getUsername());
        }
        if (dto.getEmail() != null) {
            user.setEmail(dto.getEmail());
        }
        if (dto.getCategory() != null) {
            user.setCategory(dto.getCategory());
        }
        if (dto.getAge() != null) {
            user.setAge(dto.getAge());
        }
        if (dto.getGender() != null) {
            user.setGender(dto.getGender());
        }

        usersRepository.save(user);
    }
}
