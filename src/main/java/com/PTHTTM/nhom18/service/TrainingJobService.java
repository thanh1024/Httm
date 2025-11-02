package com.PTHTTM.nhom18.service;

import com.PTHTTM.nhom18.dto.TrainingCallBackPayload;
import com.PTHTTM.nhom18.dto.TrainingRequestDTO;
import com.PTHTTM.nhom18.model.DataSource;
import com.PTHTTM.nhom18.model.ModelVersion;
import com.PTHTTM.nhom18.model.TrainingJob;
import com.PTHTTM.nhom18.model.TrainingResult;
import com.PTHTTM.nhom18.model.TrainingJobDataSource;
import com.PTHTTM.nhom18.repository.ModelVersionRepository;
import com.PTHTTM.nhom18.repository.TrainingJobRepository;
import com.PTHTTM.nhom18.repository.TrainingResultRepository;
import com.PTHTTM.nhom18.repository.TrainingJobDataSourceRepository;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;

@Service
public class TrainingJobService {
  private static final Logger logger = LoggerFactory.getLogger(TrainingJobService.class);
  
  private final TrainingJobRepository trainingJobRepository;
  private final ModelVersionService modelVersionService;
  private final ModelVersionRepository modelVersionRepository;
  private final TrainingResultRepository trainingResultRepository;
  private final TrainingJobDataSourceRepository trainingJobDataSourceRepository;
  private final RestTemplate restTemplate;

  @Value("${ml.service.train.url}")
  private String pythonTrainUrl;


  public TrainingJobService(
      TrainingJobRepository trainingJobRepository,
      ModelVersionService modelVersionService,
      RestTemplate restTemplate,
      ModelVersionRepository modelVersionRepository,
      TrainingResultRepository trainingResultRepository,
      TrainingJobDataSourceRepository trainingJobDataSourceRepository
      ) {
    this.trainingJobRepository = trainingJobRepository;
    this.modelVersionService = modelVersionService;
    this.restTemplate = restTemplate;
    this.modelVersionRepository = modelVersionRepository;
    this.trainingResultRepository = trainingResultRepository;
    this.trainingJobDataSourceRepository = trainingJobDataSourceRepository;
  }


  public TrainingJob findById(Long id) {
    Optional<TrainingJob> trainingJob = trainingJobRepository.findById(id);
    if (trainingJob.isPresent()) {
      return trainingJob.get();
    }
    return null;
  }

  public TrainingJob createTrainingJob(String versionName, List<Long> dataSourceIds) {
    throw new IllegalArgumentException("modelType is required. Use createTrainingJob(versionName, dataSourceIds, modelType)");
  }

  public TrainingJob createTrainingJob(String versionName, List<Long> dataSourceIds, String modelType) {
    if (modelType == null || modelType.isEmpty()) {
      throw new IllegalArgumentException("modelType cannot be null or empty");
    }
    
    ModelVersion version = modelVersionService.createVersion(versionName, modelType);

    TrainingJob job = new TrainingJob();
    job.setModelVersion(version);
    job.setStatus("STARTED");
    TrainingJob savedJob = trainingJobRepository.save(job);

    // Lưu mapping giữa job và data sources - QUAN TRỌNG: để biết model được train từ data nào
    for (Long dataSourceId : dataSourceIds) {
      TrainingJobDataSource mapping = new TrainingJobDataSource();
      mapping.setTrainingJob(savedJob);
      DataSource dataSource = new DataSource();
      dataSource.setId(dataSourceId);
      mapping.setDataSource(dataSource);
      trainingJobDataSourceRepository.save(mapping);
    }

    TrainingRequestDTO request = new TrainingRequestDTO();
    request.setJobId(savedJob.getId());
    request.setVersionName(versionName);
    request.setDataSourceIds(dataSourceIds);
    request.setModelType(modelType); // Python service sẽ xử lý khác nhau dựa trên modelType này

    startPythonTraining(request, savedJob);
    return savedJob;
  }

  @Async
  public void startPythonTraining(TrainingRequestDTO request, TrainingJob savedJob) {
    try {
      restTemplate.postForLocation(pythonTrainUrl, request);
    } catch (RestClientException ex) {
      savedJob.setStatus("FAILED");
      savedJob.setErrorMessage("Failed to start python training job");
      trainingJobRepository.save(savedJob);
    }
  }

    /**
     * Lấy danh sách data sources đã được sử dụng để train một job cụ thể
     */
    public List<DataSource> getDataSourcesUsedForTraining(Long jobId) {
        List<TrainingJobDataSource> mappings = trainingJobDataSourceRepository.findByTrainingJobId(jobId);
        List<DataSource> dataSources = new ArrayList<>();
        for (TrainingJobDataSource mapping : mappings) {
            dataSources.add(mapping.getDataSource());
        }
        return dataSources;
    }
    @Transactional
    public void processTrainingCallback(Long jobId, TrainingCallBackPayload payload) {
        logger.info("Processing callback for job {}: status={}, metrics={}", 
                    jobId, payload.getStatus(), payload.getMetrics());
        
        Optional<TrainingJob> jobOpt = trainingJobRepository.findById(jobId);
        if (jobOpt.isEmpty()) {
            logger.error("Training job {} not found", jobId);
            return;
        }
        TrainingJob job = jobOpt.get();

        ModelVersion modelVersion = job.getModelVersion();
        if (modelVersion == null) {
            job.setStatus("FAILED");
            job.setErrorMessage("Không tìm thấy ModelVersion liên kết.");
            trainingJobRepository.save(job); // Lưu trạng thái FAILED
            return;
        }

        if ("COMPLETED".equals(payload.getStatus())) {
            job.setStatus("COMPLETED");
            job.setErrorMessage(null);

            modelVersion.setCheckpointUrl(payload.getModelPath());
            modelVersionRepository.save(modelVersion);

            TrainingResult trainingResult = new TrainingResult();
            trainingResult.setJob(job);

            if (payload.getMetrics() != null) {
                // Null-safe get with default 0.0
                trainingResult.setAccuracy(payload.getMetrics().getOrDefault("eval_accuracy", 0.0));
                trainingResult.setRecall(payload.getMetrics().getOrDefault("eval_recall_macro", 0.0));
                trainingResult.setPrecision(payload.getMetrics().getOrDefault("eval_precision_macro", 0.0));
                trainingResult.setF1Score(payload.getMetrics().getOrDefault("eval_f1_macro", 0.0));
            } else {
                trainingResult.setPrecision(0.0);
                trainingResult.setF1Score(0.0);
                trainingResult.setAccuracy(0.0);
                trainingResult.setRecall(0.0);
            }
            trainingResultRepository.save(trainingResult);

            job.setTrainingResult(trainingResult);

        } else {
            job.setStatus("FAILED");
            job.setErrorMessage(payload.getErrorMessage());

        }

        trainingJobRepository.save(job);
    }
}
