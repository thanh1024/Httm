package com.PTHTTM.nhom18.controller;

import com.PTHTTM.nhom18.service.UploadService;
import java.io.IOException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/admin/data")
public class ReviewController {
  private final UploadService uploadService;

  public ReviewController(UploadService uploadService) {
    this.uploadService = uploadService;
  }

  @GetMapping("/upload")
  public String showUploadForm(Model model) {
    return "upload-form";
  }

  @PostMapping("/upload")
  public String handleUpload(
      @RequestParam("file")MultipartFile file,
      @RequestParam("dataSourceName") String name,
      @RequestParam("modelType") String modelType,  // ✅ Thêm modelType
      RedirectAttributes redirectAttributes
  ) throws IOException {

    if (file.isEmpty()) {
      redirectAttributes.addFlashAttribute("error", "File is empty");
      return "redirect:/admin/data/upload";
    }

    if (name == null || name.trim().isEmpty()) {
      redirectAttributes.addFlashAttribute("error", "Please provide a name for the data source.");
      return "redirect:/admin/data/upload";
    }

    if (modelType == null || modelType.trim().isEmpty()) {
      redirectAttributes.addFlashAttribute("error", "Vui lòng chọn loại model (General hoặc Aspect)");
      return "redirect:/admin/data/upload";
    }

    this.uploadService.saveUploadedFile(name, file, modelType);
    redirectAttributes.addFlashAttribute("message", "Upload thành công!");
    return "redirect:/admin/data/upload";
  }


}
