import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LineChart extends StatefulWidget {
  final String titulo;
  final List<String> legendsName;
  const LineChart({super.key, required this.titulo, required this.legendsName});

  @override
  State<LineChart> createState() => _LineChartState();
}

class _LineChartState extends State<LineChart> {
    _LiveLineChartState() {
    _timer = Timer.periodic(
      const Duration(milliseconds: 200),
      _updateDataSource,
    );
  }

  late int _count = 0;

  List<_ChartSampleData>? _chartData = [];
  List<_ChartSampleData>? _chartData2 = [];
  ChartSeriesController<_ChartSampleData, int>? _chartSeriesController;
  ChartSeriesController<_ChartSampleData, int>? _chartSeriesController2;
  ChartSeriesController<_ChartSampleData, int>? _chartSeriesController3;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    _LiveLineChartState();
    return Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.titulo, style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600
              ),),
              Divider(
                color: Colors.grey.withAlpha(100),
                thickness: .5,
              ),
              SfCartesianChart(
                  plotAreaBorderWidth: 0,
                  primaryXAxis: const NumericAxis(
                    majorGridLines: MajorGridLines(width: 0),
                    title: AxisTitle(
                      text: "Tiempo (m)"
                    ),
                  ),
                  legend: Legend(
                    isVisible: true, // Habilita la leyenda
                    position: LegendPosition.bottom, // Posición en la parte inferior
                    overflowMode: LegendItemOverflowMode.wrap, // Ajusta las leyendas si hay muchas
                  ),
                  primaryYAxis: const NumericAxis(
                    axisLine: AxisLine(width: 0),
                    majorTickLines: MajorTickLines(size: 0),
                    title: AxisTitle(
                      text: "Gb"
                    ),
                  ),
                  series: <LineSeries<_ChartSampleData, int>>[
                    LineSeries<_ChartSampleData, int>(
                      dataSource: _chartData,
                      xValueMapper: (_ChartSampleData data, int index) => data.country,
                      yValueMapper: (_ChartSampleData data, int index) => data.sales,
                      color: const Color.fromRGBO(192, 108, 132, 1),
                      animationDuration: 0,
                      onRendererCreated:
                          (ChartSeriesController<_ChartSampleData, int> controller) {
                        _chartSeriesController = controller;
                      },
                      name: widget.legendsName[0],
                    ),
                    LineSeries<_ChartSampleData, int>(
                      dataSource: _chartData,
                      xValueMapper: (_ChartSampleData data, int index) => data.country,
                      yValueMapper: (_ChartSampleData data, int index) => data.sales-100,
                      color: const Color.fromRGBO(192, 108, 132, 1),
                      animationDuration: 0,
                      onRendererCreated:
                          (ChartSeriesController<_ChartSampleData, int> controller) {
                        _chartSeriesController2 = controller;
                      },
                      name: widget.legendsName[1],
                    ),
                    LineSeries<_ChartSampleData, int>(
                      dataSource: _chartData,
                      xValueMapper: (_ChartSampleData data, int index) => data.country,
                      yValueMapper: (_ChartSampleData data, int index) => data.sales+100,
                      color: const Color.fromRGBO(192, 108, 132, 1),
                      animationDuration: 0,
                      onRendererCreated:
                          (ChartSeriesController<_ChartSampleData, int> controller) {
                        _chartSeriesController3 = controller;
                      },
                      name: widget.legendsName[2],
                    )
                  ],
                ),
            ],
          ),
        );
  }

  /// Updates the data source periodically based on the timer.
  void _updateDataSource(Timer timer) {
    if (true) {
      _chartData!.add(
        _ChartSampleData(_count, _generateRandomInteger(10, 100)),
        
      );
      if (_chartData!.length == 50) {
        _chartData!.removeAt(0);
        _chartSeriesController?.updateDataSource(
          addedDataIndexes: <int>[_chartData!.length - 1],
          removedDataIndexes: <int>[0],
        );
        
        _chartSeriesController2?.updateDataSource(
          addedDataIndexes: <int>[_chartData!.length - 1],
          removedDataIndexes: <int>[0],
        );

        _chartSeriesController3?.updateDataSource(
          addedDataIndexes: <int>[_chartData!.length - 1],
          removedDataIndexes: <int>[0],
        );
      } else {
        _chartSeriesController?.updateDataSource(
          addedDataIndexes: <int>[_chartData!.length - 1],
        );
        _chartSeriesController2?.updateDataSource(
          addedDataIndexes: <int>[_chartData!.length - 1],
        );
        _chartSeriesController3?.updateDataSource(
          addedDataIndexes: <int>[_chartData!.length - 1],
        );
      }
      _count = _count + 1;
    }
  }

  /// Generates a random integer within the specified range.
  int _generateRandomInteger(int min, int max) {
    final Random random = Random();
    return min + random.nextInt(max - min);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _chartData!.clear();
    _chartSeriesController = null;
    super.dispose();
  }
}

class _ChartSampleData {
  _ChartSampleData(this.country, this.sales);
  final int country;
  final num sales;
}