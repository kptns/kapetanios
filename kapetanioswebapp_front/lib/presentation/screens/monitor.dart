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
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: MediaQuery.sizeOf(context).height,
            width: MediaQuery.sizeOf(context).width * .5,
            child: LineChart(titulo: 'CPU',)
          ),
          Container(
            height: MediaQuery.sizeOf(context).height,
            width: MediaQuery.sizeOf(context).width * .5,
            child: Column(
              children: [
                Expanded(child: LineChart(titulo: 'RAM',)),
                Expanded(child: LineChart(titulo: 'Almacenamiento',)),
              ],
            ),
          )
        ],
      ),
    );
  }
}

