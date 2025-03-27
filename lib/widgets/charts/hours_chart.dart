import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class HoursChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  const HoursChart({
    super.key,
    required this.seriesList,
    this.animate = true,
  });

  factory HoursChart.sampleData() {
    return HoursChart(
      seriesList: _createSampleData(),
      animate: false,
    );
  }

  static List<charts.Series<TimeSeriesHours, DateTime>> _createSampleData() {
    final data = [
      TimeSeriesHours(DateTime(2023, 1), 45),
      TimeSeriesHours(DateTime(2023, 2), 56),
      TimeSeriesHours(DateTime(2023, 3), 38),
      TimeSeriesHours(DateTime(2023, 4), 62),
      TimeSeriesHours(DateTime(2023, 5), 51),
    ];

    return [
      charts.Series<TimeSeriesHours, DateTime>(
        id: 'Hours Worked',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesHours hours, _) => hours.time,
        measureFn: (TimeSeriesHours hours, _) => hours.hours,
        data: data,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return charts.TimeSeriesChart(
      seriesList,
      animate: animate,
      defaultRenderer: charts.LineRendererConfig(includeArea: true),
      behaviors: [
        charts.ChartTitle('Monthly Hours Worked',
            behaviorPosition: charts.BehaviorPosition.top),
        charts.SeriesLegend(),
        charts.SlidingViewport(),
        charts.PanAndZoomBehavior(),
      ],
    );
  }
}

class TimeSeriesHours {
  final DateTime time;
  final int hours;

  TimeSeriesHours(this.time, this.hours);
}