package com.example.weski.controller;

import com.example.weski.data.model.Users;
import com.example.weski.dto.FriendDTO;
import com.example.weski.dto.StatisticDTO;
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
    private final FriendsService friendsService;


    public UsersController(UsersService usersService, FriendsService friendsService) {
        this.usersService = usersService;
        this.friendsService = friendsService;
    }

    @GetMapping("/getAll")
    public List<UsersDTO> getAllUsers() {
        return usersService.getAllUsers();
    }

    @GetMapping("/{userId}/friends")
    public List<FriendDTO> getFriends(@PathVariable Long userId) {
        return friendsService.getFriendsForUser(userId);
    }

    @GetMapping("/{userId}/requests")
    public List<FriendDTO> getRequests(@PathVariable Long userId) {
        return friendsService.getRequestsForUser(userId);
    }

    @GetMapping("/getStatistics/{userId}")
    public StatisticDTO getStatistics(@PathVariable Long userId) {
        return usersService.getUserStatistics(userId);
    }

    @GetMapping("/getGroupStatistics/{groupId}")
    public List<StatisticDTO> getGroupStatistics(@PathVariable("groupId") Long groupId) {
        return usersService.getGroupStatistics(groupId);
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

    @PostMapping("{id}/updateStatistics/{total_distance}/{max_speed}")
    public ResponseEntity<?> updateStatistics(@PathVariable("id") Long currentUserId, @PathVariable("total_distance") double totalDistance, @PathVariable("max_speed") double maxSpeed) {
        usersService.updateeStatistic(currentUserId, totalDistance, maxSpeed);
        return ResponseEntity.ok("Statistici actualizate");
    }


    @PutMapping("{idUser1}/requestResponse/{idUser2}/{status}")
    public ResponseEntity<?> requestResponse(@PathVariable("idUser1") Long idUser1, @PathVariable("idUser2") Long idUser2,@PathVariable ("status") boolean status) {
        friendsService.respondRequestUser1AndUser2(status,idUser1,idUser2);
        return ResponseEntity.ok("Cerere Raspunsa");
    }

    @DeleteMapping("{idUser}/deleteFriend/{idFriend}")
    public ResponseEntity<?> deleteFriend(@PathVariable("idUser") Long idUser,@PathVariable("idFriend") Long idFriend) {
        friendsService.removeFriendFromUser(idUser,idFriend);
        return ResponseEntity.ok("Prienten Sters");
    }

    @PatchMapping("{idUser}/resetPassword/{password}/{verifyPassword}")
    public void resetPassword(@PathVariable("idUser") Long idUser, @PathVariable("password") String password, @PathVariable("verifyPassword") String verifyPassword) {
        usersService.resetPassword(idUser,password,verifyPassword);
    }

    @PatchMapping("{idUser}/updateData")
    public  void updateData(@PathVariable("idUser") Long idUser, @RequestBody UsersDTO usersDTO) {
        usersService.updateUser(idUser,usersDTO);
    }

    @PatchMapping("{idUser}/updatePhoto")
    public void updatePhoto(@PathVariable("idUser") Long idUser, @RequestBody Map<String, String> request) {
        String url = request.get("url");
        usersService.updateUserPhoto(idUser, url);
    }

    @GetMapping("{idUser}/getProfilePhoto")
    public String getProfilePhoto(@PathVariable("idUser") Long idUser) {
        return usersService.getProfilePicture(idUser);
    }
}
