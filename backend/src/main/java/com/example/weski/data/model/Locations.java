package com.example.weski.data.model;

import lombok.*;
import org.locationtech.jts.geom.Point;
import jakarta.persistence.*;


import java.sql.Timestamp;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@ToString
@Entity
@Table(name = "locations")
public class Locations {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "user_id")
    private Long userId;

    @Column(columnDefinition = "geometry(Point, 4326)")
    private Point point;

    @Column(name = "recorded_time", insertable = false, updatable = false)
    private Timestamp recordedTime;
}
