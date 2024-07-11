import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zenithhabits/data/habit_data.dart';
import 'package:zenithhabits/models/habit_model.dart';

class TodayPage extends StatefulWidget {
  const TodayPage({super.key});

  @override
  State<StatefulWidget> createState() => _TodayPageState();
}

class _TodayPageState extends State<TodayPage> {
  final newHabitNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      resetHabitsIfNewDay();
    });
  }

  void createNewHabit() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Create new habit"),
        content: TextField(
          controller: newHabitNameController,
        ),
        actions: [
          MaterialButton(
            onPressed: save,
            child: const Text("Save"),
          ),
          MaterialButton(
            onPressed: cancel,
            child: const Text("Cancel"),
          )
        ],
      ),
    );
  }

  void save() {
    String newHabitName = newHabitNameController.text;
    Provider.of<HabitData>(context, listen: false)
        .addHabit(newHabitName, false);
    Navigator.pop(context);
    clear();
  }

  void cancel() {
    Navigator.pop(context);
    clear();
  }

  void clear() {
    newHabitNameController.clear();
  }

  void updateHabitCompletion(String habitId, bool isCompleted) {
    Provider.of<HabitData>(context, listen: false)
        .updateHabitCompletion(habitId, isCompleted);
  }

  void deleteHabit(String habitId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Habit"),
        content: const Text("Are you sure you want to delete this habit?"),
        actions: <Widget>[
          MaterialButton(
            child: const Text("Delete"),
            onPressed: () {
              Provider.of<HabitData>(context, listen: false)
                  .deleteHabit(habitId);
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
          MaterialButton(
            child: const Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
        ],
      ),
    );
  }

  void resetHabitsIfNewDay() async {
    DateTime lastResetTimestamp;
    DateTime now = DateTime.now();
    DateTime today =
        DateTime(now.year, now.month, now.day, now.hour, now.minute);

    var habitData = Provider.of<HabitData>(context, listen: false);

    lastResetTimestamp = await habitData.getLastResetTimestamp();

    if (!mounted) return;

    if (lastResetTimestamp.day != today.day) {
      await habitData.resetAllHabits();
      await habitData.setLastResetTimestamp(now);
    }
    // used to test the function
    // if (lastResetTimestamp.isBefore(today)) {
    //   await habitData.resetAllHabits();
    //   await habitData.setLastResetTimestamp(now);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 14, bottom: 14, left: 24, right: 24),
      child: Scaffold(
        // appBar: AppBar(title: const Text("Today")),
        floatingActionButton: FloatingActionButton(
          onPressed: createNewHabit,
          child: const Icon(Icons.add),
        ),
        body: Consumer<HabitData>(
          builder: (context, habitData, _) {
            return StreamBuilder<List<Habit>>(
              stream: habitData.getHabitList(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                List<Habit>? habits = snapshot.data;
                if (habits == null || habits.isEmpty) {
                  return const Center(child: Text("No habits found."));
                }
                return ListView.builder(
                  itemCount: habits.length,
                  itemBuilder: (context, index) {
                    final habit = habits[index];
                    return Padding(
                      padding: const EdgeInsets.only(top: 14),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: Theme.of(context).colorScheme.onBackground,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black
                                  .withOpacity(0.1), // Shadow color and opacity
                              offset: const Offset(0,
                                  3), // Vertical offset to create bottom shadow
                              blurRadius: 4.0, // Blur radius for shadow
                            ),
                          ],
                        ),
                        child: ListTile(
                          title: Text(habit.name),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Checkbox(
                                value: habit.isCompleted,
                                onChanged: (newValue) {
                                  updateHabitCompletion(habit.id, newValue!);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => deleteHabit(habit.id),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
