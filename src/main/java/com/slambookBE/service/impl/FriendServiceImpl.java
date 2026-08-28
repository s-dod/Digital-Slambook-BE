package com.slambookBE.service.impl;

import com.slambookBE.dto.CreateFriendRequest;
import com.slambookBE.dto.FriendResponse;
import com.slambookBE.dto.UpdateFriendRequest;
import com.slambookBE.entity.Friend;
import com.slambookBE.entity.SlamBook;
import com.slambookBE.exception.ResourceNotFoundException;
import com.slambookBE.repository.FriendRepository;
import com.slambookBE.repository.SlamBookRepository;
import com.slambookBE.service.FriendService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@Transactional
public class FriendServiceImpl implements FriendService {

    private final FriendRepository friendRepository;
    private final SlamBookRepository slamBookRepository;

    public FriendServiceImpl(FriendRepository friendRepository, SlamBookRepository slamBookRepository) {
        this.friendRepository = friendRepository;
        this.slamBookRepository = slamBookRepository;
    }

    @Override
    public FriendResponse addFriend(Long slamBookId, CreateFriendRequest request) {
        SlamBook slamBook = slamBookRepository.findById(slamBookId)
                .orElseThrow(() -> new ResourceNotFoundException("SlamBook not found"));
        
        Friend friend = new Friend();
        friend.setSlamBook(slamBook);
        mapCreateRequestToEntity(request, friend);
        
        Friend saved = friendRepository.save(friend);
        return mapToResponse(saved);
    }

    @Override
    public List<FriendResponse> getFriends(Long slamBookId) {
        if(!slamBookRepository.existsById(slamBookId)) {
            throw new ResourceNotFoundException("SlamBook not found");
        }
        return friendRepository.findBySlamBookId(slamBookId).stream()
                .map(this::mapToResponse)
                .collect(Collectors.toList());
    }

    @Override
    public FriendResponse updateFriend(Long friendId, UpdateFriendRequest request) {
        Friend friend = friendRepository.findById(friendId)
                .orElseThrow(() -> new ResourceNotFoundException("Friend not found"));
        
        mapUpdateRequestToEntity(request, friend);
        Friend updated = friendRepository.save(friend);
        return mapToResponse(updated);
    }

    @Override
    public void deleteFriend(Long friendId) {
        Friend friend = friendRepository.findById(friendId)
                .orElseThrow(() -> new ResourceNotFoundException("Friend not found"));
        friendRepository.delete(friend);
    }

    private void mapCreateRequestToEntity(CreateFriendRequest req, Friend entity) {
        entity.setFriendName(req.getFriendName());
        entity.setRelationship(req.getRelationship());
        entity.setFriendshipRating(req.getFriendshipRating());
        entity.setIsBestFriend(req.getIsBestFriend());
        entity.setFriendshipSince(req.getFriendshipSince());
        entity.setMessage(req.getMessage());
        entity.setSongName(req.getSongName());
        entity.setSongArtist(req.getSongArtist());
        entity.setSongUrl(req.getSongUrl());
        entity.setSongDedication(req.getSongDedication());
        entity.setMemoryPhotoUrl(req.getMemoryPhotoUrl());
        entity.setMemoryText(req.getMemoryText());
    }

    private void mapUpdateRequestToEntity(UpdateFriendRequest req, Friend entity) {
        if (req.getFriendName() != null) entity.setFriendName(req.getFriendName());
        if (req.getRelationship() != null) entity.setRelationship(req.getRelationship());
        if (req.getFriendshipRating() != null) entity.setFriendshipRating(req.getFriendshipRating());
        if (req.getIsBestFriend() != null) entity.setIsBestFriend(req.getIsBestFriend());
        if (req.getFriendshipSince() != null) entity.setFriendshipSince(req.getFriendshipSince());
        if (req.getMessage() != null) entity.setMessage(req.getMessage());
        if (req.getSongName() != null) entity.setSongName(req.getSongName());
        if (req.getSongArtist() != null) entity.setSongArtist(req.getSongArtist());
        if (req.getSongUrl() != null) entity.setSongUrl(req.getSongUrl());
        if (req.getSongDedication() != null) entity.setSongDedication(req.getSongDedication());
        if (req.getMemoryPhotoUrl() != null) entity.setMemoryPhotoUrl(req.getMemoryPhotoUrl());
        if (req.getMemoryText() != null) entity.setMemoryText(req.getMemoryText());
    }

    private FriendResponse mapToResponse(Friend entity) {
        FriendResponse resp = new FriendResponse();
        resp.setId(entity.getId());
        resp.setSlamBookId(entity.getSlamBook().getId());
        resp.setFriendName(entity.getFriendName());
        resp.setRelationship(entity.getRelationship());
        resp.setFriendshipRating(entity.getFriendshipRating());
        resp.setIsBestFriend(entity.getIsBestFriend());
        resp.setFriendshipSince(entity.getFriendshipSince());
        resp.setMessage(entity.getMessage());
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
