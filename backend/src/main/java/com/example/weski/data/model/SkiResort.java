package com.example.weski.data.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.util.HashSet;
import java.util.Set;

@Getter
@Setter
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
}
