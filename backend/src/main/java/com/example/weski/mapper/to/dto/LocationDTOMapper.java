package com.example.weski.mapper.to.dto;

import com.example.weski.data.model.Locations;
import com.example.weski.dto.LocationDTO;
import org.locationtech.jts.geom.Point;
import org.springframework.stereotype.Component;

import java.util.function.Function;

@Component
public class LocationDTOMapper implements Function<Locations, LocationDTO> {
    @Override
    public LocationDTO apply(Locations locations) {
        if (locations == null) {
            return null;
        }
        LocationDTO locationDTO = new LocationDTO();
        locationDTO.setRecorded_time(locations.getRecordedTime());
        locationDTO.setUser_id(locations.getUserId());
        Point point;
        point = locations.getPoint();
        locationDTO.setLatitude(point.getY());
        locationDTO.setLongitude(point.getX());
        return locationDTO;
    }
}
