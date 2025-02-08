package com.example.weski.controller;

import com.example.weski.data.model.Users;
import com.example.weski.dto.FriendDTO;
import com.example.weski.dto.UsersDTO;
import com.example.weski.service.FriendsService;
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

    @Autowired
    private  final FriendsService friendsService;



    public UsersController(UsersService usersService, FriendsService friendsService) {
        this.usersService = usersService;
        this.friendsService = friendsService;
    }

    @GetMapping("/getAll")
    public List<UsersDTO> getAllUsers(){
        return usersService.getAllUsers();
    }

    @GetMapping("/{userId}/friends")
    public List<FriendDTO> getFriends(@PathVariable Long userId) {
        return friendsService.getFriendsForUser(userId);
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

    @PostMapping("{id}/requestFriend/{username}")
    public ResponseEntity<?> addFriend(@PathVariable("id") Long currentUserId, @PathVariable("username") String friendUsername) {
        friendsService.addFriendToUser(currentUserId, friendUsername);
        return ResponseEntity.ok("Prieten adăugat cu succes!");
    }

}
