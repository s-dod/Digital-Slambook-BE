package com.slambookBE.service;

import com.slambookBE.dto.CreateSlamBookRequest;
import com.slambookBE.dto.SlamBookResponse;
import com.slambookBE.dto.UpdateSlamBookRequest;

import java.util.List;

public interface SlamBookService {
    SlamBookResponse createSlamBook(CreateSlamBookRequest request);
    SlamBookResponse getSlamBook(Long id);
    SlamBookResponse updateSlamBook(Long id, UpdateSlamBookRequest request);
    public List<SlamBookResponse> getAllSlamBooks();
    void deleteSlamBook(Long id);
}
