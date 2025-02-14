package com.example.weski.mapper.to.entity;

import com.example.weski.data.model.Group;
import com.example.weski.dto.GroupDTO;
import org.springframework.stereotype.Component;

import java.util.function.Function;

@Component
public class GroupDTOtoEntityMapper implements Function<GroupDTO,Group> {
    @Override
    public Group apply(GroupDTO groupDTO) {
        Group group = new Group();
        group.setId(null);
        group.setName(groupDTO.getName());
        group.setCreator_id(groupDTO.getCreator_id());
        return group;
    }
}
