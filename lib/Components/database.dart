/// The DatabaseService class provides methods for interacting with the Firebase Cloud Firestore
/// database, including setting and updating user data, submitting project and feedback data, and
/// retrieving leaderboard data.
// ignore_for_file: non_constant_identifier_names, unused_catch_clause,
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;

  DatabaseService({required this.uid});

  // collection reference
  final CollectionReference brewCollection =
  FirebaseFirestore.instance.collection('Users');

  /// The function sets initial user data in a Firestore document with various fields such as name,
  /// email, class, registration number, points, streak, course, and arrays for tracking progress.
  ///
  /// Args:
  ///   Class (String): The class or grade of the user.
  ///   Name (String): The name of the user.
  ///   reg (String): Registration number of the user.
  ///   email (String): The email address of the user.
  ///   points (int): An integer representing the initial number of points for the user.
  ///   streak (int): The coding streak of the user, which refers to the number of consecutive days the
  /// user has completed coding challenges or activities.
  ///   course (String): The main course that the user is enrolled in.
  ///   length (int): The length parameter is an integer that specifies the length of the list to be
  /// created with List.filled() method. The list will be filled with 0 values and will have a fixed
  /// length specified by the length parameter.
  ///
  /// Returns:
  ///   a `Future<void>`.
  Future<void> setInitialUserData( String Name,  String phone,
      String email,) async {
    var now = DateTime.now();
    String time = now.day.toString() + '/' + now.month.toString() + '/' + now.year.toString()+ "," +now.hour.toString() + ':' + now.minute.toString();

    return await brewCollection.doc(uid).set({
      'Name': Name,
      'Email': email,
      'Phone No': phone,
      'Notifications':{"Welcome to the Salon, " + Name + "!" + " We are excited to have you on board!": time},
      'Appointments':{},

    });
  }
  Future<void> setEditedUserData( String Name, String Department, String phone,
       String roll, String room, String year) async {
    return await brewCollection.doc(uid).update({
      'Name': Name,
      'Phone No': phone,
      'Roll No': roll,
      'Room No': room,
      'Department': Department,
      'Year Of Graduation': year
    });
  }


}
