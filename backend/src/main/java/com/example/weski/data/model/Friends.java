package com.example.weski.data.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
@Table(name = "friends")
public class Friends {
    @EmbeddedId
    private FriendsId id;

    @ManyToOne
    @MapsId("userId1")
    @JoinColumn(name = "user_id_1")
    private Users userId1;

    @ManyToOne
    @MapsId("userId2")
    @JoinColumn(name = "user_id_2")
    private Users userId2;

    @Column(name = "request_status", nullable = false)
    private boolean requestStatus = false;

    @Column(name = "sender", nullable = false)
    private Long sender;

}
