package com.example.weski.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class StatisticDTO {
    private Long user_id;
    private double max_speed;
    private double total_distance;
}
