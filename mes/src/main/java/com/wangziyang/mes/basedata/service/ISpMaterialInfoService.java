package com.wangziyang.mes.basedata.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.wangziyang.mes.basedata.entity.SpMaterialInfo;

public interface ISpMaterialInfoService extends IService<SpMaterialInfo> {

    String generateMaterialCode();

}