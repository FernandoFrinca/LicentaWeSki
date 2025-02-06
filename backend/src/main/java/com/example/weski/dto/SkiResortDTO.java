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
public class SkiResortDTO {
    private Long id;
    private String name;

    private Double latitude;
    private Double longitude;

    private List<SkiSlopeDTO> slopes;
}
