package com.example.weski.controller;

import com.example.weski.service.SkiResortService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import com.example.weski.dto.SkiResortDTO;

import java.util.List;

@RestController
@RequestMapping("/api/ski-resorts")
public class SkiResortController {

    @Autowired
    private final SkiResortService skiResortService;

    public SkiResortController(SkiResortService skiResortService) {
        this.skiResortService = skiResortService;
    }

    @GetMapping("/getAll")
    public List<SkiResortDTO> getAllSkiResorts() {
        return skiResortService.getAllSkiResorts();
    }

    @GetMapping("/getByResort")
    public SkiResortDTO getResortById(@RequestParam Long resortId) {
        return skiResortService.getResortById(resortId);
    }
}
