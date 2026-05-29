package com.wangziyang.mes.productdata.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.wangziyang.mes.productdata.entity.SpPart;
import com.wangziyang.mes.productdata.mapper.SpPartMapper;
import com.wangziyang.mes.productdata.service.ISpPartService;
import org.springframework.stereotype.Service;

@Service
public class SpPartServiceImpl extends ServiceImpl<SpPartMapper, SpPart> implements ISpPartService {
}
