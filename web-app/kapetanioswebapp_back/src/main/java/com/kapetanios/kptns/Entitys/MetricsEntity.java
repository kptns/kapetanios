package com.kapetanios.kptns.Entitys;

import java.util.List;


import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class MetricsEntity {
    private String status;
    private List<SeriesEntity> series;
}
