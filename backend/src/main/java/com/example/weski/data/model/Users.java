package com.example.weski.data.model;


import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

import java.util.HashSet;
import java.util.Set;

@Setter
@Getter
@Entity
@Table(name = "users")
public class Users {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String username;
    private String password;
    private String email;
    private String category;
    private int gender;
    private int age;

    @ManyToMany()
    @JoinTable( name = "group_user",
                joinColumns = @JoinColumn(name = "user_id"),
                inverseJoinColumns = @JoinColumn(name = "group_id") )
    @JsonIgnore
    private Set<Group> groupsAssigned = new HashSet<>();

/*    @ManyToMany
    @JoinTable(
            name = "notification_user",
            joinColumns = @JoinColumn(name = "user_id"),
            inverseJoinColumns = @JoinColumn(name = "notification_id")
    )
    @JsonIgnore
    private Set<Notification> notificationsReceived = new HashSet<>();*/
}
