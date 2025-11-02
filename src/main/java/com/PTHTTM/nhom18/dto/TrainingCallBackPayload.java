package com.PTHTTM.nhom18.dto;

import java.util.Map;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class TrainingCallBackPayload {
  private String status;
  private String errorMessage;
  private String modelPath;
  private Map<String, Double> metrics;
}
