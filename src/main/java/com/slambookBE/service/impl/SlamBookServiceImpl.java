package com.slambookBE.service.impl;

import com.slambookBE.dto.CreateSlamBookRequest;
import com.slambookBE.dto.SlamBookResponse;
import com.slambookBE.dto.UpdateSlamBookRequest;
import com.slambookBE.entity.SlamBook;
import com.slambookBE.exception.ResourceNotFoundException;
import com.slambookBE.repository.SlamBookRepository;
import com.slambookBE.service.SlamBookService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class SlamBookServiceImpl implements SlamBookService {

    private final SlamBookRepository slamBookRepository;

    public SlamBookServiceImpl(SlamBookRepository slamBookRepository) {
        this.slamBookRepository = slamBookRepository;
    }

    @Override
    public SlamBookResponse createSlamBook(CreateSlamBookRequest request) {
        SlamBook slamBook = new SlamBook();
        mapCreateRequestToEntity(request, slamBook);
        SlamBook saved = slamBookRepository.save(slamBook);
        return mapToResponse(saved);
    }

    @Override
    public SlamBookResponse getSlamBook(Long id) {
        SlamBook slamBook = slamBookRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("SlamBook not found with id: " + id));
        return mapToResponse(slamBook);
    }

    @Override
    public SlamBookResponse updateSlamBook(Long id, UpdateSlamBookRequest request) {
        SlamBook slamBook = slamBookRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("SlamBook not found with id: " + id));
        mapUpdateRequestToEntity(request, slamBook);
        SlamBook updated = slamBookRepository.save(slamBook);
        return mapToResponse(updated);
    }

    @Override
    public List<SlamBookResponse> getAllSlamBooks() {
        return slamBookRepository.findAll()
                .stream()
                .map(this::mapToResponse)
                .toList();
    }

    @Override
    public void deleteSlamBook(Long id) {
        SlamBook slamBook = slamBookRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("SlamBook not found with id: " + id));
        slamBookRepository.delete(slamBook);
    }

    private void mapCreateRequestToEntity(CreateSlamBookRequest req, SlamBook entity) {
        entity.setFullName(req.getFullName());
        entity.setNickname(req.getNickname());
        entity.setProfilePhotoUrl(req.getProfilePhotoUrl());
        entity.setDateOfBirth(req.getDateOfBirth());
        entity.setGender(req.getGender());
        entity.setFavoriteColor(req.getFavoriteColor());
        entity.setHobbies(req.getHobbies());
        entity.setAboutMe(req.getAboutMe());
        entity.setFriendshipRating(req.getFriendshipRating());
        entity.setIsBestFriend(req.getIsBestFriend());
        entity.setFriendshipStartDate(req.getFriendshipStartDate());
        entity.setSongName(req.getSongName());
        entity.setSongArtist(req.getSongArtist());
        entity.setSongUrl(req.getSongUrl());
        entity.setSongDedication(req.getSongDedication());
        entity.setMemoryPhotoUrl(req.getMemoryPhotoUrl());
        entity.setMemoryText(req.getMemoryText());
    }

    private void mapUpdateRequestToEntity(UpdateSlamBookRequest req, SlamBook entity) {
        if (req.getFullName() != null) entity.setFullName(req.getFullName());
        if (req.getNickname() != null) entity.setNickname(req.getNickname());
        if (req.getProfilePhotoUrl() != null) entity.setProfilePhotoUrl(req.getProfilePhotoUrl());
        if (req.getDateOfBirth() != null) entity.setDateOfBirth(req.getDateOfBirth());
        if (req.getGender() != null) entity.setGender(req.getGender());
        if (req.getFavoriteColor() != null) entity.setFavoriteColor(req.getFavoriteColor());
        if (req.getHobbies() != null) entity.setHobbies(req.getHobbies());
        if (req.getAboutMe() != null) entity.setAboutMe(req.getAboutMe());
        if (req.getFriendshipRating() != null) entity.setFriendshipRating(req.getFriendshipRating());
        if (req.getIsBestFriend() != null) entity.setIsBestFriend(req.getIsBestFriend());
        if (req.getFriendshipStartDate() != null) entity.setFriendshipStartDate(req.getFriendshipStartDate());
        if (req.getSongName() != null) entity.setSongName(req.getSongName());
        if (req.getSongArtist() != null) entity.setSongArtist(req.getSongArtist());
        if (req.getSongUrl() != null) entity.setSongUrl(req.getSongUrl());
        if (req.getSongDedication() != null) entity.setSongDedication(req.getSongDedication());
        if (req.getMemoryPhotoUrl() != null) entity.setMemoryPhotoUrl(req.getMemoryPhotoUrl());
        if (req.getMemoryText() != null) entity.setMemoryText(req.getMemoryText());
    }

    private SlamBookResponse mapToResponse(SlamBook entity) {
        SlamBookResponse resp = new SlamBookResponse();
        resp.setId(entity.getId());
        resp.setFullName(entity.getFullName());
        resp.setNickname(entity.getNickname());
        resp.setProfilePhotoUrl(entity.getProfilePhotoUrl());
        resp.setDateOfBirth(entity.getDateOfBirth());
        resp.setGender(entity.getGender());
        resp.setFavoriteColor(entity.getFavoriteColor());
        resp.setHobbies(entity.getHobbies());
        resp.setAboutMe(entity.getAboutMe());
        resp.setFriendshipRating(entity.getFriendshipRating());
        resp.setIsBestFriend(entity.getIsBestFriend());
        resp.setFriendshipStartDate(entity.getFriendshipStartDate());
        resp.setSongName(entity.getSongName());
        resp.setSongArtist(entity.getSongArtist());
        resp.setSongUrl(entity.getSongUrl());
        resp.setSongDedication(entity.getSongDedication());
        resp.setMemoryPhotoUrl(entity.getMemoryPhotoUrl());
        resp.setMemoryText(entity.getMemoryText());
        resp.setCreatedAt(entity.getCreatedAt());
        resp.setUpdatedAt(entity.getUpdatedAt());
        return resp;
    }
}
