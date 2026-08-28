$base_dir = "E:\Suraj Slambook\BE\src\main\java\com\slambookBE"
$packages = @("entity", "repository", "dto", "service", "service\impl", "controller", "exception", "config")

foreach ($pkg in $packages) {
    $dir = Join-Path $base_dir $pkg
    if (-Not (Test-Path $dir)) {
        New-Item -ItemType Directory -Force -Path $dir | Out-Null
    }
}

$files = @{
    "entity\Gender.java" = @"
package com.slambookBE.entity;

public enum Gender {
    MALE,
    FEMALE,
    OTHER
}
"@;

    "entity\SlamBook.java" = @"
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
    private String nickname;
    private String profilePhotoUrl;
    private LocalDate dateOfBirth;

    @Enumerated(EnumType.STRING)
    private Gender gender;
    private String favoriteColor;

    @ElementCollection
    private List<String> hobbies;

    @Column(length = 500)
    private String aboutMe;
    private Integer friendshipRating;
    private Boolean isBestFriend;
    private LocalDate friendshipStartDate;

    private String songName;
    private String songArtist;
    private String songUrl;
    private String songDedication;

    private String memoryPhotoUrl;
    @Column(length = 500)
    private String memoryText;

    @CreationTimestamp
    private LocalDateTime createdAt;

    @UpdateTimestamp
    private LocalDateTime updatedAt;

    @OneToMany(mappedBy = "slamBook", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Friend> friends;
}
"@;

    "entity\Friend.java" = @"
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
    
    @Column(length = 500)
    private String message;

    private String songName;
    private String songArtist;
    private String songUrl;
    private String songDedication;

    private String memoryPhotoUrl;
    @Column(length = 500)
    private String memoryText;

    @CreationTimestamp
    private LocalDateTime createdAt;

    @UpdateTimestamp
    private LocalDateTime updatedAt;
}
"@;

    "repository\SlamBookRepository.java" = @"
package com.slambookBE.repository;

import com.slambookBE.entity.SlamBook;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface SlamBookRepository extends JpaRepository<SlamBook, Long> {
}
"@;

    "repository\FriendRepository.java" = @"
package com.slambookBE.repository;

import com.slambookBE.entity.Friend;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface FriendRepository extends JpaRepository<Friend, Long> {
    List<Friend> findBySlamBookId(Long slamBookId);
}
"@;

    "dto\ApiResponse.java" = @"
package com.slambookBE.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ApiResponse<T> {
    private boolean success;
    private String message;
    private T data;
    @Builder.Default
    private LocalDateTime timestamp = LocalDateTime.now();

    public static <T> ApiResponse<T> success(String message, T data) {
        return ApiResponse.<T>builder().success(true).message(message).data(data).build();
    }
    
    public static <T> ApiResponse<T> error(String message) {
        return ApiResponse.<T>builder().success(false).message(message).build();
    }
}
"@;

    "dto\CreateSlamBookRequest.java" = @"
package com.slambookBE.dto;

import com.slambookBE.entity.Gender;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;
import java.time.LocalDate;
import java.util.List;

@Data
public class CreateSlamBookRequest {
    @NotBlank(message = "Full name is required")
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
"@;

    "dto\UpdateSlamBookRequest.java" = @"
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
"@;

    "dto\SlamBookResponse.java" = @"
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
"@;

    "dto\CreateFriendRequest.java" = @"
package com.slambookBE.dto;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;
import java.time.LocalDate;

@Data
public class CreateFriendRequest {
    @NotBlank(message = "Friend name is required")
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
"@;

    "dto\UpdateFriendRequest.java" = @"
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
"@;

    "dto\FriendResponse.java" = @"
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
"@;

    "exception\ResourceNotFoundException.java" = @"
package com.slambookBE.exception;

public class ResourceNotFoundException extends RuntimeException {
    public ResourceNotFoundException(String message) {
        super(message);
    }
}
"@;

