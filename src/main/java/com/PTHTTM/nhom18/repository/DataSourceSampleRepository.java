package com.PTHTTM.nhom18.repository;

import com.PTHTTM.nhom18.model.DataSourceSample;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface DataSourceSampleRepository extends JpaRepository<DataSourceSample, Long> {
    List<DataSourceSample> findByDataSourceId(Long dataSourceId);
    
    List<DataSourceSample> findByIdIn(List<Long> sampleIds);
    
    void deleteByDataSourceId(Long dataSourceId);
}






