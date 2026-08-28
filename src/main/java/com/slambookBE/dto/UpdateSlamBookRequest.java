package com.slambookBE.dto;

import com.slambookBE.entity.Gender;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.Size;
import lombok.Data;
import java.time.LocalDate;
import java.util.List;

@Data
public class UpdateSlamBookRequest {
    private String fullName;
    private String nickname;
    private String profilePhotoUrl;
    private LocalDate dateOfBirth;
    private Gender gender;
    private String favoriteColor;
    private List<String> hobbies;
    @Size(max = 500, message = "About me cannot exceed 500 characters")
    private String aboutMe;
    @Min(1) @Max(10)
    private Integer friendshipRating;
    private Boolean isBestFriend;
    private LocalDate friendshipStartDate;
    private String songName;
    private String songArtist;
    private String songUrl;
    private String songDedication;
    private String memoryPhotoUrl;
    @Size(max = 500, message = "Memory text cannot exceed 500 characters")
    private String memoryText;
}
