package com.slambookBE.dto;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.Size;
import lombok.Data;
import java.time.LocalDate;

@Data
public class UpdateFriendRequest {
    private String friendName;
    private String relationship;
    @Min(1) @Max(10)
    private Integer friendshipRating;
    private Boolean isBestFriend;
    private LocalDate friendshipSince;
    @Size(max = 500)
    private String message;
    private String songName;
    private String songArtist;
    private String songUrl;
    private String songDedication;
    private String memoryPhotoUrl;
    @Size(max = 500)
    private String memoryText;
}
