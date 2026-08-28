package com.slambookBE.dto;

import lombok.Data;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
public class FriendResponse {
    private Long id;
    private Long slamBookId;
    private String friendName;
    private String relationship;
    private Integer friendshipRating;
    private Boolean isBestFriend;
    private LocalDate friendshipSince;
    private String message;
    private String songName;
    private String songArtist;
    private String songUrl;
    private String songDedication;
    private String memoryPhotoUrl;
    private String memoryText;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
