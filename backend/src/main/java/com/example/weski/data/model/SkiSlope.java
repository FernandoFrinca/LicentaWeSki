package com.example.weski.data.model;

import jakarta.persistence.*;
import org.locationtech.jts.geom.Coordinate;
import org.locationtech.jts.geom.LineString;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "skislopes")
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
    public LineString getGeom() {
        return geom;
    }

    public void setGeom(LineString geom) {
        this.geom = geom;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setDificulty(String difficulty) {
        this.difficulty = difficulty;
    }

    public void setLength(Double length) {
        this.length = length;
    }

    public void setStart_altitude(Double start_altitude) {
        this.start_altitude = start_altitude;
    }

    public void setEnd_altitude(Double end_altitude) {
        this.end_altitude = end_altitude;
    }

    public String getName() {
        return name;
    }

    public String getDificulty() {
        return difficulty;
    }

    public Double getLength() {
        return length;
    }

    public Double getStart_altitude() {
        return start_altitude;
    }

    public Double getEnd_altitude() {
        return end_altitude;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getId() {
        return id;
    }
}
