package com.example.weski.controller;

import com.example.weski.dto.LocationDTO;
import com.example.weski.dto.LocationWebSocketDTO;
import com.example.weski.service.LocationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/locations")
public class LocationController {

    @Autowired
    LocationService locationService;

    @MessageMapping("/newLocation")
    @SendTo("/location/updates")
    public LocationWebSocketDTO updateLocation(LocationWebSocketDTO liveLocation) {
        return liveLocation;
    }

    @PostMapping("/post")
    public ResponseEntity saveLocation(@RequestBody LocationDTO locationDTO) {
        locationService.saveLocation(locationDTO);
        return ResponseEntity.ok("Locatie Salvata");
    }

    @GetMapping("/get/{user_id}")
    public List<LocationDTO> getLocation(@PathVariable Long user_id) {
        return locationService.findAllForUser(user_id);
    }

    @DeleteMapping("/clearData/{user_id}")
    public ResponseEntity clearData(@PathVariable Long user_id) {
        locationService.deleteUserLocations(user_id);
        return ResponseEntity.ok("Date sterse");
    }
}
