package com.example.weski.dto;

import java.util.List;

public class SkiSlopeDTO {
    private Long id;
    private Long resort_id;
    private String name;
    private String difficulty;
    private Double length;
    private Double start_altitude;
    private Double end_altitude;
    private List<List<Double>> geom;
    public SkiSlopeDTO() {
    }

    public SkiSlopeDTO(Long id, Long resort_id, String name, String difficulty, Double length, Double start_altitude, Double end_altitude, List<List<Double>> geom) {
        this.id = id;
        this.resort_id = resort_id;
        this.name = name;
        this.difficulty = difficulty;
        this.length = length;
        this.start_altitude = start_altitude;
        this.end_altitude = end_altitude;
        this.geom = geom;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getResort_id() {
        return resort_id;
    }

    public void setResort_id(Long resort_id) {
        this.resort_id = resort_id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDificulty() {
        return difficulty;
    }

    public void setDificulty(String difficulty) {
        this.difficulty = difficulty;
    }

    public Double getLength() {
        return length;
    }

    public void setLength(Double length) {
        this.length = length;
    }

    public Double getStart_altitude() {
        return start_altitude;
    }

    public void setStart_altitude(Double start_altitude) {
        this.start_altitude = start_altitude;
    }

    public Double getEnd_altitude() {
        return end_altitude;
    }

    public void setEnd_altitude(Double end_altitude) {
        this.end_altitude = end_altitude;
    }

    public List<List<Double>> getGeom() {
        return geom;
    }

    public void setGeom(List<List<Double>> geom) {
        this.geom = geom;
    }


}
