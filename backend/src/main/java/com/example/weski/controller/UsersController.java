package com.example.weski.controller;

import com.example.weski.dto.UsersDTO;
import com.example.weski.service.UsersService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/users")
public class UsersController {
    @Autowired
    private final UsersService usersService;


    public UsersController(UsersService usersService) {
        this.usersService = usersService;
    }

    @GetMapping("/getAll")
    public List<UsersDTO> getAllUsers(){
        return usersService.getAllUsers();
    }

    @PostMapping("/post")
    public ResponseEntity<UsersDTO> createUser(@RequestBody UsersDTO usersDTO) {
        UsersDTO savedUser = usersService.createUser(usersDTO);
        return ResponseEntity.ok(savedUser);
    }

    @PostMapping("/login")
    public UsersDTO login(@RequestBody Map<String, String> requestBody) {
        return usersService.userLogin(requestBody.get("username"), requestBody.get("password"));
    }

    @PostMapping("/addFriend")
    public ResponseEntity<String> addFriend(@RequestBody Map<String, String> requestBody) {
        Long currentUserId = Long.parseLong(requestBody.get("currentUserId"));
        String friendUsername = requestBody.get("friendUsername");

        usersService.addFriend(friendUsername, currentUserId);
        return ResponseEntity.ok("Friend request sent successfully.");
    }

    @PostMapping("/friends")
    public ResponseEntity<List<Map<String, Object>>> getFriendIds(@RequestBody Map<String, Long> requestBody) {
        Long userId = requestBody.get("userId");
        if (userId == null) {
            return ResponseEntity.badRequest().build();
        }

        List<Map<String, Object>> friendIds = usersService.getFriendIds(userId);
        return ResponseEntity.ok(friendIds);
    }

}
