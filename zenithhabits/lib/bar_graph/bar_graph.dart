import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zenithhabits/bar_graph/bar_data.dart';

class MyBarGraph extends StatelessWidget {
  final List<double> weeklySummary;
  final List<DateTime> dates; // Add this line

  const MyBarGraph({
    super.key,
    required this.weeklySummary,
    required this.dates, // Add this line
  });

  @override
  Widget build(BuildContext context) {
    BarData myBarData = BarData(weeklySummary: weeklySummary);

    myBarData.initializeBarData();

    return BarChart(BarChartData(
        maxY: 100,
        minY: 0,
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          show: true,
          topTitles: const AxisTitles(
              sideTitles: SideTitles(
            showTitles: false,
          )),
          leftTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  getTitlesWidget: (value, meta) => getBottomTitles(
                      value, meta, dates))), // Updated to use the new function,
        ),
        barGroups: myBarData.barData
            .map((data) => BarChartGroupData(x: data.x, barRods: [
                  BarChartRodData(
                      toY: data.y,
                      color: Theme.of(context).colorScheme.onInverseSurface,
                      width: 30,
                      borderRadius: BorderRadius.circular(7),
                      backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: 100,
                          color: Theme.of(context).colorScheme.onSecondary))
                ]))
            .toList()));
  }
}

Widget getBottomTitles(double value, TitleMeta meta, List<DateTime> dates) {
  const style =
      TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 18);

  DateTime date = dates[value.toInt()];
  String dayName;

  if (DateTime.now().difference(date).inDays == 0) {
    dayName = 'Today';
  } else {
    dayName = DateFormat('EEE')
        .format(date); // Using DateFormat from package:intl to format dates
  }

  Widget text = Text(dayName, style: style);

  return SideTitleWidget(axisSide: meta.axisSide, child: text);
}


// Widget getBottomTiles(double value, TitleMeta meta) {
//   const style =
//       TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 18);

//   Widget text;
//   switch (value.toInt()) {
//     case 0:
//       text = const Text(
//         'Today',
//         style: style,
//       );
//       break;
//     default:
//       text = const Text(
//         '',
//         style: style,
//       );
//   }

//   return SideTitleWidget(axisSide: meta.axisSide, child: text);
// }
