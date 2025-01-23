package com.example.weski.dto;

import java.util.List;

public class SkiResortDTO {
    private Long id;
    private String name;

    private Double latitude;
    private Double longitude;

    private List<SkiSlopeDTO> slopes;

    public SkiResortDTO() {
    }

    public SkiResortDTO(Long id, String name, Double latitude, Double longitude) {
        this.id = id;
        this.name = name;
        this.latitude = latitude;
        this.longitude = longitude;
    }

    public List<SkiSlopeDTO> getSlopes() {
        return slopes;
    }

    public void setSlopes(List<SkiSlopeDTO> slopes) {
        this.slopes = slopes;
    }

    public Double getLongitude() {
        return longitude;
    }

    public void setLongitude(Double longitude) {
        this.longitude = longitude;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public Double getLatitude() {
        return latitude;
    }

    public void setLatitude(Double latitude) {
        this.latitude = latitude;
    }

    public void setName(String name) {
        this.name = name;
    }
}
