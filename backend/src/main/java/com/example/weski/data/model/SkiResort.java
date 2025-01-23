package com.example.weski.data.model;

import jakarta.persistence.*;

import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "ski_resorts")
public class SkiResort {
    @Id
    private Long id;
    private String name;

    private Double latitude;
    private Double longitude;

    @OneToMany(mappedBy = "resort", fetch = FetchType.EAGER, cascade = CascadeType.ALL)
    private Set<SkiSlope> slopes = new HashSet<>();

    public Double getLatitude() {
        return latitude;
    }

    public Set<SkiSlope> getSlopes() {
        return slopes;
    }

    public void setLatitude(Double latitude) {
        this.latitude = latitude;
    }

    public Double getLongitude() {
        return longitude;
    }

    public void setLongitude(Double longitude) {
        this.longitude = longitude;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getId() {
        return id;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }
}
