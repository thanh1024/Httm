package com.PTHTTM.nhom18.controller;

import com.PTHTTM.nhom18.dto.TrainingCallBackPayload;
import com.PTHTTM.nhom18.service.TrainingJobService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

/**
 * REST API Controller để nhận callback từ Python Training Service
 */
@RestController
@RequestMapping("/api/training")
public class TrainingCallbackController {
    
    private static final Logger logger = LoggerFactory.getLogger(TrainingCallbackController.class);
    private final TrainingJobService trainingJobService;

    public TrainingCallbackController(TrainingJobService trainingJobService) {
        this.trainingJobService = trainingJobService;
    }

    /**
     * Endpoint để Python service gọi sau khi training xong
     * URL: POST http://localhost:8080/api/training/callback/{jobId}
     */
    @PostMapping("/callback/{jobId}")
    public ResponseEntity<String> handleTrainingCallback(
            @PathVariable Long jobId,
            @RequestBody TrainingCallBackPayload payload
    ) {
        try {
            logger.info("Received training callback for job {}: status={}", jobId, payload.getStatus());
            
            // Validate
            if (payload.getStatus() == null) {
                logger.error("Invalid callback: missing status");
                return ResponseEntity.badRequest().body("Missing status field");
            }
            
            // Process callback
            trainingJobService.processTrainingCallback(jobId, payload);
            
            logger.info("Callback processed successfully for job {}", jobId);
            return ResponseEntity.ok("Callback received successfully");
            
        } catch (Exception e) {
            logger.error("Error processing callback for job {}: {}", jobId, e.getMessage(), e);
            return ResponseEntity.internalServerError().body("Error processing callback: " + e.getMessage());
        }
    }
}







