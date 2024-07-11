import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zenithhabits/models/habit_model.dart';

class HabitData extends ChangeNotifier {
  CollectionReference get _habitsCollection {
    final email = FirebaseAuth.instance.currentUser?.email;
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(email)
        .collection('habits');
  }

  Stream<List<Habit>> getHabitList() {
    return _habitsCollection.snapshots().map((snapshot) => snapshot.docs
        .map(
            (doc) => Habit.fromMap(doc.data() as Map<String, dynamic>?, doc.id))
        .toList());
  }

  Future<void> addHabit(String name, bool isCompleted) async {
    try {
      await _habitsCollection.add({
        'name': name,
        'isCompleted': isCompleted,
      });
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  // Delete a habit by id
  Future<void> deleteHabit(String id) async {
    try {
      await _habitsCollection.doc(id).delete();
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  Future<void> updateHabitCompletion(String habitId, bool isCompleted) async {
    try {
      await _habitsCollection.doc(habitId).update({
        'isCompleted': isCompleted,
      });
      notifyListeners();

      // Calculate and record the daily completion rate after updating the habit
      calculateDailyCompletionRatio().listen((completionRatio) {
        double completionPercentage = completionRatio * 100;
        recordDailyCompletionRate(completionPercentage)
            .then((_) {})
            .catchError((error) {});
      });
    } catch (e) {
      return;
    }
  }

  Future<DateTime> getLastRecordDate() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw Exception('No user logged in');
    }

    var lastRecordSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser.email)
        .collection('dailyStats')
        .orderBy('date', descending: true)
        .limit(1)
        .get();

    if (lastRecordSnapshot.docs.isEmpty) {
      // Assuming that if there's no records, the app might be first used or records cleared.
      return DateTime.now().subtract(
          Duration(days: 1)); // to ensure today's rate will be recorded
    } else {
      Timestamp lastDate = lastRecordSnapshot.docs.first.data()['date'];
      return lastDate.toDate();
    }
  }

  Future<void> recordCompletionRate(double rate, DateTime date) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw Exception('No user logged in');
    }

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser.email)
        .collection('dailyStats')
        .doc(DateFormat('yyyy-MM-dd').format(date))
        .set({'completionRate': rate, 'date': date});
  }

  void checkAndRecordCompletion() async {
    try {
      DateTime lastRecordDate = await getLastRecordDate();
      DateTime today = DateTime.now();
      DateTime currentDate = DateTime(today.year, today.month, today.day);

      while (lastRecordDate.isBefore(currentDate)) {
        lastRecordDate = lastRecordDate.add(Duration(days: 1));
        if (lastRecordDate.isBefore(currentDate) ||
            lastRecordDate.isAtSameMomentAs(currentDate)) {
          await recordCompletionRate(0.0, lastRecordDate);
        }
      }
    } catch (e) {
      print("Error checking and recording completion: $e");
      // Handle errors appropriately in your app context
    }
  }

  // Assuming you're using a method within your HabitData class
  Future<void> recordDailyCompletionRate(double completionRate) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser.email)
          .collection('dailyStats')
          .doc(DateTime.now()
              .toString()
              .substring(0, 10)) // Use only the date part
          .set({
        'completionRate': completionRate,
        'date': DateTime.now(),
      });
    }
  }

  Stream<List<Map<String, dynamic>>> getWeeklyCompletionRates() {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw Exception('No user logged in');
    }

    DateTime now = DateTime.now();
    List<DateTime> last7Days = List.generate(
            7, (index) => DateTime(now.year, now.month, now.day - index))
        .reversed
        .toList();

    return FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser.email)
        .collection('dailyStats')
        .orderBy('date', descending: true)
        .limit(7)
        .snapshots()
        .map((snapshot) {
      var existingData = snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        var completionRate = data['completionRate'] as double;
        var date = data['date'];
        DateTime parsedDate =
            date is Timestamp ? date.toDate() : (date as DateTime);
        return {'completionRate': completionRate, 'date': parsedDate};
      }).toList();

      // Fill in missing days
      List<Map<String, dynamic>> allData = last7Days.map((day) {
        var found = existingData.firstWhere((data) {
          DateTime? existingDate = data['date'] as DateTime?;
          if (existingDate != null) {
            return DateTime(
                    existingDate.year, existingDate.month, existingDate.day) ==
                DateTime(day.year, day.month, day.day);
          }
          return false;
        }, orElse: () => {'completionRate': 0.0, 'date': day});
        return found;
      }).toList();

      return allData;
    });
  }

  // Stream<List<Map<String, dynamic>>> getWeeklyCompletionRates() {
  //   User? currentUser = FirebaseAuth.instance.currentUser;
  //   if (currentUser == null) {
  //     throw Exception('No user logged in');
  //   }

  //   return FirebaseFirestore.instance
  //       .collection('Users')
  //       .doc(currentUser.email)
  //       .collection('dailyStats')
  //       .orderBy('date', descending: true)
  //       .limit(7)
  //       .snapshots()
  //       .map((snapshot) => snapshot.docs.map((doc) {
  //             var data = doc.data() as Map<String, dynamic>;
  //             var completionRate = data['completionRate'] as double;
  //             var date = data['date'];
  //             DateTime parsedDate =
  //                 date is Timestamp ? date.toDate() : (date as DateTime);
  //             return {'completionRate': completionRate, 'date': parsedDate};
  //           }).toList());
  // }

  Stream<double> calculateDailyCompletionRatio() {
    return getHabitList().map((List<Habit> habits) {
      int completedCount = habits.where((habit) => habit.isCompleted).length;
      return completedCount / (habits.length == 0 ? 1 : habits.length);
    });
  }

  // Call this method when you want to reset habits at midnight
  Future<void> resetAllHabits() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      var batch = FirebaseFirestore.instance.batch();

      // Fetch the current user's habits
      var querySnapshot = await _habitsCollection.get();

      // Reset each habit's isCompleted to false
      for (var doc in querySnapshot.docs) {
        batch.update(doc.reference, {'isCompleted': false});
      }

      // Commit the batch update
      await batch.commit();

      notifyListeners();
    }
  }

  Future<DateTime> getLastResetTimestamp() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser.email)
          .get();

      Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;

      if (userData != null && userData.containsKey('lastResetTimestamp')) {
        Timestamp lastReset = userData['lastResetTimestamp'] as Timestamp;
        return lastReset.toDate();
      } else {
        return DateTime.now();
      }
    } else {
      throw Exception('No user logged in');
    }
  }

  Future<void> setLastResetTimestamp(DateTime timestamp) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser.email)
          .update({
        'lastResetTimestamp': timestamp,
      });
    }
  }
}
