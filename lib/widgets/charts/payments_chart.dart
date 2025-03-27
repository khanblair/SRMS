import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class PaymentsChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  const PaymentsChart({
    super.key,
    required this.seriesList,
    this.animate = true,
  });

  factory PaymentsChart.withData(List<Map<String, dynamic>> data) {
    return PaymentsChart(
      seriesList: _createData(data),
      animate: false,
    );
  }

  factory PaymentsChart.sampleData() {
    return PaymentsChart(
      seriesList: _createSampleData(),
      animate: false,
    );
  }

  static List<charts.Series<TimeSeriesPayment, DateTime>> _createSampleData() {
    final data = [
      TimeSeriesPayment(DateTime(2023, 1), 45000),
      TimeSeriesPayment(DateTime(2023, 2), 56000),
      TimeSeriesPayment(DateTime(2023, 3), 38000),
      TimeSeriesPayment(DateTime(2023, 4), 62000),
      TimeSeriesPayment(DateTime(2023, 5), 51000),
    ];

    return [
      charts.Series<TimeSeriesPayment, DateTime>(
        id: 'Payments',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (TimeSeriesPayment payment, _) => payment.time,
        measureFn: (TimeSeriesPayment payment, _) => payment.amount,
        data: data,
      )
    ];
  }

  static List<charts.Series<TimeSeriesPayment, DateTime>> _createData(List<Map<String, dynamic>> data) {
    final chartData = data.map((item) {
      return TimeSeriesPayment(
        DateTime.parse(item['month']),
        (item['amount'] as num).toDouble(),
      );
    }).toList();

    return [
      charts.Series<TimeSeriesPayment, DateTime>(
        id: 'Payments',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (TimeSeriesPayment payment, _) => payment.time,
        measureFn: (TimeSeriesPayment payment, _) => payment.amount,
        data: chartData,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return charts.TimeSeriesChart(
      seriesList,
      animate: animate,
      defaultRenderer: charts.BarRendererConfig<DateTime>(),
      behaviors: [
        charts.ChartTitle('Monthly Payments',
            behaviorPosition: charts.BehaviorPosition.top),
        charts.SeriesLegend(),
        charts.SlidingViewport(),
        charts.PanAndZoomBehavior(),
      ],
      domainAxis: const charts.DateTimeAxisSpec(
        renderSpec: charts.SmallTickRendererSpec(
          labelStyle: charts.TextStyleSpec(
            fontSize: 10,
          ),
        ),
      ),
      primaryMeasureAxis: const charts.NumericAxisSpec(
        renderSpec: charts.GridlineRendererSpec(
          labelStyle: charts.TextStyleSpec(
            fontSize: 10,
          ),
        ),
      ),
    );
  }
}

class TimeSeriesPayment {
  final DateTime time;
  final double amount;

  TimeSeriesPayment(this.time, this.amount);
}