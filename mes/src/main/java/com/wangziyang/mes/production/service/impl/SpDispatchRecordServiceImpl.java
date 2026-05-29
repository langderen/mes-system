package com.wangziyang.mes.production.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.wangziyang.mes.production.entity.SpDispatchRecord;
import com.wangziyang.mes.production.mapper.SpDispatchRecordMapper;
import com.wangziyang.mes.production.service.ISpDispatchRecordService;
import org.springframework.stereotype.Service;

@Service
public class SpDispatchRecordServiceImpl extends ServiceImpl<SpDispatchRecordMapper, SpDispatchRecord> implements ISpDispatchRecordService {
}