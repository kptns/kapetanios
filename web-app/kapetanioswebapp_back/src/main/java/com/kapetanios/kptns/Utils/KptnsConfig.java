package com.kapetanios.kptns.Utils;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

import lombok.Data;
import lombok.Getter;

@Data
@Component
@ConfigurationProperties(prefix = "app.datadog-config")
public class KptnsConfig {
    private String apiUrl;
    private String apiKey;
    private String applicationKey;
}
