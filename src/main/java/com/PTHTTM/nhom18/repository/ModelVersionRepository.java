package com.PTHTTM.nhom18.repository;

import com.PTHTTM.nhom18.model.ModelVersion;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ModelVersionRepository extends JpaRepository<ModelVersion, Long> {

  List<ModelVersion> findByActive(boolean active);
  
  List<ModelVersion> findByActiveAndModelType(boolean active, String modelType);
}
