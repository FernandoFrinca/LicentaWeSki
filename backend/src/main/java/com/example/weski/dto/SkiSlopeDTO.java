package com.example.weski.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
public class SkiSlopeDTO {
    private Long id;
    private Long resort_id;
    private String name;
    private String difficulty;
    private Double length;
    private Double start_altitude;
    private Double end_altitude;
    private List<List<Double>> geom;

}
