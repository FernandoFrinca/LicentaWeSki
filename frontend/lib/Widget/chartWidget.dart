import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../ConcretObjects/DistanceData.dart';

class chartWidget extends StatefulWidget {
  final DateTime? initialTime;
  final ValueNotifier<List<DistanceData>> realDistanceData;

  const chartWidget({
    required this.initialTime,
    required this.realDistanceData,
    Key? key,
  }) : super(key: key);

  @override
  _chartWidgetState createState() => _chartWidgetState();
}

class _chartWidgetState extends State<chartWidget> {

  @override
  void initState() {
    super.initState();
    widget.realDistanceData.addListener(updateChartData);
  }

  @override
  void dispose() {
    widget.realDistanceData.removeListener(updateChartData);
    super.dispose();
  }

  void updateChartData() {
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenDiagonal = sqrt(pow(screenHeight, 2) + pow(screenWidth, 2));
    final theme = Theme.of(context);

    final dataList = widget.realDistanceData.value;

    return SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      title: ChartTitle(
        text: 'Distance/hours',
        textStyle: TextStyle(
          fontSize: screenDiagonal * 0.02,
          fontWeight: FontWeight.w500,
          color: Color(theme.colorScheme.onSecondary.value).withOpacity(0.4),
          height: 0.8,
        ),
      ),
      legend: Legend(isVisible: false),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: <CartesianSeries<DistanceData, String>>[
        ColumnSeries<DistanceData, String>(
          dataSource: dataList,
          xValueMapper: (DistanceData data, _) => data.hour,
          yValueMapper: (DistanceData data, _) => data.distance,
          name: 'Distanta (km)',
          dataLabelSettings: DataLabelSettings(isVisible: true),
          color: Color(theme.colorScheme.primary.value),
        ),
      ],
    );
  }
}
