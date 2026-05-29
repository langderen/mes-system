package com.wangziyang.mes.common.config;

import com.baomidou.mybatisplus.core.handlers.MetaObjectHandler;
import com.wangziyang.mes.system.entity.SysUser;
import org.apache.ibatis.reflection.MetaObject;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.subject.Subject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;

@Component
public class SpMetaObjectHandler implements MetaObjectHandler {

    Logger logger = LoggerFactory.getLogger(SpMetaObjectHandler.class);

    @Override
    public void insertFill(MetaObject metaObject) {
        logger.info("start insert fill ...");
        this.setInsertData(metaObject);
        this.setUpdateData(metaObject);
    }

    @Override
    public void updateFill(MetaObject metaObject) {
        logger.info("start update fill ...");
        this.setUpdateData(metaObject);
    }

    private String getCurrentUsername() {
        try {
            Subject subject = SecurityUtils.getSubject();
            if (subject != null && subject.getPrincipal() != null) {
                Object principal = subject.getPrincipal();
                if (principal instanceof SysUser) {
                    return ((SysUser) principal).getUsername();
                }
            }
        } catch (Exception e) {
            logger.warn("获取当前用户失败", e);
        }
        return "system";
    }

    private void setInsertData(MetaObject metaObject) {
        this.setInsertFieldValByName("createUsername", getCurrentUsername(), metaObject);
        this.setInsertFieldValByName("createTime", LocalDateTime.now(), metaObject);
    }

    private void setUpdateData(MetaObject metaObject) {
        this.setUpdateFieldValByName("updateUsername", getCurrentUsername(), metaObject);
        this.setUpdateFieldValByName("updateTime", LocalDateTime.now(), metaObject);
    }
}
