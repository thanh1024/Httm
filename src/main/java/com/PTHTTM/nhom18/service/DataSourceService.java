package com.PTHTTM.nhom18.service;

import com.PTHTTM.nhom18.model.DataSource;
import com.PTHTTM.nhom18.repository.DataSourceRepository;
import java.util.List;
import org.springframework.stereotype.Service;

@Service
public class DataSourceService {
  private final DataSourceRepository dataSourceRepository;

  public DataSourceService(DataSourceRepository dataSourceRepository) {
    this.dataSourceRepository = dataSourceRepository;
  }

  public List<DataSource> getDataSource() {
    return dataSourceRepository.findAllByOrderByCreatedAtDesc();
  }
  
  public List<DataSource> getDataSourceByType(String modelType) {
    return dataSourceRepository.findByModelTypeOrderByCreatedAtDesc(modelType);
  }
}