    "exception\GlobalExceptionHandler.java" = @"
package com.slambookBE.exception;

import com.slambookBE.dto.ApiResponse;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.util.stream.Collectors;

@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(ResourceNotFoundException.class)
    public ResponseEntity<ApiResponse<Object>> handleResourceNotFound(ResourceNotFoundException ex) {
        return new ResponseEntity<>(ApiResponse.error("The requested SLAM Book could not be found."), HttpStatus.NOT_FOUND);
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ApiResponse<Object>> handleValidationExceptions(MethodArgumentNotValidException ex) {
        String errors = ex.getBindingResult().getAllErrors().stream()
                .map(error -> ((FieldError) error).getField() + ": " + error.getDefaultMessage())
                .collect(Collectors.joining(", "));
        return new ResponseEntity<>(ApiResponse.error("Please check the information entered. " + errors), HttpStatus.BAD_REQUEST);
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ApiResponse<Object>> handleGlobalException(Exception ex) {
        return new ResponseEntity<>(ApiResponse.error("An unexpected error occurred."), HttpStatus.INTERNAL_SERVER_ERROR);
    }
}
"@;

    "config\CorsConfig.java" = @"
package com.slambookBE.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class CorsConfig implements WebMvcConfigurer {

    @Value("`${cors.allowed-origins:http://localhost:5173}")
    private String allowedOrigins;

    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**")
                .allowedOrigins(allowedOrigins.split(","))
                .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")
                .allowedHeaders("*")
                .allowCredentials(true);
    }
}
"@;

    "service\SlamBookService.java" = @"
package com.slambookBE.service;

import com.slambookBE.dto.CreateSlamBookRequest;
import com.slambookBE.dto.SlamBookResponse;
import com.slambookBE.dto.UpdateSlamBookRequest;

public interface SlamBookService {
    SlamBookResponse createSlamBook(CreateSlamBookRequest request);
    SlamBookResponse getSlamBook(Long id);
    SlamBookResponse updateSlamBook(Long id, UpdateSlamBookRequest request);
    void deleteSlamBook(Long id);
}
"@;

    "service\FriendService.java" = @"
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
"@;

    "service\impl\SlamBookServiceImpl.java" = @"
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
"@;

    "service\impl\FriendServiceImpl.java" = @"
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
"@;

    "controller\SlamBookController.java" = @"
package com.slambookBE.controller;

import com.slambookBE.dto.ApiResponse;
import com.slambookBE.dto.CreateSlamBookRequest;
import com.slambookBE.dto.SlamBookResponse;
import com.slambookBE.dto.UpdateSlamBookRequest;
import com.slambookBE.service.SlamBookService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/slam")
public class SlamBookController {

    private final SlamBookService slamBookService;

    public SlamBookController(SlamBookService slamBookService) {
        this.slamBookService = slamBookService;
    }

    @PostMapping
    public ResponseEntity<ApiResponse<SlamBookResponse>> createSlamBook(@Valid @RequestBody CreateSlamBookRequest request) {
        SlamBookResponse response = slamBookService.createSlamBook(request);
        return new ResponseEntity<>(ApiResponse.success("SLAM Book created successfully.", response), HttpStatus.CREATED);
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<SlamBookResponse>> getSlamBook(@PathVariable Long id) {
        SlamBookResponse response = slamBookService.getSlamBook(id);
        return ResponseEntity.ok(ApiResponse.success("SLAM Book retrieved successfully.", response));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<SlamBookResponse>> updateSlamBook(@PathVariable Long id, @Valid @RequestBody UpdateSlamBookRequest request) {
        SlamBookResponse response = slamBookService.updateSlamBook(id, request);
        return ResponseEntity.ok(ApiResponse.success("SLAM Book updated successfully.", response));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> deleteSlamBook(@PathVariable Long id) {
        slamBookService.deleteSlamBook(id);
        return ResponseEntity.ok(ApiResponse.success("SLAM Book deleted successfully.", null));
    }
}
"@;

    "controller\FriendController.java" = @"
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
"@
}

foreach ($rel_path in $files.Keys) {
    $file_path = Join-Path $base_dir $rel_path
    $content = $files[$rel_path]
    Set-Content -Path $file_path -Value $content -Encoding UTF8
}

Write-Host "Files generated successfully."
