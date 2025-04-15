package com.example.weski.service;

import com.example.weski.data.model.Group;
import com.example.weski.data.model.Users;
import com.example.weski.dto.GroupDTO;
import com.example.weski.error.NotFoundException;
import com.example.weski.mapper.to.dto.GroupDTOMapper;
import com.example.weski.repository.GroupRepository;
import com.example.weski.repository.UsersRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.Set;

@Service
public class GroupService {

    private final GroupRepository groupRepository;

    private final GroupDTOMapper groupDTOMapper;
    private final UsersRepository usersRepository;

    @Autowired
    public GroupService(GroupRepository groupRepository, GroupDTOMapper groupDTOMapper, UsersRepository usersRepository) {
        this.groupRepository = groupRepository;
        this.groupDTOMapper = groupDTOMapper;
        this.usersRepository = usersRepository;
    }

    public List<GroupDTO> getAllGroups(){
        List<Group> groupList = groupRepository.findAll();
        return   groupList.stream()
                .map(groupDTOMapper)
                .toList();
    }

    public List<GroupDTO> getGroupsWhereUserIsMember(Long memberId) {
        Users user = usersRepository.findById(memberId).get();
        List<Group> groupList = groupRepository.findGroupsByUser(user);
        return groupList.stream()
                .map(groupDTOMapper)
                .toList();
    }

    public Optional<Group> getGroupById(Long groupId) {
        return groupRepository.findById(groupId);
    }

    public Long createGroup(String groupName, Long creatorId) {
        Group group = Group.builder()
                .name(groupName)
                .creator_id(creatorId)
                .build();
        groupRepository.save(group);
        return  group.getId();
    }

    public void deleteGroup(Long groupId) {
        Group group = groupRepository.findById(groupId)
                .orElseThrow(() -> new NotFoundException("Group not found"));
        for (Users user : group.getGroupMembers()) {
            user.getGroupsAssigned().remove(group);
        }
        groupRepository.delete(group);
    }

    public void removeUserFromGroup(Long groupId, Long userId) {
        groupRepository.removeUserFromGroup(groupId, userId);
    }

    public void addUserToGroup(Long userId, Long groupId) {
        Users user = null;
        if (userId != null) {
            user = usersRepository.findById(userId)
                    .orElseThrow(() -> new NotFoundException("User not found"));

            Group group = groupRepository.findById(groupId)
                    .orElseThrow(() -> new NotFoundException("Group not found"));

            user.getGroupsAssigned().add(group);
            group.getGroupMembers().add(user);

            usersRepository.save(user);
            groupRepository.save(group);
        }
    }

    public void addUsersToGroup(Long groupId, Set<Long> usersIds) {

        if (usersIds == null || usersIds.isEmpty()) {
            throw new NotFoundException("No users provided");
        }
        Group group = groupRepository.findById(groupId)
                .orElseThrow(() -> new NotFoundException("Group not found"));

        Set<Long> existingUserIds = usersRepository.getAllUsersId();
        usersIds.retainAll(existingUserIds);

        if (usersIds.isEmpty()) {
            throw new NotFoundException("No valid users found");
        }

        List<Users> users = usersRepository.findAllById(usersIds);

        for (Users user : users) {
            user.getGroupsAssigned().add(group);
            group.getGroupMembers().add(user);
        }

        usersRepository.saveAll(users);
    }

    public void updateGroupPicture(Long groupId, String photoUrl){
        Group group = groupRepository.findGroupById(groupId);
        if(group == null) {
            throw new NotFoundException("Group not found");
        }
        group.setGroup_picture(photoUrl);
        groupRepository.save(group);
    }

}


