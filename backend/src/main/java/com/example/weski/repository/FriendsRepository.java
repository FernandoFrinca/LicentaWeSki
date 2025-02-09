package com.example.weski.repository;

import com.example.weski.data.model.Friends;
import com.example.weski.data.model.FriendsId;
import com.example.weski.data.model.Users;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

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

    @Query("""
        SELECT DISTINCT u
        FROM Users u
        WHERE u.id IN (
            SELECT f.userId2.id
            FROM Friends f
            WHERE f.requestStatus = false
              AND f.userId1.id = :userId
              AND f.sender <> :userId
        )
        OR u.id IN (
            SELECT f.userId1.id
            FROM Friends f
            WHERE f.requestStatus = false
              AND f.userId2.id = :userId
              AND f.sender <> :userId
        )
    """)
    List<Users> findAllRequestsByUserIdAndSenderIsNotAndUserId(@Param("userId") Long userId);

    @Modifying
    @Transactional
    @Query("DELETE FROM Friends f WHERE f.id.userId1 = :userId1 AND f.id.userId2 = :userId2")
    void deleteByUserId1AndUserId2(@Param("userId1") Long userId1, @Param("userId2") Long userId2);
    @Modifying
    @Transactional
    @Query("""
        UPDATE Friends f 
        SET f.requestStatus = :status 
        WHERE f.id.userId1 = :userId1
          AND f.id.userId2 = :userId2
    """)
    void updateRequestStatusForIds(@Param("userId1") Long userId1,
                                   @Param("userId2") Long userId2,
                                   @Param("status") boolean status);

}
