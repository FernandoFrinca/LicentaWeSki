package com.example.weski.service;

import com.example.weski.data.model.SkiResort;
import com.example.weski.data.model.SkiSlope;
import com.example.weski.dto.SkiResortDTO;
import com.example.weski.dto.SkiSlopeDTO;
import com.example.weski.mapper.to.SkiResortDTOMapper;
//import com.example.weski.mapper.to.SkiResortMapper;
import com.example.weski.repository.SkiResortRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Set;

@Service
public class SkiResortService {
    private final SkiResortRepository skiResortRepository;
    private final SkiResortDTOMapper skiResortMapper;

    @Autowired
    public SkiResortService(SkiResortRepository skiResortRepository, SkiResortDTOMapper skiResortMapper) {
        this.skiResortRepository = skiResortRepository;
        this.skiResortMapper = skiResortMapper;
    }

    public List<SkiResortDTO> getAllSkiResorts() {
        List<SkiResort> skiResorts = skiResortRepository.findAll();
        return skiResorts.stream().map(skiResortMapper).toList();
    }

    public SkiResortDTO getResortById(Long resortId) {
        SkiResort skiResort = skiResortRepository.findById(resortId).orElse(null);
        return skiResortMapper.apply(skiResort);
    }
}