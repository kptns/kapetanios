package com.kapetanios.kptns.Service;

import org.springframework.stereotype.Service;

import com.kapetanios.kptns.Entitys.MetricsEntity;

@Service
public interface MetricsService {
    public MetricsEntity getMetrics(long from, long to, String query);
}
