package com.PTHTTM.nhom18.service;

import com.PTHTTM.nhom18.model.DataSource;
import com.PTHTTM.nhom18.model.DataSourceSample;
import com.PTHTTM.nhom18.repository.DataSourceRepository;
import com.PTHTTM.nhom18.repository.DataSourceSampleRepository;
import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

@Service
public class UploadService {
  private static final Logger logger = LoggerFactory.getLogger(UploadService.class);
  
  private final DataSourceRepository dataSourceRepository;
  private final DataSourceSampleRepository dataSourceSampleRepository;
  private final Path fileStorageLocation;


  public UploadService(
      DataSourceRepository dataSourceRepository,
      DataSourceSampleRepository dataSourceSampleRepository,
      @Value("${data.upload.dir}") String uploadDir) {
    this.dataSourceRepository = dataSourceRepository;
    this.dataSourceSampleRepository = dataSourceSampleRepository;

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
    dataSource.setModelType(modelType);
    
    DataSource savedDataSource = dataSourceRepository.save(dataSource);
    
    // Parse CSV và lưu từng dòng vào database
    parseAndSaveCSVSamples(file, savedDataSource);
    
    logger.info("Đã lưu dataset {} với {} mẫu", savedDataSource.getName(), 
                savedDataSource.getSamples().size());
    
    return savedDataSource;
  }
  
  private void parseAndSaveCSVSamples(MultipartFile file, DataSource dataSource) throws IOException {
    List<DataSourceSample> samples = new ArrayList<>();
    
    try (BufferedReader reader = new BufferedReader(
            new InputStreamReader(file.getInputStream(), StandardCharsets.UTF_8))) {
      
      String line;
      int rowIndex = 0;
      String[] headers = null;
      
      // Đọc header (dòng đầu tiên)
      String headerLine = reader.readLine();
      if (headerLine != null) {
        headers = parseCSVLine(headerLine);
      }
      
      // Tìm index của các cột cần thiết
      int textColIndex = -1;
      int ratingColIndex = -1;
      int labelColIndex = -1;
      
      if (headers != null) {
        for (int i = 0; i < headers.length; i++) {
          String header = headers[i].trim().toLowerCase();
          if (header.equals("text") || header.equals("content") || header.equals("comment")) {
            textColIndex = i;
          } else if (header.equals("rating")) {
            ratingColIndex = i;
          } else if (header.equals("label")) {
            labelColIndex = i;
          }
        }
      }
      
      // Nếu không tìm thấy header, giả định cột đầu là text
      if (textColIndex == -1) {
        textColIndex = 0;
      }
      
      // Đọc các dòng dữ liệu
      while ((line = reader.readLine()) != null) {
        if (line.trim().isEmpty()) {
          continue;
        }
        
        String[] columns = parseCSVLine(line);
        
        if (columns.length <= textColIndex) {
          continue;
        }
        
        String text = columns[textColIndex].trim();
        if (text.isEmpty()) {
          continue;
        }
        
        DataSourceSample sample = new DataSourceSample();
        sample.setDataSource(dataSource);
        sample.setText(text);
        sample.setRowIndex(rowIndex++);
        
        // Lấy rating nếu có
        if (ratingColIndex >= 0 && ratingColIndex < columns.length) {
          try {
            String ratingStr = columns[ratingColIndex].trim();
            if (!ratingStr.isEmpty()) {
              sample.setRating(Integer.parseInt(ratingStr));
            }
          } catch (NumberFormatException e) {
            // Ignore invalid rating
          }
        }
        
        // Lấy label nếu có
        if (labelColIndex >= 0 && labelColIndex < columns.length) {
          sample.setLabel(columns[labelColIndex].trim());
        }
        
        samples.add(sample);
        
        // Batch save mỗi 100 records để tránh memory issue
        if (samples.size() >= 100) {
          dataSourceSampleRepository.saveAll(samples);
          samples.clear();
        }
      }
      
      // Lưu các records còn lại
      if (!samples.isEmpty()) {
        dataSourceSampleRepository.saveAll(samples);
      }
      
      logger.info("Đã parse và lưu {} mẫu từ file {}", rowIndex, file.getOriginalFilename());
    }
  }
  
  /**
   * Parse một dòng CSV, hỗ trợ các separator: |, ,, \t
   */
  private String[] parseCSVLine(String line) {
    // Thử các separator theo thứ tự: |, ,, \t
    // Lưu ý: | là special character trong regex, cần escape bằng Pattern.quote()
    String[] separators = {"|", ",", "\t"};
    
    for (String sep : separators) {
      // Escape separator để dùng như literal string trong regex
      String escapedSep = java.util.regex.Pattern.quote(sep);
      String[] parts = line.split(escapedSep, -1);
      if (parts.length > 1) {
        // Clean up từng phần
        for (int i = 0; i < parts.length; i++) {
          parts[i] = parts[i].trim().replace("\"", "").replace("'", "");
        }
        return parts;
      }
    }
    
    // Nếu không tìm thấy separator, trả về toàn bộ dòng
    return new String[]{line.trim()};
  }
}