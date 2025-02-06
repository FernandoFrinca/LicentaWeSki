package com.example.weski.repository;

import com.example.weski.data.model.Users;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UsersRepository extends JpaRepository<Users, Long>{

    Users findByUsername(String username);
}
