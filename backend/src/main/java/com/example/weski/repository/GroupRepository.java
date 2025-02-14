package com.example.weski.repository;

import com.example.weski.data.model.Group;
import com.example.weski.data.model.Users;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Set;

@Repository
public interface GroupRepository extends JpaRepository<Group, Long> {

    @Query("""
            SELECT DISTINCT g 
            FROM Group g 
            JOIN FETCH g.groupMembers
            WHERE g.id IN (
                SELECT g2.id FROM Group g2
                JOIN g2.groupMembers u
                WHERE u = :user )
            """)
    List<Group> findGroupsByUser(@Param("user") Users user);

    @Modifying
    @Transactional
    @Query(value = "DELETE FROM group_user WHERE group_id = :groupId AND user_id = :userId", nativeQuery = true)
    void removeUserFromGroup(@Param("groupId") Long groupId, @Param("userId") Long userId);
}
