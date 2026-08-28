package com.slambookBE.controller;

import com.slambookBE.dto.ApiResponse;
import com.slambookBE.dto.CreateFriendRequest;
import com.slambookBE.dto.FriendResponse;
import com.slambookBE.dto.UpdateFriendRequest;
import com.slambookBE.service.FriendService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api")
public class FriendController {

    private final FriendService friendService;

    public FriendController(FriendService friendService) {
        this.friendService = friendService;
    }

    @PostMapping("/slam/{slamId}/friends")
    public ResponseEntity<ApiResponse<FriendResponse>> addFriend(@PathVariable Long slamId, @Valid @RequestBody CreateFriendRequest request) {
        FriendResponse response = friendService.addFriend(slamId, request);
        return new ResponseEntity<>(ApiResponse.success("Friend added successfully.", response), HttpStatus.CREATED);
    }

    @GetMapping("/slam/{slamId}/friends")
    public ResponseEntity<ApiResponse<List<FriendResponse>>> getFriends(@PathVariable Long slamId) {
        List<FriendResponse> response = friendService.getFriends(slamId);
        return ResponseEntity.ok(ApiResponse.success("Friends retrieved successfully.", response));
    }

    @PutMapping("/friends/{friendId}")
    public ResponseEntity<ApiResponse<FriendResponse>> updateFriend(@PathVariable Long friendId, @Valid @RequestBody UpdateFriendRequest request) {
        FriendResponse response = friendService.updateFriend(friendId, request);
        return ResponseEntity.ok(ApiResponse.success("Friend updated successfully.", response));
    }

    @DeleteMapping("/friends/{friendId}")
    public ResponseEntity<ApiResponse<Void>> deleteFriend(@PathVariable Long friendId) {
        friendService.deleteFriend(friendId);
        return ResponseEntity.ok(ApiResponse.success("Friend deleted successfully.", null));
    }
}
