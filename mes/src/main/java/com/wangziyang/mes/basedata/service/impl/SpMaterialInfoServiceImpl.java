package com.wangziyang.mes.basedata.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.wangziyang.mes.basedata.entity.SpMaterialInfo;
import com.wangziyang.mes.basedata.mapper.SpMaterialInfoMapper;
import com.wangziyang.mes.basedata.service.ISpMaterialInfoService;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

@Service
public class SpMaterialInfoServiceImpl extends ServiceImpl<SpMaterialInfoMapper, SpMaterialInfo> implements ISpMaterialInfoService {

    @Override
    public String generateMaterialCode() {
        String datePrefix = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
        QueryWrapper<SpMaterialInfo> qw = new QueryWrapper<>();
        qw.likeRight("code", datePrefix);
        qw.orderByDesc("code");
        qw.last("limit 1");
        SpMaterialInfo last = getOne(qw);
        if (last != null && last.getCode() != null && last.getCode().startsWith(datePrefix)) {
            String suffix = last.getCode().substring(datePrefix.length());
            int seq = Integer.parseInt(suffix) + 1;
            return datePrefix + String.format("%04d", seq);
        }
        return datePrefix + "0001";
    }
}