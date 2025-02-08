package com.example.weski.data.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.locationtech.jts.geom.Coordinate;
import org.locationtech.jts.geom.LineString;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "skislopes")
@Getter
@Setter
public class SkiSlope {
    @Id
    private Long id;

    @ManyToOne
    @JoinColumn(name = "resort_id")
    private SkiResort resort;

    private String name;
    private String difficulty;
    private Double length;
    private Double start_altitude;
    private Double end_altitude;
    @Column(columnDefinition = "geometry(LineString, 4326)")
    private LineString geom;
}
