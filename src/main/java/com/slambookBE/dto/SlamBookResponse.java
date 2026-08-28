package com.slambookBE.dto;

import com.slambookBE.entity.Gender;
import lombok.Data;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Data
public class SlamBookResponse {
    private Long id;
    private String fullName;
    private String nickname;
    private String profilePhotoUrl;
    private LocalDate dateOfBirth;
    private Gender gender;
    private String favoriteColor;
    private List<String> hobbies;
    private String aboutMe;
    private Integer friendshipRating;
    private Boolean isBestFriend;
    private LocalDate friendshipStartDate;
    private String songName;
    private String songArtist;
    private String songUrl;
    private String songDedication;
    private String memoryPhotoUrl;
    private String memoryText;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
