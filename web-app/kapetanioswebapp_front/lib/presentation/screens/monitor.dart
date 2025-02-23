import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kapetanioswebapp_front/domain/use_cases/MetricsService.dart';
import 'package:kapetanioswebapp_front/presentation/widgets/LineChart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Monitor extends StatefulWidget {
  const Monitor({super.key});

  @override
  State<Monitor> createState() => _MonitorState();
}

class _MonitorState extends State<Monitor> {

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
                  Text("kapetanios")
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
                  infoLabel("Cluster", "fmoreno-k8s"),
                  infoLabel("Namespace", "default"),
                  infoLabel("Age", "5 days"),
                  infoLabel("Revision", "1"),
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
   items: ["Handball", "Volleyball", "Football", "Badminton"].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              
                alignment: Alignment.bottomRight,
                borderRadius: BorderRadius.circular(15),
                
                underline: SizedBox(),
              onChanged: (value) {
                
              },
)
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  Row(
                    children: [
                      Expanded(child: LineChart(
                          titulo: 'Replicas disponibles y no disponibles',
                          legendsName: [
                            "Replicas disponibles", "Replicas no disponibles", "Replicas esperadas"
                          ],
                          ruta: "pods",
                        )
                      ),
                      Expanded(child: LineChart(
                          titulo: 'Replicas actualizadas y vencidas',
                          legendsName: [
                            "Replicas disponibles", "Replicas no disponibles", "Replicas esperadas"
                          ],
                          ruta: "rxbytes",
                        )
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: LineChart(
                          titulo: 'CPU Solicitado, Limite y Usado',
                          legendsName: [
                            "Nucleros usados", "Nucleos limite", "Nucleos solicitados"
                          ],
                          ruta: "cpu",
                        )
                      ),
                      Expanded(child: LineChart(
                          titulo: 'Memoria Solicitada, Limite y Usado',
                          legendsName: [
                            "Memoria usada", "Memoria limite", "Memoria solicitada"
                          ],
                          ruta: "memory",
                        )
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: LineChart(
                          titulo: 'CPU Solicitado, Limite y Usado',
                          legendsName: [
                            "Nucleros usados", "Nucleos limite", "Nucleos solicitados"
                          ],
                          ruta: "cpu",
                        )
                      ),
                    ],
                  ),
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

