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
