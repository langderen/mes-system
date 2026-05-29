package com.wangziyang.mes.order.inbound.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.wangziyang.mes.order.inbound.entity.SpInboundOrder;
import com.wangziyang.mes.order.inbound.mapper.SpInboundOrderMapper;
import com.wangziyang.mes.order.inbound.service.ISpInboundOrderService;
import org.springframework.stereotype.Service;

@Service
public class SpInboundOrderServiceImpl extends ServiceImpl<SpInboundOrderMapper, SpInboundOrder> implements ISpInboundOrderService {
}
