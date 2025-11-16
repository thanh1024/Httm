package com.PTHTTM.nhom18.service;

import com.PTHTTM.nhom18.model.DataSource;
import com.PTHTTM.nhom18.model.DataSourceSample;
import com.PTHTTM.nhom18.repository.DataSourceRepository;
import com.PTHTTM.nhom18.repository.DataSourceSampleRepository;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class DataSourceService {
  private static final Logger logger = LoggerFactory.getLogger(DataSourceService.class);
  
  private final DataSourceRepository dataSourceRepository;
  private final DataSourceSampleRepository dataSourceSampleRepository;

  public DataSourceService(
      DataSourceRepository dataSourceRepository,
      DataSourceSampleRepository dataSourceSampleRepository) {
    this.dataSourceRepository = dataSourceRepository;
    this.dataSourceSampleRepository = dataSourceSampleRepository;
  }

  // ==================== DATASET CRUD ====================
  
  public List<DataSource> getAllDataSources() {
    return dataSourceRepository.findAllByOrderByCreatedAtDesc();
  }
  
  public List<DataSource> getDataSource() {
    return dataSourceRepository.findAllByOrderByCreatedAtDesc();
  }
  
  
  public DataSource getDataSourceById(Long id) {
    return dataSourceRepository.findById(id).orElse(null);
  }
  
  public Optional<DataSource> findById(Long id) {
    return dataSourceRepository.findById(id);
  }
  
  @Transactional
  public DataSource createDataSource(String name) {
    DataSource dataSource = new DataSource();
    dataSource.setName(name);
    dataSource.setFileUrl(null); // Manual dataset, no file
    dataSource.setCreatedAt(LocalDateTime.now());
    
    DataSource saved = dataSourceRepository.save(dataSource);
    logger.info("Created new dataset: {} (ID: {})", name, saved.getId());
    return saved;
  }
  
  @Transactional
  public DataSource createDataSourceManual(String name) {
    return createDataSource(name);
  }
  
  @Transactional
  public DataSource updateDataSource(Long id, String name) {
    Optional<DataSource> dsOpt = dataSourceRepository.findById(id);
    if (dsOpt.isEmpty()) {
      throw new IllegalArgumentException("Dataset not found: " + id);
    }
    
    DataSource dataSource = dsOpt.get();
    dataSource.setName(name);
    
    DataSource saved = dataSourceRepository.save(dataSource);
    logger.info("Updated dataset: {} (ID: {})", name, id);
    return saved;
  }
  
  @Transactional
  public DataSource updateDataSource(DataSource dataSource) {
    DataSource saved = dataSourceRepository.save(dataSource);
    logger.info("Updated dataset: {} (ID: {})", dataSource.getName(), dataSource.getId());
    return saved;
  }
  
  @Transactional
  public void deleteDataSource(Long id) {
    Optional<DataSource> dsOpt = dataSourceRepository.findById(id);
    if (dsOpt.isEmpty()) {
      throw new IllegalArgumentException("Dataset not found: " + id);
    }
    
    // Cascade delete sẽ tự động xóa samples
    dataSourceRepository.deleteById(id);
    logger.info("Deleted dataset: {}", id);
  }
  
  // ==================== SAMPLE CRUD ====================
  
  public List<DataSourceSample> getSamplesByDataSourceId(Long dataSourceId) {
    return dataSourceSampleRepository.findByDataSourceId(dataSourceId);
  }
  
  public List<DataSourceSample> getSamplesByIds(List<Long> sampleIds) {
    return dataSourceSampleRepository.findByIdIn(sampleIds);
  }
  
  public DataSourceSample getSampleById(Long id) {
    return dataSourceSampleRepository.findById(id).orElse(null);
  }
  
  public Optional<DataSourceSample> findSampleById(Long id) {
    return dataSourceSampleRepository.findById(id);
  }
  
  @Transactional
  public DataSourceSample createSample(Long dataSourceId, String text, Integer rating, String label) {
    Optional<DataSource> dsOpt = dataSourceRepository.findById(dataSourceId);
    if (dsOpt.isEmpty()) {
      throw new IllegalArgumentException("Dataset not found: " + dataSourceId);
    }
    
    DataSource dataSource = dsOpt.get();
    
    // Lấy row index tiếp theo
    List<DataSourceSample> existingSamples = dataSourceSampleRepository.findByDataSourceId(dataSourceId);
    int nextRowIndex = existingSamples.size();
    
    DataSourceSample sample = new DataSourceSample();
    sample.setDataSource(dataSource);
    sample.setText(text);
    sample.setRating(rating);
    sample.setLabel(label);
    sample.setRowIndex(nextRowIndex);
    sample.setCreatedAt(LocalDateTime.now());
    
    DataSourceSample saved = dataSourceSampleRepository.save(sample);
    logger.info("Created new sample for dataset {} (sample ID: {})", dataSourceId, saved.getId());
    return saved;
  }
  
  @Transactional
  public DataSourceSample saveSample(DataSourceSample sample) {
    DataSourceSample saved = dataSourceSampleRepository.save(sample);
    logger.info("Saved sample: {} for dataset: {}", saved.getId(), saved.getDataSource().getId());
    return saved;
  }
  
  @Transactional
  public DataSourceSample updateSample(Long sampleId, String text, Integer rating, String label) {
    Optional<DataSourceSample> sampleOpt = dataSourceSampleRepository.findById(sampleId);
    if (sampleOpt.isEmpty()) {
      throw new IllegalArgumentException("Sample not found: " + sampleId);
    }
    
    DataSourceSample sample = sampleOpt.get();
    sample.setText(text);
    sample.setRating(rating);
    sample.setLabel(label);
    
    DataSourceSample saved = dataSourceSampleRepository.save(sample);
    logger.info("Updated sample: {}", sampleId);
    return saved;
  }
  
  @Transactional
  public DataSourceSample updateSample(DataSourceSample sample) {
    DataSourceSample saved = dataSourceSampleRepository.save(sample);
    logger.info("Updated sample: {}", sample.getId());
    return saved;
  }
  
  @Transactional
  public void deleteSample(Long sampleId) {
    Optional<DataSourceSample> sampleOpt = dataSourceSampleRepository.findById(sampleId);
    if (sampleOpt.isEmpty()) {
      throw new IllegalArgumentException("Sample not found: " + sampleId);
    }
    
    dataSourceSampleRepository.deleteById(sampleId);
    logger.info("Deleted sample: {}", sampleId);
  }
  
  // Count samples by dataset
  public long countSamplesByDataSourceId(Long dataSourceId) {
    return dataSourceSampleRepository.findByDataSourceId(dataSourceId).size();
  }
}
