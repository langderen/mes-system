package com.wangziyang.mes.warehouse.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.wangziyang.mes.warehouse.entity.SpWarehouseLocation;
import com.wangziyang.mes.warehouse.mapper.SpWarehouseLocationMapper;
import com.wangziyang.mes.warehouse.service.ISpWarehouseLocationService;
import org.springframework.stereotype.Service;

@Service
public class SpWarehouseLocationServiceImpl extends ServiceImpl<SpWarehouseLocationMapper, SpWarehouseLocation> implements ISpWarehouseLocationService {

    @Override
    public IPage<SpWarehouseLocation> pageByWarehouseId(IPage<SpWarehouseLocation> page, String warehouseId) {
        return this.page(page, new QueryWrapper<SpWarehouseLocation>()
                .eq("warehouse_id", warehouseId)
                .eq("is_deleted", "0")
                .orderByAsc("row_no", "col_no"));
    }
}