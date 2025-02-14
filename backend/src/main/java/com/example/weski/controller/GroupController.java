package com.example.weski.controller;

import com.example.weski.data.model.Group;
import com.example.weski.dto.GroupDTO;
import com.example.weski.service.GroupService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;
import java.util.Set;

@RestController
@RequestMapping("/api/group")
public class GroupController {

    @Autowired
    private final GroupService groupService;

    public GroupController(GroupService groupService) {
        this.groupService = groupService;
    }

    @GetMapping("/getAll")
    public List<GroupDTO> getAllSkiResorts() {
        return groupService.getAllGroups();
    }

    @GetMapping("/getUserGroups/{userId}")
    public List<GroupDTO> getUserGroups(@PathVariable Long userId) {
        return groupService.getGroupsWhereUserIsMember(userId);
        //return null;
    }

    @GetMapping("/getGroupById/{id}")
    public Optional<Group> getGroupById(@PathVariable Long id) {
        return  groupService.getGroupById(id);
    }

    @PostMapping("/createGroup/{groupName}/by/{userId}")
    public Long createGroup(@PathVariable String groupName, @PathVariable Long userId) {
        return groupService.createGroup(groupName, userId);
    }

    @PostMapping("/addUser/{userId}/to/{groupId}")
    public ResponseEntity<?> addUserToGroup(@PathVariable Long userId, @PathVariable Long groupId) {
        groupService.addUserToGroup(userId, groupId);
        return  ResponseEntity.ok("User added to group");
    }

    @PostMapping("/{groupId}/AddUsers")
    public ResponseEntity<String> addUsersToGroup(@PathVariable("groupId") Long groupId, @RequestBody Set<Long> usersIds) {
        groupService.addUsersToGroup(groupId, usersIds);
        return ResponseEntity.ok("Users added");
    }

    @DeleteMapping("/deleteGroup/{groupId}")
    public ResponseEntity<?> deleteGroup(@PathVariable Long groupId) {
        groupService.deleteGroup(groupId);
        return  ResponseEntity.ok("Grup deleted");
    }

    @DeleteMapping("/from/{groupId}/delete/{userId}")
    public ResponseEntity<?> deleteGroup(@PathVariable Long groupId, @PathVariable Long userId) {
        groupService.removeUserFromGroup(groupId, userId);
        return  ResponseEntity.ok("User removed from group");
    }
}
