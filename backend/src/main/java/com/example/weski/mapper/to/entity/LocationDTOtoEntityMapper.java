package com.example.weski.mapper.to.entity;

import com.example.weski.data.model.Locations;
import com.example.weski.dto.LocationDTO;
import org.locationtech.jts.geom.Coordinate;
import org.locationtech.jts.geom.GeometryFactory;
import org.locationtech.jts.geom.Point;
import org.springframework.stereotype.Component;

import java.util.function.Function;

@Component
public class LocationDTOtoEntityMapper implements Function<LocationDTO, Locations> {
    private final GeometryFactory geometryFactory = new GeometryFactory();
     @Override
    public Locations apply(LocationDTO locationDTO) {
        Locations location = new Locations();
        location.setId(null);
        location.setUserId(locationDTO.getUser_id());
        Point point = geometryFactory.createPoint(new Coordinate(locationDTO.getLongitude(), locationDTO.getLatitude()));
        location.setPoint(point);
        return location;
    }
}
