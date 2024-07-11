import 'package:zenithhabits/bar_graph/individual_bar.dart';

class BarData {
  // final double todayAmount;

  final List<double> weeklySummary;

  // BarData({required this.todayAmount});
  BarData({required this.weeklySummary});

  List<IndividualBar> barData = [];

  void initializeBarData() {
    // today
    // barData = [IndividualBar(x: 0, y: todayAmount)];

    barData = List.generate(weeklySummary.length,
        (index) => IndividualBar(x: index, y: weeklySummary[index]));
  }
}
