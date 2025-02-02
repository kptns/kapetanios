// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Agente {
  String id;
  String clusterName;
  String hostRegistry;
  String hostKapetanios;
  DateTime dateTime;
  String pod;
  String status;
  int ready;
  int restart;
  int cpuUsageLimit;
  int memUsageLimit;
get getId => this.id;

 set setId(String id) => this.id = id;

  get getClusterName => this.clusterName;

 set setClusterName( clusterName) => this.clusterName = clusterName;

  get getHostRegistry => this.hostRegistry;

 set setHostRegistry( hostRegistry) => this.hostRegistry = hostRegistry;

  get getHostKapetanios => this.hostKapetanios;

 set setHostKapetanios( hostKapetanios) => this.hostKapetanios = hostKapetanios;

  get getDateTime => this.dateTime;

 set setDateTime( dateTime) => this.dateTime = dateTime;

  get getPod => this.pod;

 set setPod( pod) => this.pod = pod;

  get getStatus => this.status;

 set setStatus( status) => this.status = status;

  get getReady => this.ready;

 set setReady( ready) => this.ready = ready;

  get getRestart => this.restart;

 set setRestart( restart) => this.restart = restart;

  get getCpuUsageLimit => this.cpuUsageLimit;

 set setCpuUsageLimit( cpuUsageLimit) => this.cpuUsageLimit = cpuUsageLimit;

  get getMemUsageLimit => this.memUsageLimit;

 set setMemUsageLimit( memUsageLimit) => this.memUsageLimit = memUsageLimit;
  Agente({
    this.id = "",
    this.clusterName = "",
    this.hostRegistry = "",
    this.hostKapetanios = "",
    required this.dateTime,
    this.pod = "",
    this.status = "",
    this.ready = 0,
    this.restart = 0,
    this.cpuUsageLimit = 0,
    this.memUsageLimit = 0,
  });

  Agente copyWith({
    String? id,
    String? clusterName,
    String? hostRegistry,
    String? hostKapetanios,
    DateTime? dateTime,
    String? pod,
    String? status,
    int? ready,
    int? restart,
    int? cpuUsageLimit,
    int? memUsageLimit,
  }) {
    return Agente(
      id: id ?? this.id,
      clusterName: clusterName ?? this.clusterName,
      hostRegistry: hostRegistry ?? this.hostRegistry,
      hostKapetanios: hostKapetanios ?? this.hostKapetanios,
      dateTime: dateTime ?? this.dateTime,
      pod: pod ?? this.pod,
      status: status ?? this.status,
      ready: ready ?? this.ready,
      restart: restart ?? this.restart,
      cpuUsageLimit: cpuUsageLimit ?? this.cpuUsageLimit,
      memUsageLimit: memUsageLimit ?? this.memUsageLimit,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'clusterName': clusterName,
      'hostRegistry': hostRegistry,
      'hostKapetanios': hostKapetanios,
      'dateTime': dateTime.millisecondsSinceEpoch,
      'pod': pod,
      'status': status,
      'ready': ready,
      'restart': restart,
      'cpuUsageLimit': cpuUsageLimit,
      'memUsageLimit': memUsageLimit,
    };
  }

  factory Agente.fromMap(Map<String, dynamic> map) {
    return Agente(
      id: map['id'] as String,
      clusterName: map['clusterName'] as String,
      hostRegistry: map['hostRegistry'] as String,
      hostKapetanios: map['hostKapetanios'] as String,
      dateTime: DateTime.fromMillisecondsSinceEpoch(map['dateTime'] as int),
      pod: map['pod'] as String,
      status: map['status'] as String,
      ready: map['ready'] as int,
      restart: map['restart'] as int,
      cpuUsageLimit: map['cpuUsageLimit'] as int,
      memUsageLimit: map['memUsageLimit'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Agente.fromJson(String source) => Agente.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Agente(id: $id, clusterName: $clusterName, hostRegistry: $hostRegistry, hostKapetanios: $hostKapetanios, dateTime: $dateTime, pod: $pod, status: $status, ready: $ready, restart: $restart, cpuUsageLimit: $cpuUsageLimit, memUsageLimit: $memUsageLimit)';
  }

  @override
  bool operator ==(covariant Agente other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.clusterName == clusterName &&
      other.hostRegistry == hostRegistry &&
      other.hostKapetanios == hostKapetanios &&
      other.dateTime == dateTime &&
      other.pod == pod &&
      other.status == status &&
      other.ready == ready &&
      other.restart == restart &&
      other.cpuUsageLimit == cpuUsageLimit &&
      other.memUsageLimit == memUsageLimit;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      clusterName.hashCode ^
      hostRegistry.hashCode ^
      hostKapetanios.hashCode ^
      dateTime.hashCode ^
      pod.hashCode ^
      status.hashCode ^
      ready.hashCode ^
      restart.hashCode ^
      cpuUsageLimit.hashCode ^
      memUsageLimit.hashCode;
  }
}


