package com.example.weski.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.weski.data.model.Locations;

import java.util.List;


public interface LocationRepository extends JpaRepository<Locations, Long> {

    List<Locations> findAllByUserId(Long userId);

    void deleteLocationsByUserId(Long userId);
    List<Locations> findAllByUserIdOrderByRecordedTime(Long userId);
}
