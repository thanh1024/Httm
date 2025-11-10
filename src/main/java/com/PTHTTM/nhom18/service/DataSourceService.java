package com.PTHTTM.nhom18.service;

import com.PTHTTM.nhom18.model.DataSource;
import com.PTHTTM.nhom18.model.DataSourceSample;
import com.PTHTTM.nhom18.repository.DataSourceRepository;
import com.PTHTTM.nhom18.repository.DataSourceSampleRepository;
import java.util.List;
import org.springframework.stereotype.Service;

@Service
public class DataSourceService {
  private final DataSourceRepository dataSourceRepository;
  private final DataSourceSampleRepository dataSourceSampleRepository;

  public DataSourceService(
      DataSourceRepository dataSourceRepository,
      DataSourceSampleRepository dataSourceSampleRepository) {
    this.dataSourceRepository = dataSourceRepository;
    this.dataSourceSampleRepository = dataSourceSampleRepository;
  }

  public List<DataSource> getDataSource() {
    return dataSourceRepository.findAllByOrderByCreatedAtDesc();
  }
  
  public List<DataSource> getDataSourceByType(String modelType) {
    return dataSourceRepository.findByModelTypeOrderByCreatedAtDesc(modelType);
  }
  
  public List<DataSourceSample> getSamplesByDataSourceId(Long dataSourceId) {
    return dataSourceSampleRepository.findByDataSourceId(dataSourceId);
  }
  
  public List<DataSourceSample> getSamplesByIds(List<Long> sampleIds) {
    return dataSourceSampleRepository.findByIdIn(sampleIds);
  }
}
