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

    public List<FriendDTO> getRequestsForUser(Long userId) {
        List<Users> requests = friendsRepository.findAllRequestsByUserIdAndSenderIsNotAndUserId(userId);
        List<FriendDTO> friendDTOs = new ArrayList<>();
        for (Users request : requests) {
            FriendDTO friendDTO = new FriendDTO();
            friendDTO.setId(request.getId());
            friendDTO.setUsername(request.getUsername());
            friendDTO.setCategory(request.getCategory());
            friendDTOs.add(friendDTO);
        }
        return friendDTOs;
    }


    public void respondRequestUser1AndUser2(boolean status, Long requestId, Long userId) {
        if(userId > requestId) {
            Long aux = requestId;
            requestId = userId;
            userId = aux;
        }
        if(status) {
            friendsRepository.updateRequestStatusForIds(userId,requestId, status);
        }else {
            friendsRepository.deleteByUserId1AndUserId2(userId,requestId);
        }
    }



    public void addFriendToUser(Long userId, String friend) {
        Users friendUser_obj = usersRepository.findByUsername(friend).orElseThrow(() -> new NotFoundException("Username not found"));
        Users currentUser_obj = usersRepository.findById(userId).orElseThrow(() -> new NotFoundException("User not found"));

        long friendId = friendUser_obj.getId();
        long currentUserId = currentUser_obj.getId();

        if (friendsRepository.existsById(new FriendsId(currentUserId, friendId))) {
            throw new NotFoundException("Already friends!");
        }

        Friends friends_obj = Friends.builder()
                .id(new FriendsId(currentUserId, friendId))
                .userId1(currentUser_obj)
                .userId2(friendUser_obj)
                .sender(userId)
                .build();
        friendsRepository.save(friends_obj);
    }

    public void removeFriendFromUser(Long userId, Long friendId) {
        if(userId > friendId) {
            Long aux = friendId;
            friendId = userId;
            userId = aux;
        }
        friendsRepository.deleteByUserId1AndUserId2(userId,friendId);
    }
}
