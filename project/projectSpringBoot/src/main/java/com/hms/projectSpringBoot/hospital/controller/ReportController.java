package com.hms.projectSpringBoot.hospital.controller;

import com.hms.projectSpringBoot.hospital.entity.Report;
import com.hms.projectSpringBoot.hospital.service.ReportService;
import com.hms.projectSpringBoot.util.ApiResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/reports")
public class ReportController {

    @Autowired
    private ReportService reportService;

    @GetMapping("/all")
    public ApiResponse getAllReports() {
        return reportService.getAllReports();
    }

    @PostMapping("/create")
    public ApiResponse createReport(@RequestBody Report report) {
        return reportService.createReport(report);
    }

    @PutMapping("/update/{id}")
    public ApiResponse updateReport(@PathVariable Long id, @RequestBody Report updatedReport) {
        return reportService.updateReport(id, updatedReport);
    }

    @DeleteMapping("/delete/{id}")
    public ApiResponse deleteReport(@PathVariable Long id) {
        return reportService.deleteReport(id);
    }

    @GetMapping("/{id}")
    public ApiResponse getReportById(@PathVariable Long id) {
        return reportService.getReportById(id);
    }

    @GetMapping("/test/{testId}")
    public List<Report> getReportsByTestId(@PathVariable Long testId) {
        return reportService.getReportsByTestId(testId);
    }

    @GetMapping("/patient/{patientId}")
    public List<Report> getReportsByPatientId(@PathVariable Long patientId) {
        return reportService.getReportsByPatientId(patientId);
    }
}
