import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zenithhabits/models/entry_model.dart';

class EntryData extends ChangeNotifier {
  CollectionReference get _entriesCollection {
    final email = FirebaseAuth.instance.currentUser?.email; 
    return FirebaseFirestore.instance 
      .collection('Users')
      .doc(email)
      .collection('entries');
  }
  
  // Add an entry
  Future<void> addEntry(String text, DateTime date, Mood mood) async {
    try {
      await _entriesCollection.add({
        'text' : text, 
        'date' : date.toIso8601String(), 
        'mood' : mood.toString(), 
        //'userId' : FirebaseAuth.instance.currentUser?.email ?? "unknown",
      });
      notifyListeners();
    } catch (e) {
      exit(1);
    }
  }

  Stream<List<Entry>> getEntries() {
    return _entriesCollection
      .snapshots()
      .map((snapshot) => snapshot.docs
           .map((doc) => Entry.fromDocumentSnapshot(doc))
           .toList());
  }

  // Delete an entry by id
  Future<void> deleteEntry(String id) async {
    try {
      await _entriesCollection.doc(id).delete();
      notifyListeners();
    } catch (e) {
      exit(1);
    }

  }
}
