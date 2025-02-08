package com.example.weski.repository;

import com.example.weski.data.model.Friends;
import com.example.weski.data.model.FriendsId;
import com.example.weski.data.model.Users;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface FriendsRepository extends JpaRepository<Friends, FriendsId> {
    @Query("""
        SELECT DISTINCT u
        FROM Users u
        WHERE u.id IN (
            SELECT f.userId2.id
            FROM Friends f
            WHERE f.requestStatus = true
              AND f.userId1.id = :userId
        )
        OR u.id IN (
            SELECT f.userId1.id
            FROM Friends f
            WHERE f.requestStatus = true
              AND f.userId2.id = :userId
        )
    """)
    List<Users> findAllFriendsByUserId(@Param("userId") Long userId);

}
