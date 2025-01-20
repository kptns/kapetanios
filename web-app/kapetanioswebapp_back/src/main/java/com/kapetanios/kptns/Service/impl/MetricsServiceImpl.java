package com.kapetanios.kptns.Service.impl;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import com.kapetanios.kptns.Entitys.MetricsEntity;
import com.kapetanios.kptns.Service.MetricsService;
import com.kapetanios.kptns.Utils.KptnsConfig;

@Service
public class MetricsServiceImpl implements MetricsService{

    @Autowired
    KptnsConfig kptnsConfig;

    @Override
    public MetricsEntity getMetrics(long from, long to, String query) {
        RestTemplate restTemplate = new RestTemplate();

        // Construye los parámetros de la URL
        // String url = UriComponentsBuilder.fromHttpUrl(kptnsConfig.getApiUrl())
        //         .queryParam("from", 1736112878) // Ajusta los valores de tiempo según tu necesidad
        //         .queryParam("to", 1737322478)
        //         .queryParam("query", query)
        //         .toUriString();
        String url = "https://api.datadoghq.com/api/v1/query";
        String fromDate = "1736112878000";
        String toDate = "1737322478000";
        String finalUrl = String.format("%s?query=%s&from=%s&to=%s", url, query, fromDate, toDate);
        // String query = "kubernetes.cpu.usage.total{kube_deployment:kapetanios-sample-app}";
        // String url = String.format(
        //     "%s?from=%d&to=%d&query=%s",
        //     kptnsConfig.getApiUrl(),
        //     from,
        //     to,
        //     query
        // ); 
        HttpHeaders headers = new HttpHeaders();
                headers.set("DD-API-KEY", kptnsConfig.getApiKey());
                headers.set("DD-APPLICATION-KEY", kptnsConfig.getApplicationKey());
        
        // Construye la solicitud HTTP
        HttpEntity<Void> requestEntity = new HttpEntity<>(headers);

        // Realiza la solicitud GET
        ResponseEntity<String> response = restTemplate.exchange(
            finalUrl, // URL construida
            HttpMethod.GET, // Método HTTP
            requestEntity, // Entidad con encabezados
            String.class // Tipo de respuesta
        );
        System.out.println(response.getBody());

        return null;
    }
}
