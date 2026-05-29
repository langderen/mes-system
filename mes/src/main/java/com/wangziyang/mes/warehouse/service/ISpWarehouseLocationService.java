package com.wangziyang.mes.warehouse.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.wangziyang.mes.warehouse.entity.SpWarehouseLocation;

public interface ISpWarehouseLocationService extends IService<SpWarehouseLocation> {

    IPage<SpWarehouseLocation> pageByWarehouseId(IPage<SpWarehouseLocation> page, String warehouseId);

}