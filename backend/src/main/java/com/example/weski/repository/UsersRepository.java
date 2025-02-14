package com.example.weski.repository;

import com.example.weski.data.model.Users;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.Set;

@Repository
public interface UsersRepository extends JpaRepository<Users, Long>{

    Optional<Users> findByUsername(String username);

    @Query("""
    SELECT u.id FROM Users u
    """)
    Set<Long> getAllUsersId();
}
