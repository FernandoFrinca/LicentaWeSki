package com.example.weski.repository;

import com.example.weski.data.model.Statistics;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface StatisticsRepository  extends JpaRepository<Statistics,Long> {

}
