package com.hms.projectSpringBoot.hospital.controller;

import com.hms.projectSpringBoot.hospital.entity.Medicine;
import com.hms.projectSpringBoot.hospital.service.MedicineService;
import com.hms.projectSpringBoot.util.ApiResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/medicines")
@CrossOrigin(origins = "*")
public class MedicineController {

    @Autowired
    private MedicineService medicineService;

    @GetMapping("/all")
    public ApiResponse getAllMedicines() {
        return medicineService.getAllMedicines();
    }
    @PostMapping("/create")
    public ApiResponse createMedicine(@RequestBody Medicine medicine) {
        return medicineService.saveMedicine(medicine);
    }

    @PutMapping("/update/{id}")
    public ApiResponse updateMedicine(@PathVariable Long id, @RequestBody Medicine medicine) {
        return medicineService.updateMedicine(id, medicine);
    }

    @DeleteMapping("/delete/{id}")
    public ApiResponse deleteMedicine(@PathVariable Long id) {
        return medicineService.deleteMedicine(id);
    }

    @GetMapping("/{id}")
    public ApiResponse getMedicineById(@PathVariable Long id) {
        return medicineService.getMedicineById(id);
    }

    @GetMapping("/manufacturer/{manufacturerId}")
    public ApiResponse getMedicinesByManufacturer(@PathVariable Long manufacturerId) {
        return medicineService.getMedicinesByManufacturer(manufacturerId);
    }

    @PutMapping("/{id}/add-stock")
    public ApiResponse addStock(@PathVariable Long id, @RequestParam int quantity) {
        return medicineService.addStock(id, quantity);
    }

    @PutMapping("/{id}/subtract-stock")
    public ApiResponse subtractStock(@PathVariable Long id, @RequestParam int quantity) {
        return medicineService.subtractStock(id, quantity);
    }

    @GetMapping("/searchByName")
    public ApiResponse searchMedicinesByName(@RequestParam String name) {
        return medicineService.searchMedicinesByName(name);
    }
}
