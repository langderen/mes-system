package com.wangziyang.mes.order.mrp.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.wangziyang.mes.order.mrp.entity.SpMrpRecord;
import com.wangziyang.mes.order.mrp.mapper.SpMrpRecordMapper;
import com.wangziyang.mes.order.mrp.service.ISpMrpRecordService;
import org.springframework.stereotype.Service;

@Service
public class SpMrpRecordServiceImpl extends ServiceImpl<SpMrpRecordMapper, SpMrpRecord> implements ISpMrpRecordService {
}
