package com.kapetanios.kptns.controllers;

import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;



@RestController
public class KptnsController {


    @GetMapping("/metrics")
    public String getMethodName(@RequestParam String param) {
        return new String();
    }
      
}
