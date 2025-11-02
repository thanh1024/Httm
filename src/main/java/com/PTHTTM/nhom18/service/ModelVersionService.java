package com.PTHTTM.nhom18.service;

import com.PTHTTM.nhom18.model.ModelVersion;
import com.PTHTTM.nhom18.repository.ModelVersionRepository;
import java.util.List;
import java.util.Optional;
import org.springframework.stereotype.Service;

@Service
public class ModelVersionService {
  private final ModelVersionRepository modelVersionRepository;

  public ModelVersionService(ModelVersionRepository modelVersionRepository) {
    this.modelVersionRepository = modelVersionRepository;
  }

  public ModelVersion createVersion(String versionName) {
    throw new IllegalArgumentException("modelType is required. Use createVersion(versionName, modelType)");
  }

  public ModelVersion createVersion(String versionName, String modelType) {
    if (modelType == null || modelType.isEmpty()) {
      throw new IllegalArgumentException("modelType cannot be null or empty");
    }
    
    ModelVersion modelVersion = new ModelVersion();
    modelVersion.setName(versionName);
    modelVersion.setModelType(modelType);
    modelVersion.setActive(false);

    return modelVersionRepository.save(modelVersion);
  }


  public boolean activateVersion(long id) {
    Optional<ModelVersion> modelVersion = modelVersionRepository.findById(id);

    if (modelVersion.isEmpty()){
      return false;
    }

    ModelVersion newVersion = modelVersion.get();
    if (newVersion.getCheckpointUrl() == null || newVersion.getCheckpointUrl().isEmpty()){
      System.out.println("There is no checkpoint for this version. Url is empty");
      return false;
    }

    List<ModelVersion> currentActiveModel = modelVersionRepository.findByActive(true);

    for  (ModelVersion modelVersion1 : currentActiveModel) {
      if (modelVersion1.getId() != id) {
        modelVersion1.setActive(false);
        modelVersionRepository.save(modelVersion1);
      }
    }

    newVersion.setActive(true);
    modelVersionRepository.save(newVersion);

    // Không cần gọi Python API - chỉ cần update DB là đủ
    return true;
  }

  public void deleteVersion(long id) {
    this.modelVersionRepository.deleteById(id);
  }

  public ModelVersion findActiveModelVersion() {
    List<ModelVersion> activeVersions = this.modelVersionRepository.findByActive(true);
    if (activeVersions.isEmpty()) {
      return null;  // Hoặc throw exception tùy logic
    }
    return activeVersions.get(0);
  }
  
  public ModelVersion findActiveModelByType(String modelType) {
    List<ModelVersion> activeVersions = this.modelVersionRepository.findByActiveAndModelType(true, modelType);
    if (activeVersions.isEmpty()) {
      return null;
    }
    return activeVersions.get(0);
  }
}
