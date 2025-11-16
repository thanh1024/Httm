package com.PTHTTM.nhom18.controller;

import com.PTHTTM.nhom18.model.DataSource;
import com.PTHTTM.nhom18.model.DataSourceSample;
import com.PTHTTM.nhom18.service.DataSourceService;
import com.PTHTTM.nhom18.service.UploadService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;

@Controller
@RequestMapping("/admin/data")
public class DataManagementController {
    
    private static final Logger logger = LoggerFactory.getLogger(DataManagementController.class);
    
    @Autowired
    private DataSourceService dataSourceService;
    
    @Autowired
    private UploadService uploadService;
    
    // ==================== DATASET MANAGEMENT ====================
    
    /**
     * Danh sách tất cả datasets
     */
    @GetMapping("/list")
    public String listDatasets(Model model) {
        List<DataSource> dataSources = dataSourceService.getAllDataSources();
        model.addAttribute("dataSources", dataSources);
        return "data-list";
    }
    
    /**
     * Form tạo mới dataset (manual)
     */
    @GetMapping("/new")
    public String newDatasetForm(Model model) {
        model.addAttribute("dataSource", new DataSource());
        model.addAttribute("mode", "create");
        return "data-form";
    }
    
    /**
     * Form sửa dataset
     */
    @GetMapping("/edit/{id}")
    public String editDatasetForm(@PathVariable Long id, Model model, RedirectAttributes redirectAttributes) {
        DataSource dataSource = dataSourceService.getDataSourceById(id);
        if (dataSource == null) {
            redirectAttributes.addFlashAttribute("error", "Dataset không tồn tại");
            return "redirect:/admin/data/list";
        }
        model.addAttribute("dataSource", dataSource);
        model.addAttribute("mode", "edit");
        return "data-form";
    }
    
    /**
     * Lưu dataset mới (manual)
     */
    @PostMapping("/save")
    public String saveDataset(
            @RequestParam("name") String name,
            RedirectAttributes redirectAttributes
    ) {
        try {
            // Validate
            if (name == null || name.trim().isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Tên dataset không được để trống");
                return "redirect:/admin/data/new";
            }
            
            // Tạo dataset mới
            DataSource dataSource = dataSourceService.createDataSourceManual(name);
            
            redirectAttributes.addFlashAttribute("success", "Tạo dataset thành công");
            // Redirect đến trang thêm mẫu
            return "redirect:/admin/data/samples/" + dataSource.getId();
            
        } catch (Exception e) {
            logger.error("Error creating dataset", e);
            redirectAttributes.addFlashAttribute("error", "Lỗi khi tạo dataset: " + e.getMessage());
            return "redirect:/admin/data/new";
        }
    }
    
    /**
     * Cập nhật dataset
     */
    @PostMapping("/update/{id}")
    public String updateDataset(
            @PathVariable Long id,
            @RequestParam("name") String name,
            RedirectAttributes redirectAttributes
    ) {
        try {
            DataSource dataSource = dataSourceService.getDataSourceById(id);
            if (dataSource == null) {
                redirectAttributes.addFlashAttribute("error", "Dataset không tồn tại");
                return "redirect:/admin/data/list";
            }
            
            // Validate
            if (name == null || name.trim().isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Tên dataset không được để trống");
                return "redirect:/admin/data/edit/" + id;
            }
            
            dataSource.setName(name);
            dataSourceService.updateDataSource(dataSource);
            
            redirectAttributes.addFlashAttribute("success", "Cập nhật dataset thành công");
            return "redirect:/admin/data/list";
            
        } catch (Exception e) {
            logger.error("Error updating dataset", e);
            redirectAttributes.addFlashAttribute("error", "Lỗi khi cập nhật dataset: " + e.getMessage());
            return "redirect:/admin/data/edit/" + id;
        }
    }
    
