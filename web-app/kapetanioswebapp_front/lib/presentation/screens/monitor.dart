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
                          titulo: 'CPU Solicitado, Limite y Usado',
                          legendsName: [
                            "Nucleros usados", "Nucleos limite", "Nucleos solicitados"
                          ],
                          ruta: "cpu",
                          intervalo: dropdownValue
                        ),
                      ),
                      Expanded(child: LineChart(
                          titulo: 'CPU Solicitado, Limite y Usado',
                          legendsName: [
                            "Nucleros usados", "Nucleos limite", "Nucleos solicitados"
                          ],
                          ruta: "memory",
                          intervalo: dropdownValue
                        )
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: LineChart(
                          titulo: 'CPU Solicitado, Limite y Usado',
                          legendsName: [
                            "Nucleros usados", "Nucleos limite", "Nucleos solicitados"
                          ],
                          ruta: "rxbytes",
                          intervalo: dropdownValue
                        )
                      ),
                      Expanded(child: LineChart(
                          titulo: 'CPU Solicitado, Limite y Usado',
                          legendsName: [
                            "Nucleros usados", "Nucleos limite", "Nucleos solicitados"
                          ],
                          ruta: "txbytes",
                          intervalo: dropdownValue
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

