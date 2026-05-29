package com.wangziyang.mes.order.inbound.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.wangziyang.mes.order.inbound.entity.SpInboundOrderItem;
import com.wangziyang.mes.order.inbound.mapper.SpInboundOrderItemMapper;
import com.wangziyang.mes.order.inbound.service.ISpInboundOrderItemService;
import org.springframework.stereotype.Service;

@Service
public class SpInboundOrderItemServiceImpl extends ServiceImpl<SpInboundOrderItemMapper, SpInboundOrderItem> implements ISpInboundOrderItemService {
}
