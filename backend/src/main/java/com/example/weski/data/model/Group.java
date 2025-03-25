package com.example.weski.data.model;

import jakarta.persistence.*;
import lombok.*;

import java.util.HashSet;
import java.util.Set;

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
@Table(name = "friendgroups")
public class Group {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(name = "name")
    private String name;
    @Column (name = "creator_id")
    private Long creator_id;
    @Column(name = "group_picture")
    @Builder.Default
    private String group_picture = "empty";

    @ManyToMany(mappedBy = "groupsAssigned")
    private Set<Users> groupMembers = new HashSet<>();
}
