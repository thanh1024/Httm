package com.PTHTTM.nhom18.service;

import com.PTHTTM.nhom18.model.DataSource;
import com.PTHTTM.nhom18.repository.DataSourceRepository;
import java.io.File;
import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths; // <-- Thêm import này
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

@Service
public class UploadService {
  private final DataSourceRepository dataSourceRepository;
  private final Path fileStorageLocation;


  public UploadService(DataSourceRepository dataSourceRepository,
      @Value("${data.upload.dir}") String uploadDir) {
    this.dataSourceRepository = dataSourceRepository;

    this.fileStorageLocation = Paths.get(uploadDir).toAbsolutePath().normalize();

    try {
      File dir = new File(uploadDir);
      if (!dir.exists()) {
        dir.mkdirs();
      }
    } catch (Exception e) {
      throw new RuntimeException("Không thể tạo thư mục upload: " + uploadDir, e);
    }
  }

  @Transactional
  public DataSource saveUploadedFile(String name, MultipartFile file, String modelType) throws IOException {
    String fileName = file.getOriginalFilename();

    Path targetFilePath = this.fileStorageLocation.resolve(fileName);

    file.transferTo(targetFilePath);

    DataSource dataSource = new DataSource();
    dataSource.setName(name);
    dataSource.setFileUrl(targetFilePath.toString());
    dataSource.setModelType(modelType);  // ✅ Thêm modelType

    return dataSourceRepository.save(dataSource);
  }
}