    /**
     * Xóa dataset
     */
    @PostMapping("/delete/{id}")
    public String deleteDataset(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            DataSource dataSource = dataSourceService.getDataSourceById(id);
            if (dataSource == null) {
                redirectAttributes.addFlashAttribute("error", "Dataset không tồn tại");
                return "redirect:/admin/data/list";
            }
            
            dataSourceService.deleteDataSource(id);
            redirectAttributes.addFlashAttribute("success", "Xóa dataset thành công");
            
        } catch (Exception e) {
            logger.error("Error deleting dataset", e);
            redirectAttributes.addFlashAttribute("error", "Lỗi khi xóa dataset: " + e.getMessage());
        }
        return "redirect:/admin/data/list";
    }
    
    /**
     * Import CSV vào dataset
     */
    @PostMapping("/import")
    public String importCsv(
            @RequestParam("name") String name,
            @RequestParam("file") MultipartFile file,
            RedirectAttributes redirectAttributes
    ) {
        try {
            // Validate
            if (name == null || name.trim().isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Tên dataset không được để trống");
                return "redirect:/admin/data/list";
            }
            
            if (file.isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Vui lòng chọn file CSV");
                return "redirect:/admin/data/list";
            }
            
            // Upload và parse CSV
            DataSource dataSource = uploadService.saveUploadedFile(name, file);
            
            redirectAttributes.addFlashAttribute("success", 
                "Import CSV thành công. Dataset '" + dataSource.getName() + "' đã có " + dataSource.getSamples().size() + " mẫu");
            
            return "redirect:/admin/data/samples/" + dataSource.getId();
            
        } catch (IOException e) {
            logger.error("Error importing CSV", e);
            redirectAttributes.addFlashAttribute("error", "Lỗi khi import CSV: " + e.getMessage());
            return "redirect:/admin/data/list";
        }
    }
    
    // ==================== SAMPLE MANAGEMENT ====================
    
    /**
     * Danh sách samples của dataset
     */
    @GetMapping("/samples/{dataSourceId}")
    public String listSamples(@PathVariable Long dataSourceId, Model model, RedirectAttributes redirectAttributes) {
        DataSource dataSource = dataSourceService.getDataSourceById(dataSourceId);
        if (dataSource == null) {
            redirectAttributes.addFlashAttribute("error", "Dataset không tồn tại");
            return "redirect:/admin/data/list";
        }
        
        List<DataSourceSample> samples = dataSourceService.getSamplesByDataSourceId(dataSourceId);
        
        model.addAttribute("dataSource", dataSource);
        model.addAttribute("samples", samples);
        return "sample-list";
    }
    
    /**
     * Form thêm mẫu mới
     */
    @GetMapping("/samples/{dataSourceId}/new")
    public String newSampleForm(@PathVariable Long dataSourceId, Model model, RedirectAttributes redirectAttributes) {
        DataSource dataSource = dataSourceService.getDataSourceById(dataSourceId);
        if (dataSource == null) {
            redirectAttributes.addFlashAttribute("error", "Dataset không tồn tại");
            return "redirect:/admin/data/list";
        }
        
        model.addAttribute("dataSource", dataSource);
        model.addAttribute("sample", new DataSourceSample());
        model.addAttribute("mode", "create");
        return "sample-form";
    }
    
    /**
     * Form sửa mẫu
     */
    @GetMapping("/samples/edit/{sampleId}")
    public String editSampleForm(@PathVariable Long sampleId, Model model, RedirectAttributes redirectAttributes) {
        DataSourceSample sample = dataSourceService.getSampleById(sampleId);
        if (sample == null) {
            redirectAttributes.addFlashAttribute("error", "Mẫu không tồn tại");
            return "redirect:/admin/data/list";
        }
        
        model.addAttribute("dataSource", sample.getDataSource());
        model.addAttribute("sample", sample);
        model.addAttribute("mode", "edit");
        return "sample-form";
    }
    
    /**
     * Lưu mẫu mới
     */
    @PostMapping("/samples/{dataSourceId}/save")
    public String saveSample(
            @PathVariable Long dataSourceId,
            @RequestParam("text") String text,
            @RequestParam(value = "rating", required = false) Integer rating,
            @RequestParam(value = "label", required = false) String label,
            RedirectAttributes redirectAttributes
    ) {
        try {
            DataSource dataSource = dataSourceService.getDataSourceById(dataSourceId);
            if (dataSource == null) {
                redirectAttributes.addFlashAttribute("error", "Dataset không tồn tại");
                return "redirect:/admin/data/list";
            }
            
            // Validate
            if (text == null || text.trim().isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Nội dung mẫu không được để trống");
                return "redirect:/admin/data/samples/" + dataSourceId + "/new";
            }
            
            // Validate rating or label
            if ((rating == null || rating == 0) && (label == null || label.trim().isEmpty())) {
                redirectAttributes.addFlashAttribute("error", "Phải nhập Rating hoặc Label");
                return "redirect:/admin/data/samples/" + dataSourceId + "/new";
            }
            
            // Tạo sample mới
            DataSourceSample sample = new DataSourceSample();
            sample.setDataSource(dataSource);
            sample.setText(text.trim());
            sample.setRating(rating != null && rating > 0 ? rating : null);
            sample.setLabel(label != null && !label.trim().isEmpty() ? label.trim() : null);
            sample.setRowIndex(null);
            sample.setCreatedAt(LocalDateTime.now());
            
            dataSourceService.saveSample(sample);
            
            redirectAttributes.addFlashAttribute("success", "Thêm mẫu thành công");
            return "redirect:/admin/data/samples/" + dataSourceId;
            
        } catch (Exception e) {
            logger.error("Error saving sample", e);
            redirectAttributes.addFlashAttribute("error", "Lỗi khi lưu mẫu: " + e.getMessage());
            return "redirect:/admin/data/samples/" + dataSourceId + "/new";
        }
    }
    
    /**
     * Cập nhật mẫu
     */
    @PostMapping("/samples/update/{sampleId}")
    public String updateSample(
            @PathVariable Long sampleId,
            @RequestParam("text") String text,
            @RequestParam(value = "rating", required = false) Integer rating,
            @RequestParam(value = "label", required = false) String label,
            RedirectAttributes redirectAttributes
    ) {
        try {
            DataSourceSample sample = dataSourceService.getSampleById(sampleId);
            if (sample == null) {
                redirectAttributes.addFlashAttribute("error", "Mẫu không tồn tại");
                return "redirect:/admin/data/list";
            }
            
            Long dataSourceId = sample.getDataSource().getId();
            
            // Validate
            if (text == null || text.trim().isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Nội dung mẫu không được để trống");
                return "redirect:/admin/data/samples/edit/" + sampleId;
            }
            
            // Validate rating or label
            if ((rating == null || rating == 0) && (label == null || label.trim().isEmpty())) {
                redirectAttributes.addFlashAttribute("error", "Phải nhập Rating hoặc Label");
                return "redirect:/admin/data/samples/edit/" + sampleId;
            }
            
            // Update sample
            sample.setText(text.trim());
            sample.setRating(rating != null && rating > 0 ? rating : null);
            sample.setLabel(label != null && !label.trim().isEmpty() ? label.trim() : null);
            
            dataSourceService.updateSample(sample);
            
            redirectAttributes.addFlashAttribute("success", "Cập nhật mẫu thành công");
            return "redirect:/admin/data/samples/" + dataSourceId;
            
        } catch (Exception e) {
            logger.error("Error updating sample", e);
            redirectAttributes.addFlashAttribute("error", "Lỗi khi cập nhật mẫu: " + e.getMessage());
            return "redirect:/admin/data/samples/edit/" + sampleId;
        }
    }
    
    /**
     * Xóa mẫu
     */
    @PostMapping("/samples/delete/{sampleId}")
    public String deleteSample(@PathVariable Long sampleId, RedirectAttributes redirectAttributes) {
        try {
            DataSourceSample sample = dataSourceService.getSampleById(sampleId);
            if (sample == null) {
                redirectAttributes.addFlashAttribute("error", "Mẫu không tồn tại");
                return "redirect:/admin/data/list";
            }
            
            Long dataSourceId = sample.getDataSource().getId();
            
            dataSourceService.deleteSample(sampleId);
            
            redirectAttributes.addFlashAttribute("success", "Xóa mẫu thành công");
            return "redirect:/admin/data/samples/" + dataSourceId;
            
        } catch (Exception e) {
            logger.error("Error deleting sample", e);
            redirectAttributes.addFlashAttribute("error", "Lỗi khi xóa mẫu: " + e.getMessage());
            return "redirect:/admin/data/list";
        }
    }
}
