package com.example.weski.mapper.to;

import com.example.weski.data.model.SkiResort;
import com.example.weski.dto.SkiResortDTO;
import com.example.weski.dto.SkiSlopeDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.function.Function;

@Component
public class SkiResortDTOMapper implements Function<SkiResort, SkiResortDTO> {
    private final SkiSlopeDTOMapper skiSlopeDTOMapper;

    @Autowired
    public SkiResortDTOMapper(SkiSlopeDTOMapper skiSlopeDTOMapper) {
        this.skiSlopeDTOMapper = skiSlopeDTOMapper;
    }

    @Override
    public SkiResortDTO apply(SkiResort skiResort) {
        if (skiResort == null)
            return null;
        SkiResortDTO skiResortDTO = new SkiResortDTO();
        skiResortDTO.setId(skiResort.getId());
        skiResortDTO.setName(skiResort.getName());
        skiResortDTO.setLatitude(skiResort.getLatitude());
        skiResortDTO.setLongitude(skiResort.getLongitude());
        List<SkiSlopeDTO> skiSlopeDTOS = skiResort.getSlopes().stream().map(skiSlopeDTOMapper).toList();
        skiResortDTO.setSlopes(skiSlopeDTOS);
        return skiResortDTO;
    }
}
