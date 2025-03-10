package com.example.weski.dto;

import lombok.*;
import org.locationtech.jts.geom.Point;

import java.sql.Timestamp;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@ToString
public class LocationDTO {
    private Long user_id;
    private double latitude;
    private double longitude;
    private Timestamp recorded_time;
}
