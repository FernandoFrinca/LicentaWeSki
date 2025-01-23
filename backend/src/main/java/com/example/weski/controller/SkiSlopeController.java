package com.example.weski.controller;

import com.example.weski.service.SkiSlopeService;
import com.example.weski.dto.SkiSlopeDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/ski-slopes")
public class SkiSlopeController {
    @Autowired
    private final SkiSlopeService skiSlopeService;

    public SkiSlopeController(SkiSlopeService skiSlopeService) {
        this.skiSlopeService = skiSlopeService;
    }

    @GetMapping("/getAll")
    public List<SkiSlopeDTO> getAllSkiSlopes() {
        return skiSlopeService.getAllSkiSlopes();
    }
}
