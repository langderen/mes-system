package com.wangziyang.mes.technology.service.impl;

import cn.hutool.core.collection.CollectionUtil;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.technology.dto.SpFlowDto;
import com.wangziyang.mes.technology.entity.SpFlow;
import com.wangziyang.mes.technology.entity.SpFlowCategory;
import com.wangziyang.mes.technology.entity.SpFlowOperRelation;
import com.wangziyang.mes.technology.entity.SpOper;
import com.wangziyang.mes.technology.mapper.SpFlowOperRelationMapper;
import com.wangziyang.mes.technology.service.ISpFlowCategoryService;
import com.wangziyang.mes.technology.service.ISpFlowOperRelationService;
import com.wangziyang.mes.technology.service.ISpFlowService;
import com.wangziyang.mes.technology.service.ISpOperService;
import com.wangziyang.mes.technology.vo.SpOperVo;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

@Service
public class SpFlowOperRelationServiceImpl extends ServiceImpl<SpFlowOperRelationMapper, SpFlowOperRelation> implements ISpFlowOperRelationService {

    @Autowired
    private ISpFlowService iSpFlowService;

    @Autowired
    private ISpFlowCategoryService iSpFlowCategoryService;

    @Autowired
    private ISpOperService iSpOperService;

    @Autowired
    private SpFlowOperRelationMapper spFlowOperRelationMapper;

    @Override
    public List<SpOperVo> allOperViewServer() throws Exception {
        List<SpOper> operList = iSpOperService.list();
        List<SpOperVo> spOperVos = new ArrayList<>();
        for (SpOper spOper : operList) {
            SpOperVo operVo = new SpOperVo();
            operVo.setValue(spOper.getId());
            operVo.setTitle(spOper.getOper());
            spOperVos.add(operVo);
        }
        return spOperVos;
    }

    @Override
    public List<SpOperVo> currentOperViewServer(String flowId) throws Exception {
        return spFlowOperRelationMapper.queryOperRelationByFlowId(flowId);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Result addOrUpdate(SpFlowDto spFlowDto) throws Exception {
        List<SpOperVo> spOperVoList = spFlowDto.getSpOperVoList();
        if (CollectionUtil.isEmpty(spOperVoList) || spOperVoList.size() <= 1) {
            throw new Exception("流程下必须至少存在两个工序");
        }

        SpFlow spFlow = new SpFlow();
        BeanUtils.copyProperties(spFlowDto, spFlow);
        if (StringUtils.isNotBlank(spFlow.getFlowCategoryId())) {
            SpFlowCategory category = iSpFlowCategoryService.getById(spFlow.getFlowCategoryId());
            if (category != null) {
                spFlow.setFlowCategoryName(category.getCategoryName());
            }
        }

        String flowId = spFlow.getId();
        if (StringUtils.isNotBlank(flowId)) {
            spFlowOperRelationMapper.deleteOperRelationByFlowId(flowId);
        } else {
            iSpFlowService.saveOrUpdate(spFlow);
            flowId = spFlow.getId();
        }

        List<SpFlowOperRelation> relationList = new ArrayList<>();
        StringBuilder processBuild = new StringBuilder();
        for (int i = 0; i < spOperVoList.size(); i++) {
            SpOperVo current = spOperVoList.get(i);
            SpOper oper = iSpOperService.getById(current.getValue());

            SpFlowOperRelation relation = new SpFlowOperRelation();
            relation.setFlowId(flowId);
            relation.setFlow(spFlow.getFlow());
            relation.setSortNum(i + 1);
            relation.setOperId(current.getValue());
            relation.setOper(current.getTitle());

            if (i == 0) {
                relation.setPerOperId("");
                relation.setPerOper("");
            } else {
                relation.setPerOperId(spOperVoList.get(i - 1).getValue());
                relation.setPerOper(spOperVoList.get(i - 1).getTitle());
            }

            if (i + 1 < spOperVoList.size()) {
                relation.setNextOperId(spOperVoList.get(i + 1).getValue());
                relation.setNextOper(spOperVoList.get(i + 1).getTitle());
            } else {
                relation.setNextOperId("");
                relation.setNextOper("");
            }

            if (oper != null && StringUtils.isNotBlank(oper.getOperDesc())) {
                if (processBuild.length() > 0) {
                    processBuild.append("->");
                }
                processBuild.append(oper.getOperDesc());
            }
            relationList.add(relation);
        }

        spFlow.setProcess(processBuild.toString());
        iSpFlowService.saveOrUpdate(spFlow);
        saveOrUpdateBatch(relationList);
        return Result.success();
    }
}
