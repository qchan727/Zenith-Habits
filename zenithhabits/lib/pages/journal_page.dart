import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zenithhabits/data/entry_data.dart';
import 'package:intl/intl.dart';
import 'package:zenithhabits/models/entry_model.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  final entryTextController = TextEditingController();
  Mood? selectedMood; // Track the selected mood

  void createNewEntry() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Create new entry"),
        content: SingleChildScrollView(
          // Use SingleChildScrollView to avoid overflow
          child: Column(
              mainAxisSize:
                  MainAxisSize.min, // To make the column wrap its content
              children: [
                TextField(
                  controller: entryTextController,
                  decoration:
                      const InputDecoration(hintText: "What's on your mind?"),
                ),
                const SizedBox(height: 20), // Add some spacing
                // Mood selection row
                MoodSelector(onMoodSelected: (mood) {
                  selectedMood = mood;
                })
              ]),
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              final text = entryTextController.text;
              if (text.isNotEmpty && selectedMood != null) {
                Provider.of<EntryData>(context, listen: false).addEntry(
                  text,
                  DateTime.now(),
                  selectedMood!,
                );
                Navigator.pop(context);
                entryTextController.clear();
                selectedMood = null; // Reset selected mood
              }
            },
            child: const Text("Save"),
          ),
          MaterialButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  void deleteEntryDialog(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Entry"),
        content: const Text("Are you sure you want to delete this entry?"),
        actions: [
          MaterialButton(
            onPressed: () {
              Provider.of<EntryData>(context, listen: false).deleteEntry(id);
              Navigator.of(context).pop();
            },
            child: const Text("Delete"),
          ),
          MaterialButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  void saveEntry() {
    if (selectedMood != null) {
      // Assuming you have a method to add an entry, include the selected mood
      Provider.of<EntryData>(context, listen: false).addEntry(
        entryTextController.text,
        DateTime.now(),
        selectedMood!,
      );
      Navigator.pop(context);
      entryTextController.clear();
      selectedMood = null; // Reset selected mood
    }
  }

  // Function to get an icon for each mood
  IconData? getMoodIcon(Mood? mood) {
    switch (mood) {
      case Mood.angry:
        return Icons.sentiment_very_dissatisfied;
      case Mood.sad:
        return Icons.sentiment_dissatisfied;
      case Mood.excited:
        return Icons.sentiment_satisfied;
      case Mood.relaxed:
        return Icons.sentiment_satisfied_alt;
      case Mood.happy:
        return Icons.sentiment_very_satisfied;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EntryData>(
      builder: (context, entryData, child) => Padding(
        padding:
            const EdgeInsets.only(top: 14, bottom: 14, left: 24, right: 24),
        child: Scaffold(
          // appBar: AppBar(
          //   title: const Text("Journal"),
          // ),
          floatingActionButton: FloatingActionButton(
            onPressed: createNewEntry,
            child: const Icon(Icons.add),
          ),
          body: StreamBuilder<List<Entry>>(
            stream: entryData.getEntries(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("No entries found"));
              }

              var sortJournal = snapshot.data!;
              sortJournal.sort((a, b) => b.date.compareTo(a.date));
              return ListView.builder(
                itemCount: sortJournal.length,
                itemBuilder: (context, index) {
                  final entry = snapshot.data![index];
                  return buildEntryItem(entry);
                },
              );
              /*final entry = entryData.getEntries()[index];

              );*/
            },
          ),
        ),
      ),
    );
  }

  Widget buildEntryItem(Entry entry) {
    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: Theme.of(context).colorScheme.onBackground,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1), // Shadow color and opacity
              offset:
                  const Offset(0, 3), // Vertical offset to create bottom shadow
              blurRadius: 4.0, // Blur radius for shadow
            ),
          ],
        ),
        child: ListTile(
            title: Text(entry.text.length > 30
                ? entry.text.substring(0, 30) + "..."
                : entry.text),
            subtitle: Text(DateFormat('yyyy-MM-dd – kk:mm').format(entry.date)),
            trailing: Row(
              mainAxisSize: MainAxisSize
                  .min, // This ensures the row takes up minimal space
              children: [
                // Mood icon
                if (getMoodIcon(entry.mood) !=
                    null) // Check if getMoodIcon returns null
                  Icon(getMoodIcon(entry.mood)),

                // A small space between the icons
                const SizedBox(width: 10),
                // Delete icon
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    // Your existing delete functionality
                    deleteEntryDialog(entry.id);
                  },
                ),
              ],
            ),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                        icon: Icon(getMoodIcon(entry.mood)),
                        title: Text(entry.date.year.toString() + "-" + entry.date.month.toString() + "-" + entry.date.day.toString()),
                        content: Text(entry.text),
                        actions: [
                          ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Close'))
                        ]);
                  });
            }),
      ),
    );
  }
}

class MoodSelector extends StatefulWidget {
  final Function(Mood mood) onMoodSelected;

  const MoodSelector({super.key, required this.onMoodSelected});

  @override
  // ignore: library_private_types_in_public_api
  _MoodSelectorState createState() => _MoodSelectorState();
}

class _MoodSelectorState extends State<MoodSelector> {
  Mood? selectedMood;

  IconData? getMoodIcon(Mood? mood) {
    switch (mood) {
      case Mood.angry:
        return Icons.sentiment_very_dissatisfied; // Choose a different icon
      case Mood.sad:
        return Icons.sentiment_dissatisfied;
      case Mood.excited:
        return Icons.sentiment_satisfied; // Choose a different icon
      case Mood.relaxed:
        return Icons.sentiment_satisfied_alt; // Choose a different icon
      case Mood.happy:
        return Icons.sentiment_very_satisfied;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: Mood.values.map((mood) {
        return IconButton(
          icon: Icon(
            getMoodIcon(mood),
            color: selectedMood == mood
                ? Theme.of(context).colorScheme.onInverseSurface
                : Theme.of(context).colorScheme.secondary,
          ),
          onPressed: () {
            setState(() {
              selectedMood = mood;
            });
            widget.onMoodSelected(mood);
          },
        );
      }).toList(),
    );
  }
}
