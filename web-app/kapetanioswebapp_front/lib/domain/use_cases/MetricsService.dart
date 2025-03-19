import 'dart:convert';

import 'package:kapetanioswebapp_front/domain/entities/AgentEntity.dart';
import 'package:kapetanioswebapp_front/domain/entities/MetricAuxEntity.dart';
import 'package:kapetanioswebapp_front/domain/entities/MetricEntity.dart';
import 'package:kapetanioswebapp_front/domain/entities/ResponseEntity.dart';
import 'package:http/http.dart' as http;

class Metricsservice {
  final String url_base = "http://localhost:8080/metrics";

  Future<MetricAux> getAgents(String ruta) async {
    MetricAux metrics = MetricAux(x: 0, y: 0);
    Uri  url = Uri.parse(url_base+"/"+ruta);
    try {
      final reponse = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );
      Responseentity response = Responseentity.fromJson(utf8.decode(reponse.bodyBytes));
      if(response.getSuccess == false){
        return metrics;
      }
      List datos = (response).getData;
      metrics = MetricAux(x: int.parse((datos[0]*1000).toString()), y: double.parse(datos[1].toString()));

      return metrics;
      
    } catch (e) {
      print('Excepción: $e');
      return MetricAux(x: 0, y: 0);
    }
  }
}