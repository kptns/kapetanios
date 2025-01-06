package com.kapetanios.kptns.controllers;

import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;


@RestController
@RequestMapping(value = "agent")
public class AgentController {

    @PostMapping("config")
    public String config(@RequestBody String entity) {
        //TODO: process POST request
        
        return entity;
    }

    @PostMapping("report")
    public String report(@RequestBody String entity) {
        //TODO: process POST request
        
        return entity;
    }
    
    
}
