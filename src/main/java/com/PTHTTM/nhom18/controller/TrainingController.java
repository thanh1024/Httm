package com.PTHTTM.nhom18.controller;

import com.PTHTTM.nhom18.model.DataSource;
import com.PTHTTM.nhom18.model.ModelVersion;
import com.PTHTTM.nhom18.model.TrainingJob;
import com.PTHTTM.nhom18.model.TrainingResult;
import com.PTHTTM.nhom18.service.DataSourceService;
import com.PTHTTM.nhom18.service.ModelVersionService;
import com.PTHTTM.nhom18.service.TrainingJobService;
import com.PTHTTM.nhom18.service.TrainingResultService;
import java.util.List;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/admin/training")
public class TrainingController {
  private final DataSourceService dataSourceService;
  private final TrainingJobService trainingJobService;
  private final TrainingResultService trainingResultService;
  private final ModelVersionService modelVersionService;

  public TrainingController(
      DataSourceService dataSourceService,
      TrainingJobService jobService,
      TrainingResultService resultService,
      ModelVersionService modelVersionService) {
    this.dataSourceService = dataSourceService;
    this.trainingJobService = jobService;
    this.trainingResultService = resultService;
    this.modelVersionService = modelVersionService;
  }

  @GetMapping("/form")
  public String trainingPage(
      @RequestParam(value = "modelType", required = false) String modelType,
      Model model
  ) {
    List<DataSource> sourceList;
    
    if (modelType != null && !modelType.isEmpty()) {
      sourceList = this.dataSourceService.getDataSourceByType(modelType);
    } else {
      sourceList = this.dataSourceService.getDataSource();
    }
    
    model.addAttribute("dataSources", sourceList);
    model.addAttribute("selectedModelType", modelType);

    return "training-form";
  }

  @PostMapping("/start")
  public String startTraining(
      @RequestParam("versionName") String versionName,
      @RequestParam(value = "dataSourceIds", required = false) List<Long> dataSourceIds,
      @RequestParam("modelType") String modelType,
      RedirectAttributes redirectAttributes
  ){
    if (versionName == null || versionName.trim().isEmpty()) {
      redirectAttributes.addFlashAttribute("error", "Vui lòng nhập tên phiên bản model");
      return "redirect:/admin/training/form";
    }

    if (modelType == null || modelType.trim().isEmpty()) {
      redirectAttributes.addFlashAttribute("error", "Vui lòng chọn loại model (General hoặc Aspect)");
      return "redirect:/admin/training/form";
    }

    if (dataSourceIds == null || dataSourceIds.isEmpty()) {
      redirectAttributes.addFlashAttribute("error", "Vui lòng chọn ít nhất một nguồn dữ liệu để huấn luyện");
      return "redirect:/admin/training/form";
    }

    TrainingJob job = trainingJobService.createTrainingJob(versionName, dataSourceIds, modelType);
    return  "redirect:/admin/training/status/" + job.getId();
  }

  @GetMapping("/status/{jobId}")
  public String showStatus(@PathVariable Long jobId, Model model,  RedirectAttributes redirectAttributes) {
    TrainingJob job = trainingJobService.findById(jobId);

    if (job == null) {
      redirectAttributes.addFlashAttribute("error", "Job not found");
      return "redirect:/admin/training/form";
    }

    model.addAttribute("job", job);

    if ("COMPLETED".equalsIgnoreCase(job.getStatus()) || "FAILED".equalsIgnoreCase(job.getStatus())) {
      return "redirect:/admin/training/result/" + jobId;
    }

    return  "training-status";
  }

  @GetMapping("/result/{jobId}")
  public String showTrainingResult(@PathVariable Long jobId, Model model, RedirectAttributes redirectAttributes) {
    TrainingJob job = trainingJobService.findById(jobId);

    if (job == null) {
      redirectAttributes.addFlashAttribute("error", "Training Job with ID " + jobId + " not found.");
      return "redirect:/admin/training/form";
    }

    TrainingResult result = null;
    if ("COMPLETED".equalsIgnoreCase(job.getStatus())) {
      result = trainingResultService.findByJob(job);
    }

    model.addAttribute("job", job);
    model.addAttribute("result", result);

    return "training-result";
  }

  @PostMapping("/approve/{jobId}")
  public String approveModel(@PathVariable Long jobId, RedirectAttributes redirectAttributes) {
    TrainingJob job = trainingJobService.findById(jobId);
    if (job == null || !"COMPLETED".equalsIgnoreCase(job.getStatus())) {
      redirectAttributes.addFlashAttribute("error", "Cannot approve: Job not found or not completed.");
      return "redirect:/admin/training/result/" + jobId;
    }

    ModelVersion versionToActivate = job.getModelVersion();
    if (versionToActivate == null) {
      redirectAttributes.addFlashAttribute("error", "Cannot approve: Missing model version link.");
      return "redirect:/admin/training/result/" + jobId;
    }

    try {
      boolean success = modelVersionService.activateVersion(versionToActivate.getId());

      if (success) {
        redirectAttributes.addFlashAttribute("message", "Model '" + versionToActivate.getName() + "' approved and activated successfully!");
      } else {
        redirectAttributes.addFlashAttribute("error", "Failed to activate model on the ML service (Python). Check service logs. Database state might be inconsistent.");
      }
    } catch (Exception e) {
      redirectAttributes.addFlashAttribute("error", "Error approving model: " + e.getMessage());
    }
    return "redirect:/admin/training/form";
  }
}
