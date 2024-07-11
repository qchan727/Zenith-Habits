class Habit {
  final String id;
  final String name;
  bool isCompleted;


  Habit({
    required this.id,
    required this.name,
    this.isCompleted = false, 
  });

  // method to convert habit to a Map, which will be useful for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'isCompleted': isCompleted,
    };
  }

  factory Habit.fromMap(Map<String, dynamic>? map, String id) {
    if (map == null) {
      throw ArgumentError('Map cannot be null');
    }
    return Habit(
      id: id,
      name: map['name'] as String? ?? '',
      isCompleted: map['isCompleted'] as bool? ?? false,
    );
  }


}
