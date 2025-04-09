import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kapetanioswebapp_front/domain/entities/AgentEntity.dart';
import 'package:kapetanioswebapp_front/domain/entities/LogsEntity.dart';
import 'package:kapetanioswebapp_front/domain/use_cases/MetricsService.dart';
import 'package:kapetanioswebapp_front/presentation/widgets/LineChart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Monitor extends StatefulWidget {
  final Agente agente;
  const Monitor({super.key, required this.agente});

  @override
  State<Monitor> createState() => _MonitorState();
}

class _MonitorState extends State<Monitor> {
  List<String> list = <String>['1s', '5s', '10s', '20s'];
  String dropdownValue = "1s";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.withAlpha(70),
                    width: 2
                  )
                )
              ),
              child: 
              Row(
                children: [
                  Text("Despliegue".toUpperCase(), style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600
                  ),),
                  SizedBox(width: 20,),
                  Text(widget.agente.getName)
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.withAlpha(70),
                    width: 2
                  )
                )
              ),
              child: Row(
                children: [
                  infoLabel("Name Space", widget.agente.nameSpace),
                  infoLabel("Kind", widget.agente.kind),
                  infoLabel("Ktps Server Url", widget.agente.kptsServerUrl),
                  infoLabel("Prometheus Url", widget.agente.prommetheusUrl),
                  infoLabel("Model Api Url", widget.agente.modelApiUrl),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.withAlpha(70),
                    width: 2
                  )
                )
              ),
              child: Row(
                children: [
                  topMenu("YAML", false),
                  topMenu("Logs", false),
                  topMenu("APM", false),
                  topMenu("Profiles", false),
                  topMenu("Metrics", true),
                  topMenu("Processes", false),
                  topMenu("Network", false),
                  topMenu("Events", false),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  DropdownButton<String>(
                    value: dropdownValue,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    style: const TextStyle(color: Colors.deepPurple),
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        dropdownValue = value!;
                      });
                    },
                    items:
                        list.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(value: value, child: Text(value));
                        }).toList(),
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(child: LineChart(
                          titulo: 'CPU Usado',
                          legendsName: [
                            "Nucleos en uso",
                          ],
                          ruta: "cpu",
                          intervalo: dropdownValue,
                          yLabel: "CPU (%)",
                        ),
                      ),
                      Expanded(child: LineChart(
                          titulo: 'Memoria Usada',
                          legendsName: [
                            "Memoria en uso"
                          ],
                          ruta: "memory",
                          intervalo: dropdownValue,
                          yLabel: "GB",
                        )
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                              .collection("Logs")
                              .orderBy("timestamp", descending: true)
                              .snapshots(),
                            builder: (ctx, snapshot){
                              if(!snapshot.hasData || snapshot.data!.docs.isEmpty){
                                return DataTable(
                                  columns: const <DataColumn>[
                                    DataColumn(label: Text("Log")),
                                    DataColumn(label: Text("Hora")),
                                    DataColumn(label: Text("Mensaje")),
                                    DataColumn(label: Text("Fuente")),
                                  ], rows: const <DataRow>[
                                    DataRow(
                                      cells: <DataCell>[
                                        DataCell(CircularProgressIndicator()),
                                        DataCell(Text("")),
                                        DataCell(Text("")),
                                        DataCell(Text("")),
                                      ]
                                    )
                                  ]
                                );
                              }
                          
                              final logs = snapshot.data!.docs.map((doc) {
                                return LogEntity.fromMap(doc.data() as Map<String, dynamic>, doc.id);
                              }).toList();
                              return SingleChildScrollView(
                                child: DataTable(
                                    columns: const <DataColumn>[
                                      DataColumn(label: Text("Log")),
                                      DataColumn(label: Text("Hora")),
                                      DataColumn(label: Text("Mensaje")),
                                      DataColumn(label: Text("Fuente")),
                                    ], rows: logs.map((log) {
                                      return DataRow(cells: [
                                        DataCell(Text(log.logLevel)),
                                        DataCell(Text(log.timestamp.toString())),
                                        DataCell(Text(log.message)),
                                        DataCell(Text(log.source)),
                                      ]);
                                    }).toList()
                                  ),
                              );
                            }
                          ),
                        ),
                      ],
                    ),
                  )
                  // Row(
                  //   children: [
                  //     Expanded(child: LineChart(
                  //         titulo: 'CPU Solicitado, Limite y Usado',
                  //         legendsName: [
                  //           "Nucleros usados", "Nucleos limite", "Nucleos solicitados"
                  //         ],
                  //         ruta: "rxbytes",
                  //         intervalo: dropdownValue
                  //       )
                  //     ),
                  //     Expanded(child: LineChart(
                  //         titulo: 'CPU Solicitado, Limite y Usado',
                  //         legendsName: [
                  //           "Nucleros usados", "Nucleos limite", "Nucleos solicitados"
                  //         ],
                  //         ruta: "txbytes",
                  //         intervalo: dropdownValue
                  //       )
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            )
          ],
        ),
      )
    );
  }

  Padding infoLabel(String titulo, String texto) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Container(
        width: 250,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(
            width: 1.2,
            color: Colors.black.withAlpha(60),
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(4)
          )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(titulo.toUpperCase(), style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600
            ),),
            Text(texto, style: TextStyle(
              fontSize: 15
            ),)
          ],
        ),
      ),
    );
  }

  Container topMenu(String titulo, bool activo) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: activo ? Colors.blueAccent : Colors.transparent,
            width: 3
          )
        )
      ),
      padding: EdgeInsets.all(10),
      child: Text(titulo, style: TextStyle(
          fontSize: 20,
          color: Colors.grey[600]
        ),
      )
    );
  }
}

// Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Container(
//             height: MediaQuery.sizeOf(context).height,
//             width: MediaQuery.sizeOf(context).width * .5,
//             child: LineChart(titulo: 'CPU',)
//           ),
//           Container(
//             height: MediaQuery.sizeOf(context).height,
//             width: MediaQuery.sizeOf(context).width * .5,
//             child: Column(
//               children: [
//                 Expanded(child: LineChart(titulo: 'RAM',)),
//                 Expanded(child: LineChart(titulo: 'Almacenamiento',)),
//               ],
//             ),
//           )
//         ],
//       ),

