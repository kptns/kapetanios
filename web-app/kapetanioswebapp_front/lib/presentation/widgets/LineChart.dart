import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kapetanioswebapp_front/domain/entities/MetricAuxEntity.dart';
import 'package:kapetanioswebapp_front/domain/use_cases/MetricsService.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LineChart extends StatefulWidget {
  final String titulo;
  final List<String> legendsName;
  final String ruta;

  const LineChart({
    Key? key,
    required this.titulo,
    required this.legendsName,
    required this.ruta,
  }) : super(key: key);

  @override
  State<LineChart> createState() => _LineChartState();
}

class _LineChartState extends State<LineChart> {
  late Metricsservice metricsservice;
  List<MetricAux> _chartData = [];
  ChartSeriesController? _chartSeriesController;
  Timer? _timer;
  final int _visibleDuration = 60;

  @override
  void initState() {
    super.initState();
    metricsservice = Metricsservice();
    // Inicializa el temporizador en initState
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      _updateDataSource,
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime startTime = _chartData.length > 0 ? DateTime.fromMillisecondsSinceEpoch( _chartData.first.x as int) : now.subtract(Duration(seconds: 1));

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.titulo,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          Divider(
            color: Colors.grey.withAlpha(100),
            thickness: 0.5,
          ),
          SfCartesianChart(
            plotAreaBorderWidth: 0,
            primaryXAxis: DateTimeAxis(
              title: AxisTitle(text: "Tiempo (m)"),
              dateFormat: DateFormat.Hms(),
              intervalType: DateTimeIntervalType.seconds,
              interval: 1, // Intervalo de 10 minutos
              labelRotation: 45,
              minimum: startTime,
              maximum: now,
            ),
            // primaryXAxis: NumericAxis(
            //   majorGridLines: const MajorGridLines(width: 0),
            //   title: AxisTitle(text: "Tiempo (m)"),
            // ),
            legend: Legend(
              isVisible: true,
              position: LegendPosition.bottom,
              overflowMode: LegendItemOverflowMode.wrap,
            ),
            primaryYAxis: NumericAxis(
              axisLine: const AxisLine(width: 0),
              majorTickLines: const MajorTickLines(size: 0),
              title: const AxisTitle(text: "Gb"),
            ),
            series: <AreaSeries<MetricAux, DateTime>>[
              AreaSeries<MetricAux, DateTime>(
                dataSource: _chartData,
                xValueMapper: (MetricAux data, _) => DateTime.fromMillisecondsSinceEpoch(((data.x! / 1000) * 1000) as int),
                yValueMapper: (MetricAux data, _) => data.y,
                color: Colors.blue.withOpacity(0.5),
                borderColor: Colors.blue,
                borderWidth: 2,
                markerSettings: MarkerSettings(
                  isVisible: true, // Mostrar marcadores
                  shape: DataMarkerType.circle, // Forma del marcador
                  width: 10, // Ancho del marcador
                  height: 10, // Alto del marcador
                  borderWidth: 2, // Grosor del borde del marcador
                  borderColor: Colors.blue, // Color del borde del marcador
                  color: Colors.white, // Color de relleno del marcador
                ),
                animationDuration: 0,
                onRendererCreated: (ChartSeriesController controller) {
                  _chartSeriesController = controller;
                },
                name: widget.legendsName.isNotEmpty ? widget.legendsName[0] : '',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _updateDataSource(Timer timer) async {
    try {
      MetricAux newData = await metricsservice.getAgents(widget.ruta);
      setState(() {
        // if (_chartData.length > 10) {
        //   _chartData.removeAt(0);
        // }
        DateTime now = DateTime.now();
        _chartData.removeWhere((data) =>
            DateTime.fromMillisecondsSinceEpoch(data.x as int)
                .isBefore(now.subtract(Duration(seconds: _visibleDuration))));

        _chartSeriesController?.updateDataSource(
          addedDataIndexes: [_chartData.length - 1],
        );
        _chartData.add(newData);
      });
    } catch (e) {
      // Manejo de errores
      print('Error al obtener datos: $e');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
