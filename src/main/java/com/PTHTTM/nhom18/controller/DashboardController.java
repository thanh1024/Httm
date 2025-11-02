package com.PTHTTM.nhom18.controller;

import com.PTHTTM.nhom18.model.ModelVersion;
import com.PTHTTM.nhom18.model.TrainingResult;
import com.PTHTTM.nhom18.model.DataSource;
import com.PTHTTM.nhom18.service.ModelVersionService;
import com.PTHTTM.nhom18.service.TrainingResultService;
import com.PTHTTM.nhom18.service.TrainingJobService;
import com.PTHTTM.nhom18.service.DataSourceService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.ArrayList;

@Controller
@RequestMapping("/admin")
public class DashboardController {
  private final ModelVersionService  modelVersionService;
  private final TrainingResultService trainingResultService;
  private final TrainingJobService trainingJobService;
  private final DataSourceService dataSourceService;

  public DashboardController(ModelVersionService modelVersionService, TrainingResultService trainingResultService, TrainingJobService trainingJobService, DataSourceService dataSourceService) {
    this.modelVersionService = modelVersionService;
    this.trainingResultService = trainingResultService;
    this.trainingJobService = trainingJobService;
    this.dataSourceService = dataSourceService;
  }

  @GetMapping(value = {"", "/", "/dashboard"})
  public String dashboard(Model model, RedirectAttributes redirectAttributes) {
    // Get active GENERAL model
    ModelVersion generalModel = modelVersionService.findActiveModelByType("general");
    TrainingResult generalResult = null;
    List<DataSource> generalDataSources = new ArrayList<>();
    if (generalModel != null && generalModel.getTrainingJob() != null) {
      generalResult = trainingResultService.findByJob(generalModel.getTrainingJob());
      // Get data sources used for training
      generalDataSources = trainingJobService.getDataSourcesUsedForTraining(generalModel.getTrainingJob().getId());
    }
    
    // Get active ASPECT model
    ModelVersion aspectModel = modelVersionService.findActiveModelByType("aspect");
    TrainingResult aspectResult = null;
    List<DataSource> aspectDataSources = new ArrayList<>();
    if (aspectModel != null && aspectModel.getTrainingJob() != null) {
      aspectResult = trainingResultService.findByJob(aspectModel.getTrainingJob());
      // Get data sources used for training
      aspectDataSources = trainingJobService.getDataSourcesUsedForTraining(aspectModel.getTrainingJob().getId());
    }

    model.addAttribute("generalModel", generalModel);
    model.addAttribute("generalResult", generalResult);
    model.addAttribute("generalDataSources", generalDataSources);
    model.addAttribute("aspectModel", aspectModel);
    model.addAttribute("aspectResult", aspectResult);
    model.addAttribute("aspectDataSources", aspectDataSources);
    return "dashboard";
  }
}
