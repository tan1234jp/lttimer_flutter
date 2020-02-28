import 'dart:math';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class GaugeSegment {
  final String segment;
  final int size;
  GaugeSegment(this.segment, this.size);
}

class TimerChart extends StatelessWidget {
  void setData(String title, int value) {
    if (seriesList != null) {
      seriesList.clear();
    } else {
      seriesList = List<charts.Series>();
    }

    seriesList = [
      charts.Series<GaugeSegment, String>(
        id: 'Segments',
        domainFn: (segment, _) => segment.segment,
        measureFn: (segment, _) => segment.size,
        data: [
          GaugeSegment('Low', 80),
          GaugeSegment('High', 20),
        ],
      )
    ];
  }

  List<charts.Series> seriesList;

  @override
  Widget build(BuildContext context) {
    return charts.PieChart<dynamic>(
      seriesList,
      animate: false,
      defaultRenderer: charts.ArcRendererConfig<dynamic>(
        arcWidth: 30,
        startAngle: 4 / 5 * pi,
        arcLength: 7 / 5 * pi,
      ),
    );
  }
}
