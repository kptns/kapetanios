// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Agente {
  String id;
  String name;
  String nameSpace;
  String prommetheusUrl;
  String modelApiUrl;
  String kptsServerUrl;
  String kind;
  Agente({
    this.id = "",
    this.name = "kapetanios-agent-config",
    this.nameSpace = "kapetanios",
    this.prommetheusUrl = "",
    this.modelApiUrl = "",
    this.kptsServerUrl = "",
    this.kind = "ConfigMap",
  });
 String get getId => this.id;

 set setId(String id) => this.id = id;

  get getName => this.name;

 set setName( name) => this.name = name;

  get getNameSpace => this.nameSpace;

 set setNameSpace( nameSpace) => this.nameSpace = nameSpace;

  get getPrommetheusUrl => this.prommetheusUrl;

 set setPrommetheusUrl( prommetheusUrl) => this.prommetheusUrl = prommetheusUrl;

  get getModelApiUrl => this.modelApiUrl;

 set setModelApiUrl( modelApiUrl) => this.modelApiUrl = modelApiUrl;

  get getKptsServerUrl => this.kptsServerUrl;

 set setKptsServerUrl( kptsServerUrl) => this.kptsServerUrl = kptsServerUrl;

  get getKind => this.kind;

 set setKind( kind) => this.kind = kind;


  Agente copyWith({
    String? id,
    String? name,
    String? nameSpace,
    String? prommetheusUrl,
    String? modelApiUrl,
    String? kptsServerUrl,
    String? kind,
  }) {
    return Agente(
      id: id ?? this.id,
      name: name ?? this.name,
      nameSpace: nameSpace ?? this.nameSpace,
      prommetheusUrl: prommetheusUrl ?? this.prommetheusUrl,
      modelApiUrl: modelApiUrl ?? this.modelApiUrl,
      kptsServerUrl: kptsServerUrl ?? this.kptsServerUrl,
      kind: kind ?? this.kind,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'nameSpace': nameSpace,
      'prommetheusUrl': prommetheusUrl,
      'modelApiUrl': modelApiUrl,
      'kptsServerUrl': kptsServerUrl,
      'kind': kind,
    };
  }

  factory Agente.fromMap(Map<String, dynamic> map) {
    return Agente(
      id: map['id'] as String,
      name: map['name'] as String,
      nameSpace: map['nameSpace'] as String,
      prommetheusUrl: map['prommetheusUrl'] as String,
      modelApiUrl: map['modelApiUrl'] as String,
      kptsServerUrl: map['kptsServerUrl'] as String,
      kind: map['kind'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Agente.fromJson(String source) => Agente.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Agente(id: $id, name: $name, nameSpace: $nameSpace, prommetheusUrl: $prommetheusUrl, modelApiUrl: $modelApiUrl, kptsServerUrl: $kptsServerUrl, kind: $kind)';
  }

  @override
  bool operator ==(covariant Agente other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.name == name &&
      other.nameSpace == nameSpace &&
      other.prommetheusUrl == prommetheusUrl &&
      other.modelApiUrl == modelApiUrl &&
      other.kptsServerUrl == kptsServerUrl &&
      other.kind == kind;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      nameSpace.hashCode ^
      prommetheusUrl.hashCode ^
      modelApiUrl.hashCode ^
      kptsServerUrl.hashCode ^
      kind.hashCode;
  }
}


