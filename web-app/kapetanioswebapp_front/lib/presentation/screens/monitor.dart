import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
                  infoLabel("Cluster", "fmoreno-k8s")
                ],
              ),
            ),
            Container(
              child: Row(
                children: [
                  topMenu("Descripcion", false),
                  topMenu("Explorar", true),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(child: LineChart(titulo: 'RAM',)),
                Expanded(child: LineChart(titulo: 'RAM',)),
              ],
            )
          ],
        ),
      )
    );
  }

  Container infoLabel(String titulo, String texto) {
    return Container(
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
            fontSize: 20,
            fontWeight: FontWeight.w600
          ),),
          Text(texto, style: TextStyle(
            fontSize: 16
          ),)
        ],
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

