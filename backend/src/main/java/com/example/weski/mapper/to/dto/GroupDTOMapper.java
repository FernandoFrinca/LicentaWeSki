package com.example.weski.mapper.to.dto;

import com.example.weski.data.model.Group;
import com.example.weski.dto.GroupDTO;
import com.example.weski.dto.UsersDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.function.Function;
import java.util.stream.Collectors;

@Component
public class GroupDTOMapper implements Function<Group, GroupDTO> {
    @Autowired
    private UserDTOMapper usersDTOMapper;

    @Override
    public GroupDTO apply(Group group) {
        if (group == null)
            return null;
        GroupDTO groupDTO = new GroupDTO();
        groupDTO.setId(group.getId());
        groupDTO.setName(group.getName());
        groupDTO.setCreator_id(group.getCreator_id());
        List<UsersDTO> userDTOList = group.getGroupMembers().stream().map(usersDTOMapper).toList();
        groupDTO.setUsers(userDTOList);
        return groupDTO;
    }
}
