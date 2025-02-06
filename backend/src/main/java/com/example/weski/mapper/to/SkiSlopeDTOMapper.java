package com.example.weski.mapper.to;

import com.example.weski.data.model.SkiResort;
import com.example.weski.data.model.SkiSlope;
import com.example.weski.dto.SkiResortDTO;
import com.example.weski.dto.SkiSlopeDTO;
import org.locationtech.jts.geom.Coordinate;
import org.springframework.stereotype.Component;
import org.locationtech.jts.geom.LineString;

import java.util.ArrayList;
import java.util.List;
import java.util.function.Function;

@Component
public class SkiSlopeDTOMapper implements Function<SkiSlope, SkiSlopeDTO> {

    @Override
    public SkiSlopeDTO apply(SkiSlope skiSlope) {
        SkiSlopeDTO skiSlopeDTO = new SkiSlopeDTO();
        skiSlopeDTO.setId(skiSlope.getId());
        skiSlopeDTO.setName(skiSlope.getName());
        skiSlopeDTO.setDifficulty(skiSlope.getDificulty());
        skiSlopeDTO.setEnd_altitude(skiSlope.getEnd_altitude());
        skiSlopeDTO.setStart_altitude(skiSlope.getStart_altitude());
        skiSlopeDTO.setLength(skiSlope.getLength());
        skiSlopeDTO.setGeom(lineStringToCoord(skiSlope.getGeom()));

        return skiSlopeDTO;
    }

    private List<List<Double>> lineStringToCoord(LineString lineString) {
        List<List<Double>> coordinatesList = new ArrayList<>();
        for (Coordinate coord : lineString.getCoordinates()) {
            List<Double> point = new ArrayList<>();
            point.add(coord.x);
            point.add(coord.y);
            coordinatesList.add(point);
        }
        return coordinatesList;
    }
}
