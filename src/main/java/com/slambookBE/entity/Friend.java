package com.slambookBE.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "friends")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Friend {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "slam_book_id", nullable = false)
    private SlamBook slamBook;

    @Column(nullable = false)
    private String friendName;
    private String relationship;
    private Integer friendshipRating;
    private Boolean isBestFriend;
    private LocalDate friendshipSince;
    
    @Column(columnDefinition = "TEXT")
    private String message;

    private String songName;
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
}
