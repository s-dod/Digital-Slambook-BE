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
