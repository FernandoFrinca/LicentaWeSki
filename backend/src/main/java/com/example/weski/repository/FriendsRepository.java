package com.example.weski.repository;

import com.example.weski.data.model.Friends;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface FriendsRepository extends JpaRepository<Friends, Long> {
    @Query("""
        SELECT 
            CASE 
                WHEN f.userId1 = :userId THEN f.userId2
                ELSE f.userId1 END AS friend_id,
                f.requestStatus
        FROM Friends f 
        WHERE :userId IN (f.userId1, f.userId2)
    """)
    List<Long> findFriendIds(@Param("userId") Long userId);
    @Query("""
        SELECT f.requestStatus
        FROM Friends f 
        WHERE :userId IN (f.userId1, f.userId2)
    """)
    List<Boolean> findFriendsStatus(@Param("userId") Long userId);
    Optional<Friends> findFriendsByUserId1AndUserId2(Long userId1, Long userId2);

}
