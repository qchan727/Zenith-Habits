import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zenithhabits/bar_graph/bar_graph.dart';
import 'package:zenithhabits/data/habit_data.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  // List<double> dailySummary = [30];

  // @override
  // Widget build(BuildContext context) {
  //   // Create test weekly summary and dates
  //   List<double> weeklySummary = [
  //     75,
  //     50,
  //     80,
  //     60,
  //     90,
  //     45,
  //     70,
  //   ]; // Test completion percentages
  //   List<DateTime> dates = List.generate(
  //           7, (index) => DateTime.now().subtract(Duration(days: index)))
  //       .reversed
  //       .toList();

  //   // Use these test data directly in the MyBarGraph
  //   return Scaffold(
  //     body: Padding(
  //       padding: const EdgeInsets.all(30.0),
  //       child: Center(
  //         child: Container(
  //           height: 400,
  //           decoration: BoxDecoration(
  //             color: Theme.of(context).colorScheme.onBackground,
  //             borderRadius: BorderRadius.circular(20.0),
  //             boxShadow: [
  //               BoxShadow(
  //                 color: Colors.black.withOpacity(0.3),
  //                 offset: const Offset(0, 4),
  //                 blurRadius: 2.0,
  //               ),
  //             ],
  //           ),
  //           padding: const EdgeInsets.all(20),
  //           child: MyBarGraph(
  //             weeklySummary: weeklySummary,
  //             dates: dates,
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: Provider.of<HabitData>(context, listen: false)
          .getWeeklyCompletionRates(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print("LOOKING AT DATA");
          print("Snapshot Data: ${snapshot.data}");
          List<double> weeklySummary = snapshot.data!
              .map((data) => data['completionRate'] as double)
              .toList();

          List<DateTime> dates = snapshot.data!.map((data) {
            print(
                "Date Data: ${data['date']}, Type: ${data['date'].runtimeType}");
            if (data['date'] is Timestamp) {
              return (data['date'] as Timestamp).toDate();
            } else if (data['date'] is DateTime) {
              return data['date']
                  as DateTime; // If already DateTime, just use it directly
            } else {
              throw FormatException("Date is not in expected format");
            }
          }).toList();

          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Center(
                child: Container(
                  height: 400,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onBackground,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: const Offset(0, 4),
                        blurRadius: 2.0,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20),
                  child: MyBarGraph(
                    weeklySummary: weeklySummary,
                    dates: dates, // Make sure to pass the dates here
                  ),
                ),
              ),
            ),
          );
        } else {
          return CircularProgressIndicator(); // Or some other placeholder widget
        }
      },
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return StreamBuilder<double>(
  //     stream: Provider.of<HabitData>(context, listen: false)
  //         .calculateDailyCompletionRatio(),
  //     builder: (context, snapshot) {
  //       if (snapshot.hasData) {
  //         double dailyCompletionRatio = snapshot.data!;
  //         double dailyCompletionPercentage = dailyCompletionRatio * 100;

  //         return Scaffold(
  //           body: Padding(
  //             padding: const EdgeInsets.all(30.0),
  //             child: Center(
  //               child: Container(
  //                 height: 500,
  //                 decoration: BoxDecoration(
  //                   color: Theme.of(context).colorScheme.onBackground,
  //                   borderRadius: BorderRadius.circular(20.0),
  //                   boxShadow: [
  //                     BoxShadow(
  //                       color: Colors.black.withOpacity(0.3),
  //                       offset: const Offset(0, 4),
  //                       blurRadius: 2.0,
  //                     ),
  //                   ],
  //                 ),
  //                 padding: const EdgeInsets.all(20),
  //                 child: MyBarGraph(
  //                   weeklySummary: [dailyCompletionPercentage],
  //                 ),
  //               ),
  //             ),
  //           ),
  //         );
  //       } else {
  //         // Handle the case where there is no data yet, or an error occurred
  //         return CircularProgressIndicator(); // Or some other placeholder widget
  //       }
  //     },
  //   );
  // }
}
