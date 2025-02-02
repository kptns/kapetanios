import 'dart:convert';

import 'package:kapetanioswebapp_front/domain/entities/AgentEntity.dart';
import 'package:kapetanioswebapp_front/domain/entities/ResponseEntity.dart';
import 'package:http/http.dart' as http;

class Agenteservice {
  final String url_base = "http://localhost:8080/config/update";

  Future<Responseentity?> saveAgent(Agente agente) async {
    Uri  url = Uri.parse(url_base);
    try {
      final reponse = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(agente.toMap())
      );

      return Responseentity.fromJson(utf8.decode(reponse.bodyBytes));
      
    } catch (e) {
      print('Excepción: $e');
      return null;
    }
  }

  Future<List<Agente>?> getAgents(String agent) async {
    List<Agente> agentes = [];
    Uri  url = Uri.parse(url_base).replace(
      queryParameters: {
        "id": agent
      }
    );
    try {
      final reponse = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );
      Responseentity response = Responseentity.fromJson(utf8.decode(reponse.bodyBytes));
      if(response.getSuccess == false){
        return [];
      }
      for (Map<String, dynamic> agente  in (response).getData as List) {
        agentes.add(Agente.fromMap(agente));
      }
      
      return agentes;
      
    } catch (e) {
      print('Excepción: $e');
      return [];
    }
  }

  Future<Responseentity?> deleteAgent(String id) async {
    List<Agente> agentes = [];
    Uri  url = Uri.parse(url_base).replace(
      queryParameters: {
        "id": id
      }
    );
    try {
      final reponse = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );
      return Responseentity.fromJson(utf8.decode(reponse.bodyBytes));
      
    } catch (e) {
      print('Excepción: $e');
      return null;
    }
  }

  Future<Responseentity?> updateAgent(Agente agente) async {
    Uri  url = Uri.parse(url_base);
    try {
      final reponse = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(agente.toMap())
      );

      return Responseentity.fromJson(utf8.decode(reponse.bodyBytes));
      
    } catch (e) {
      print('Excepción: $e');
      return null;
    }
  }
}