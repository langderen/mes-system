package com.wangziyang.mes.technology.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/technology/flow")
public class SpFlowUiController {

    @GetMapping("/list-ui")
    public String listUI() {
        return "technology/flow/list";
    }
}
