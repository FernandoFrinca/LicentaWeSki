package com.example.weski.service;
import com.example.weski.data.model.SkiSlope;
import com.example.weski.dto.SkiSlopeDTO;
import com.example.weski.mapper.to.dto.SkiSlopeDTOMapper;
//import com.example.weski.mapper.to.SkiSlopeMapper;
import com.example.weski.repository.SkiSlopeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Collections;
import java.util.List;
@Service
public class SkiSlopeService {
    private final SkiSlopeRepository skiSlopeRepository;
    private final SkiSlopeDTOMapper skiSlopeMapper;

    @Autowired
    public SkiSlopeService(SkiSlopeRepository skiSlopeRepository, SkiSlopeDTOMapper skiSlopeMapper) {
        this.skiSlopeRepository = skiSlopeRepository;
        this.skiSlopeMapper = skiSlopeMapper;
    }

    public List<SkiSlopeDTO> getAllSkiSlopes() {
        List<SkiSlope> skiSlopeList = skiSlopeRepository.findAll();
        return Collections.singletonList(skiSlopeMapper.apply((SkiSlope) skiSlopeList));
    }

}