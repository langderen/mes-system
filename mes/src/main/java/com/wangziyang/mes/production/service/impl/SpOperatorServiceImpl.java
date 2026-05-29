package com.wangziyang.mes.production.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.wangziyang.mes.production.entity.SpOperator;
import com.wangziyang.mes.production.mapper.SpOperatorMapper;
import com.wangziyang.mes.production.service.ISpOperatorService;
import org.springframework.stereotype.Service;

@Service
public class SpOperatorServiceImpl extends ServiceImpl<SpOperatorMapper, SpOperator> implements ISpOperatorService {
}