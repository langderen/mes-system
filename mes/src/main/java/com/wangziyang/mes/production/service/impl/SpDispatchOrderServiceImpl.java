package com.wangziyang.mes.production.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.wangziyang.mes.production.entity.SpDispatchOrder;
import com.wangziyang.mes.production.mapper.SpDispatchOrderMapper;
import com.wangziyang.mes.production.service.ISpDispatchOrderService;
import org.springframework.stereotype.Service;

@Service
public class SpDispatchOrderServiceImpl extends ServiceImpl<SpDispatchOrderMapper, SpDispatchOrder> implements ISpDispatchOrderService {
}