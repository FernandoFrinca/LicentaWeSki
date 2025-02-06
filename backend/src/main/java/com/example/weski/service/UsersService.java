package com.example.weski.service;


import com.example.weski.data.model.Friends;
import com.example.weski.data.model.Users;
import com.example.weski.dto.UsersDTO;
import com.example.weski.mapper.to.UserDTOMapper;
import com.example.weski.repository.FriendsRepository;
import com.example.weski.repository.UsersRepository;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class UsersService {

    private final UsersRepository usersRepository;

    private final UserDTOMapper usersMapper;

    private final FriendsRepository friendsRepository;

    @Autowired
    private PasswordEncoder passEncoder;


    @Autowired
    public UsersService(UsersRepository usersRepository, UserDTOMapper usersMapper, FriendsRepository friendsRepository) {
        this.usersRepository = usersRepository;
        this.usersMapper = usersMapper;
        this.friendsRepository = friendsRepository;
    }


    public List<UsersDTO> getAllUsers() {
        List<Users> usersList = usersRepository.findAll();
        return usersList.stream().map(usersMapper).toList();
    }

    @Transactional
    public UsersDTO createUser(UsersDTO dto) {
        Users user = usersMapper.DTOtoEntity(dto);
        Users savedUser = usersRepository.save(user);
        return usersMapper.apply(savedUser);
    }

    public UsersDTO userLogin(String username, String password) {
        Users user = usersRepository.findByUsername(username);

        if (user == null) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "User not found");
        } else if (!passEncoder.matches(password, user.getPassword())) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Invalid credentials");
        }

        return usersMapper.apply(user);
    }

    public void addFriend(String friendUsername, Long currentId) {
        Users user = usersRepository.findByUsername(friendUsername);

        if (user == null) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "User not found");
        }
        if(currentId.equals(user.getId())) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "User can not add himself as friend");
        }

        if (friendsRepository.findFriendsByUserId1AndUserId2(currentId, user.getId()).isPresent() ||
                friendsRepository.findFriendsByUserId1AndUserId2(user.getId(), currentId).isPresent()) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Friends already exist or sent req");
        }
        friendsRepository.save(new Friends(currentId, user.getId(), false));
    }

    public List<Map<String, Object>> getFriendIds(Long userId) {
        List<Long> friendIds = friendsRepository.findFriendIds(userId);
        List<Boolean> status = friendsRepository.findFriendsStatus(userId);
        List<Map<String, Object>> friends = new ArrayList<>();

        for (int i = 0; i < friendIds.size(); i++) {
            String name = usersRepository.findById(friendIds.get(i)).get().getUsername();
            Map<String, Object> friendData = new HashMap<>();
            friendData.put("friend_Name", name);
            friendData.put("request_status", status.get(i));
            friends.add(friendData);
        }
        return friends;
    }
}
