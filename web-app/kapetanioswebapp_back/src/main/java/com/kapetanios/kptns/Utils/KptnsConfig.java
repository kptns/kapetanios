package com.kapetanios.kptns.Utils;

import org.springframework.beans.factory.annotation.Value;

import lombok.Getter;

@Getter
public class KptnsConfig {
    @Value(value = "${app.datadogConfig.apiKey}")
    private String apiKeyDataDog;

    @Value(value = "${app.datadogConfig.applicationKey}")
    private String applicationKeyDataDog;
}
