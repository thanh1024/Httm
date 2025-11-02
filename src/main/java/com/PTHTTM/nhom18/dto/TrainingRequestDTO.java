package com.PTHTTM.nhom18.dto;

import java.util.List;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class TrainingRequestDTO {
  private Long jobId;
  private String versionName;
  private List<Long> dataSourceIds;
  private String modelType;  // "general" or "aspect" - REQUIRED
  private Integer epochs = 10;
  private Integer batchSize = 4;
}
