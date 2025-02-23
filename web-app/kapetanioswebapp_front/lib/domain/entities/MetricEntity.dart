// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class Metric {
  List<List<double>>? kubernetesCpuUsageTotal;
	List<List<double>>? kubernetesMemoryUsage;
	List<List<double>>? kubernetesPodsRunning;
	List<List<double>>? kubernetesNetworkRxBytes;
	List<List<double>>? kubernetesNetworkTxBytes;
  Metric({
    this.kubernetesCpuUsageTotal,
    this.kubernetesMemoryUsage,
    this.kubernetesPodsRunning,
    this.kubernetesNetworkRxBytes,
    this.kubernetesNetworkTxBytes,
  });
 List<List<double>>? get getKubernetesCpuUsageTotal => this.kubernetesCpuUsageTotal;

 set setKubernetesCpuUsageTotal(List<List<double>> kubernetesCpuUsageTotal) => this.kubernetesCpuUsageTotal = kubernetesCpuUsageTotal;

 	List<List<double>>? get getKubernetesMemoryUsage => this.kubernetesMemoryUsage;

 set setKubernetesMemoryUsage(	List<List<double>> kubernetesMemoryUsage) => this.kubernetesMemoryUsage = kubernetesMemoryUsage;

 	List<List<double>>? get getKubernetesPodsRunning => this.kubernetesPodsRunning;

 set setKubernetesPodsRunning(	List<List<double>> kubernetesPodsRunning) => this.kubernetesPodsRunning = kubernetesPodsRunning;

 	List<List<double>>? get getKubernetesNetworkRxBytes => this.kubernetesNetworkRxBytes;

 set setKubernetesNetworkRxBytes(	List<List<double>> kubernetesNetworkRxBytes) => this.kubernetesNetworkRxBytes = kubernetesNetworkRxBytes;

 	List<List<double>>? get getKubernetesNetworkTxBytes => this.kubernetesNetworkTxBytes;

 set setKubernetesNetworkTxBytes(	List<List<double>> kubernetesNetworkTxBytes) => this.kubernetesNetworkTxBytes = kubernetesNetworkTxBytes;

  Metric copyWith({
    List<List<double>>? kubernetesCpuUsageTotal,
    List<List<double>>? kubernetesMemoryUsage,
    List<List<double>>? kubernetesPodsRunning,
    List<List<double>>? kubernetesNetworkRxBytes,
    List<List<double>>? kubernetesNetworkTxBytes,
  }) {
    return Metric(
      kubernetesCpuUsageTotal: kubernetesCpuUsageTotal ?? this.kubernetesCpuUsageTotal,
      kubernetesMemoryUsage: kubernetesMemoryUsage ?? this.kubernetesMemoryUsage,
      kubernetesPodsRunning: kubernetesPodsRunning ?? this.kubernetesPodsRunning,
      kubernetesNetworkRxBytes: kubernetesNetworkRxBytes ?? this.kubernetesNetworkRxBytes,
      kubernetesNetworkTxBytes: kubernetesNetworkTxBytes ?? this.kubernetesNetworkTxBytes,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'kubernetesCpuUsageTotal': kubernetesCpuUsageTotal,
      'kubernetesMemoryUsage': kubernetesMemoryUsage,
      'kubernetesPodsRunning': kubernetesPodsRunning,
      'kubernetesNetworkRxBytes': kubernetesNetworkRxBytes,
      'kubernetesNetworkTxBytes': kubernetesNetworkTxBytes,
    };
  }

  factory Metric.fromMap(Map<String, dynamic> map) {
    List<List<double>> parseList(dynamic data) {
      if (data is List) {
        return data.map<List<double>>(
          (innerList) => (innerList as List)
              .map<double>((e) => (e as num).toDouble())
              .toList(),
        ).toList();
      }
      return [];
    }

    return Metric(
      kubernetesCpuUsageTotal: parseList(map['kubernetes.cpu.usage.total']),
      kubernetesMemoryUsage: parseList(map['kubernetes.memory.usage']),
      kubernetesPodsRunning: parseList(map['kubernetes.pods.running']),
      kubernetesNetworkRxBytes: parseList(map['kubernetes.network.rx_bytes']),
      kubernetesNetworkTxBytes: parseList(map['kubernetes.network.tx_bytes']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Metric.fromJson(String source) => Metric.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Metric(kubernetesCpuUsageTotal: $kubernetesCpuUsageTotal, kubernetesMemoryUsage: $kubernetesMemoryUsage, kubernetesPodsRunning: $kubernetesPodsRunning, kubernetesNetworkRxBytes: $kubernetesNetworkRxBytes, kubernetesNetworkTxBytes: $kubernetesNetworkTxBytes)';
  }

  @override
  bool operator ==(covariant Metric other) {
    if (identical(this, other)) return true;
  
    return 
      listEquals(other.kubernetesCpuUsageTotal, kubernetesCpuUsageTotal) &&
      listEquals(other.kubernetesMemoryUsage, kubernetesMemoryUsage) &&
      listEquals(other.kubernetesPodsRunning, kubernetesPodsRunning) &&
      listEquals(other.kubernetesNetworkRxBytes, kubernetesNetworkRxBytes) &&
      listEquals(other.kubernetesNetworkTxBytes, kubernetesNetworkTxBytes);
  }

  @override
  int get hashCode {
    return kubernetesCpuUsageTotal.hashCode ^
      kubernetesMemoryUsage.hashCode ^
      kubernetesPodsRunning.hashCode ^
      kubernetesNetworkRxBytes.hashCode ^
      kubernetesNetworkTxBytes.hashCode;
  }
}
