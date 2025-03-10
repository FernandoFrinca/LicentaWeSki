package com.example.weski.service;

import com.example.weski.data.model.Locations;
import com.example.weski.dto.LocationDTO;
import com.example.weski.mapper.to.dto.LocationDTOMapper;
import com.example.weski.mapper.to.entity.LocationDTOtoEntityMapper;
import com.example.weski.repository.LocationRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;


@Service
public class LocationService {

    private final LocationRepository locationRepository;

    private final LocationDTOtoEntityMapper locationDTOtoEntityMapper;

    private final LocationDTOMapper locationDTOMapper;

    public LocationService(LocationRepository locationRepository, LocationDTOtoEntityMapper locationDTOtoEntityMapper, LocationDTOMapper locationDTOMapper) {
        this.locationRepository = locationRepository;
        this.locationDTOtoEntityMapper = locationDTOtoEntityMapper;
        this.locationDTOMapper = locationDTOMapper;
    }

    public void saveLocation(LocationDTO locationDTO) {
        Locations location;
        location = locationDTOtoEntityMapper.apply(locationDTO);
        locationRepository.save(location);
    }

    public List<LocationDTO> findAllForUser(Long userId) {
        List<Locations> entities = locationRepository.findAllByUserIdOrderByRecordedTime(userId);
/*        List<LocationDTO> locations = new ArrayList<LocationDTO>();
        for(var entity : entities) {
            locations.add(locationDTOMapper.)
        }
        */
        List<LocationDTO> locations = entities.stream()
                .map(locationDTOMapper)
                .toList();
        return locations;
    }

    @Transactional
    public void deleteUserLocations(Long user_id) {
        locationRepository.deleteLocationsByUserId(user_id);
    }
}
