package com.kapetanios.kptns.controllers;

import org.springframework.web.bind.annotation.RestController;

import com.kapetanios.kptns.Service.MetricsService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;



@RestController
public class KptnsController {
    @Autowired
    MetricsService metricsService;

    @GetMapping("/metrics")
    public String getMethodName(@RequestParam String param) {
        long now = System.currentTimeMillis() / 1000;
        long tenMinutesAgo = now - 3600;
        String query = "kubernetes.network.rx_bytes{{kube_deployment:kapetanios-sample-app}}";
        metricsService.getMetrics(tenMinutesAgo, now, query);
        return "dsda";
    }
      
}
