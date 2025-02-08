package com.example.weski.service;

import com.example.weski.data.model.Friends;
import com.example.weski.data.model.FriendsId;
import com.example.weski.data.model.Users;
import com.example.weski.dto.FriendDTO;
import com.example.weski.error.NotFoundException;
import com.example.weski.repository.FriendsRepository;
import com.example.weski.repository.UsersRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class FriendsService {

    private final FriendsRepository friendsRepository;
    private final UsersRepository usersRepository;


    @Autowired
    public FriendsService(FriendsRepository friendsRepository, UsersRepository usersRepository) {
        this.friendsRepository = friendsRepository;
        this.usersRepository = usersRepository;
    }

    public List<FriendDTO> getFriendsForUser(Long userId) {
        List<Users> friends = friendsRepository.findAllFriendsByUserId(userId);
        List<FriendDTO> friendDTOs = new ArrayList<>();
        for (Users friend : friends) {
            FriendDTO friendDTO = new FriendDTO();
            friendDTO.setId(friend.getId());
            friendDTO.setUsername(friend.getUsername());
            friendDTO.setCategory(friend.getCategory());
            friendDTOs.add(friendDTO);
        }
        return friendDTOs;
    }

    public void addFriendToUser(Long userId, String friend) {
        Users friendUser_obj = usersRepository.findByUsername(friend).orElseThrow(() -> new NotFoundException("Username not found"));
        Users currentUser_obj = usersRepository.findById(userId).orElseThrow(() -> new NotFoundException("User not found"));

        if (friendUser_obj != null && currentUser_obj != null) {
            long friendId = friendUser_obj.getId();
            long currentUserId = currentUser_obj.getId();

            Friends friends_obj = Friends.builder()
                    .id(new FriendsId(currentUserId, friendId))
                    .userId1(currentUser_obj)
                    .userId2(friendUser_obj)
                    .build();
            friendsRepository.save(friends_obj);
        }
    }
}
