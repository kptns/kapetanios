package com.kapetanios.kptns.Entitys;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class SeriesEntity {
    private String metric;
    private String scope;
    private List<List<Object>> pointlist;
}
