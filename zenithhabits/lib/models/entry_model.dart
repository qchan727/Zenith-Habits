import 'package:cloud_firestore/cloud_firestore.dart';

enum Mood { angry, sad, excited, relaxed, happy }

class Entry {
  final String id;
  final DateTime date;
  final String text;
  final Mood? mood;

  factory Entry.fromDocumentSnapshot(DocumentSnapshot doc) {
    return Entry(
      id: doc.id,
      text: doc['text'], 
      date: DateTime.parse(doc['date']),
      mood: Mood.values.firstWhere((mood) => mood.toString() == doc['mood']),
    );
  }

  Entry({
    required this.id,
    required this.date,
    required this.text,
    this.mood,
  });
}
