package com.slambookBE.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "slam_books")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class SlamBook {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String fullName;

    @Column(length = 255)
    private String nickname;

    @Column(columnDefinition = "TEXT")
    private String profilePhotoUrl;

    private LocalDate dateOfBirth;

    @Enumerated(EnumType.STRING)
    private Gender gender;

    @Column(length = 255)
    private String favoriteColor;

    @ElementCollection
    private List<String> hobbies;

    @Column(columnDefinition = "TEXT")
    private String aboutMe;

    private Integer friendshipRating;

    private Boolean isBestFriend;

    private LocalDate friendshipStartDate;

    @Column(length = 255)
    private String songName;

    @Column(length = 255)
    private String songArtist;

    @Column(columnDefinition = "TEXT")
    private String songUrl;

    @Column(columnDefinition = "TEXT")
    private String songDedication;

    @Column(columnDefinition = "TEXT")
    private String memoryPhotoUrl;

    @Column(columnDefinition = "TEXT")
    private String memoryText;

    @CreationTimestamp
    private LocalDateTime createdAt;

    @UpdateTimestamp
    private LocalDateTime updatedAt;

    @OneToMany(
            mappedBy = "slamBook",
            cascade = CascadeType.ALL,
            orphanRemoval = true
    )
    private List<Friend> friends;
}