package com.example.weski.repository;

import com.example.weski.data.model.SkiResort;
import com.example.weski.data.model.SkiSlope;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface SkiResortRepository extends JpaRepository<SkiResort, Long> {

//    List<SkiSlope> findById(Long resortId);
}
