import 'dart:math';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class TimerChart extends StatelessWidget {
  TimerChart(this.seriesList, {this.animate});

  final List<charts.Series> seriesList;
  final bool animate;

  factory TimerChart.fromValue(
      {@required double value, @required Color color, bool animate}) {
    return TimerChart(
      _createDataFromValue(value, color),
      animate: animate,
    );
  }

  @override
  Widget build(BuildContext context) {
    return charts.PieChart<dynamic>(
      seriesList,
      animate: animate,
      defaultRenderer: charts.ArcRendererConfig<dynamic>(
        arcWidth: 20,
        startAngle: 3 / 5 * pi,
        arcLength: 9 / 5 * pi,
      ),
    );
  }

  static List<charts.Series<TimerSegment, String>> _createDataFromValue(
      double value, Color color) {
    double toShow = (1 + value) / 2;
    final data = [
      TimerSegment('Main', toShow, color),
      TimerSegment('Rest', 1 - toShow, Colors.transparent),
    ];

    return [
      charts.Series<TimerSegment, String>(
        id: 'Segments',
        domainFn: (segment, _) => segment.segment,
        measureFn: (segment, _) => segment.value,
        colorFn: (segment, _) => segment.color,
        labelAccessorFn: (segment, _) =>
            segment.segment == 'Main' ? '${segment.value}' : null,
        data: data,
      )
    ];
  }
}

class TimerSegment {
  TimerSegment(this.segment, this.value, Color color)
      : this.color = charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);

  final String segment;
  final double value;
  final charts.Color color;
}
