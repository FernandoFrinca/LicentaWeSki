package com.example.weski.dto;

import lombok.*;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@Data
public class LocationWebSocketDTO {
    private Double latitude;
    private Double longitude;
    private Long userId;
}
