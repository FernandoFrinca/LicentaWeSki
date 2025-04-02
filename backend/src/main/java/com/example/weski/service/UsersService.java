package com.example.weski.service;


import com.example.weski.data.model.Group;
import com.example.weski.data.model.Statistics;
import com.example.weski.data.model.Users;
import com.example.weski.dto.StatisticDTO;
import com.example.weski.dto.UsersDTO;
import com.example.weski.error.NotFoundException;
import com.example.weski.mapper.to.dto.UserDTOMapper;
import com.example.weski.mapper.to.entity.UserDTOtoEntityMapper;
import com.example.weski.repository.GroupRepository;
import com.example.weski.repository.StatisticsRepository;
import com.example.weski.repository.UsersRepository;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
public class UsersService {

    private final UsersRepository usersRepository;

    private final UserDTOMapper usersMapper;

    private final UserDTOtoEntityMapper usersEntityMapper;

    private final StatisticsRepository statisticsRepository;

    private final GroupRepository groupRepository;


    @Autowired
    private PasswordEncoder passEncoder;


    @Autowired
    public UsersService(UsersRepository usersRepository, UserDTOMapper usersMapper, UserDTOtoEntityMapper usersEntityMapper, StatisticsRepository statisticsRepository, GroupRepository groupRepository) {
        this.usersRepository = usersRepository;
        this.usersMapper = usersMapper;
        this.usersEntityMapper = usersEntityMapper;
        this.statisticsRepository = statisticsRepository;
        this.groupRepository = groupRepository;
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
            throw new NotFoundException("User not found");
        } else if (!passEncoder.matches(password, user.getPassword())) {
            throw new NotFoundException("Invalid credentials");
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

    public void updateeStatistic(Long userId, double maxSpeed, double totalDistance) {
        Users user = usersRepository.findById(userId).orElse(null);
        Statistics statistics = user.getStatistics();
        if (statistics == null) {
            statistics = new Statistics();
            statistics.setUser(user);
        }
        statistics.setMax_speed(maxSpeed);
        statistics.setTotal_distance(totalDistance);
        statisticsRepository.save(statistics);
    }

    public StatisticDTO getUserStatistics(Long userId){
        Users user = usersRepository.findById(userId).orElse(null);
        Statistics statistics = user.getStatistics();
        if(statistics == null) {
            throw new RuntimeException("");
        }
        return new StatisticDTO(userId,statistics.getMax_speed(),statistics.getTotal_distance());
    }

    public List<StatisticDTO> getGroupStatistics(Long groupId){
        Group group = groupRepository.findById(groupId)
                .orElseThrow(() -> new RuntimeException("Group not found"));
        List<StatisticDTO> groupMembersStatistics = new ArrayList<>();
        for (Users user : group.getGroupMembers()) {
            Statistics statistics = user.getStatistics();
            if (statistics == null) {
                groupMembersStatistics.add(new StatisticDTO(user.getId(), 0.0, 0.0));
            } else {
                groupMembersStatistics.add(new StatisticDTO(user.getId(), statistics.getMax_speed(), statistics.getTotal_distance()));
            }
        }
        return  groupMembersStatistics;
    }

    public void updateUserPhoto(Long userId, String url){
        Users user = usersRepository.findById(userId).orElse(null);
        if (user == null) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "User not found");
        }
        user.setProfile_picture(url);
        usersRepository.save(user);
    }

    public String getProfilePicture(Long userId) {
        Users user = usersRepository.findById(userId).orElse(null);
        if (user == null) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "User not found");
        }
        return user.getProfile_picture();
    }
}
