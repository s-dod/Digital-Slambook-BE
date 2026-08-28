package com.slambookBE.service;

import com.slambookBE.dto.CreateFriendRequest;
import com.slambookBE.dto.FriendResponse;
import com.slambookBE.dto.UpdateFriendRequest;

import java.util.List;

public interface FriendService {
    FriendResponse addFriend(Long slamBookId, CreateFriendRequest request);
    List<FriendResponse> getFriends(Long slamBookId);
    FriendResponse updateFriend(Long friendId, UpdateFriendRequest request);
    void deleteFriend(Long friendId);
}
