package com.wangziyang.mes.common.controller.admin;

import com.wangziyang.mes.common.Result;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.UUID;

@RestController
@RequestMapping("/admin/common")
public class FileUploadController {

    private static final Logger LOGGER = LoggerFactory.getLogger(FileUploadController.class);

    @Value("${file.upload-dir:./upload}")
    private String uploadDir;

    @Value("${file.access-path:/upload}")
    private String accessPath;

    @PostMapping("/upload")
    public Result upload(@RequestParam("file") MultipartFile file) {
        if (file.isEmpty()) {
            return Result.failure("上传文件不能为空");
        }
        try {
            String originalFilename = file.getOriginalFilename();
            String ext = "";
            if (originalFilename != null && originalFilename.contains(".")) {
                ext = originalFilename.substring(originalFilename.lastIndexOf("."));
            }
            String datePath = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy/MM/dd"));
            String newFilename = UUID.randomUUID().toString().replace("-", "") + ext;

            File baseDir = new File(uploadDir).getAbsoluteFile();
            File destDir = new File(baseDir, datePath);
            if (!destDir.exists()) {
                destDir.mkdirs();
            }

            File destFile = new File(destDir, newFilename);
            file.transferTo(destFile.getAbsoluteFile());

            String url = accessPath + "/" + datePath + "/" + newFilename;
            return Result.success(url);
        } catch (IOException e) {
            LOGGER.error("文件上传失败", e);
            return Result.failure("文件上传失败: " + e.getMessage());
        }
    }
}
