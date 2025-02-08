package com.example.weski.data.model;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.util.Objects;

@Embeddable
public class FriendsId implements Serializable {

    @Column(name = "user_id_1")
    private Long userId1;
    @Column(name = "user_id_2")
    private Long userId2;

    public FriendsId() {
    }

    public FriendsId(Long userId1, Long userId2) {
        if (userId1 < userId2) {
            this.userId1 = userId1;
            this.userId2 = userId2;
        } else {
            this.userId1 = userId2;
            this.userId2 = userId1;
        }
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        FriendsId friendsId = (FriendsId) o;
        return Objects.equals(userId1, friendsId.userId1) &&
                Objects.equals(userId2, friendsId.userId2);
    }

    @Override
    public int hashCode() {
        return Objects.hash(Math.min(userId1, userId2), Math.max(userId1, userId2));
    }
}
