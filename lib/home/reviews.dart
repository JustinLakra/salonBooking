import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Components/utils.dart';

class ReviewPage extends StatefulWidget {
  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final TextEditingController bodyController = TextEditingController();
  final TextEditingController serviceController = TextEditingController();
  double rating = 3; // Default rating
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Write a Review'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: serviceController,
              decoration: const InputDecoration(
                labelText: 'Service',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: bodyController,
              decoration: const InputDecoration(
                labelText: 'Review',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Rating:'),
                const SizedBox(width: 16),
                Slider(
                  value: rating,
                  onChanged: (value) {
                    setState(() {
                      rating = value;
                    });
                  },
                  min: 1,
                  max: 5,
                  divisions: 4,
                  label: rating.toString(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Call function to add review to Firestore
                addReviewToFirestore();
              },
              child: const Text('Submit Review'),
            ),
          ],
        ),
      ),
    );
  }

  void addReviewToFirestore() async {
    try {
      User? user = auth.currentUser;

      if (user != null) {
        String uid = user.uid;

        // Create a new document with the specified fields
        await FirebaseFirestore.instance.collection('Reviews').add({
          'Body': bodyController.text,
          'Rating': rating,
          'Service': serviceController.text, // Replace with the actual service name
          'User': uid,
        });
        setState(() {
          bodyController.text = "";
          serviceController.text = "";
          rating = 3;
        });
        Utils.showSnackBar("Review posted");
        // Optionally, you can navigate to a different screen or show a success message.
        // Navigator.pop(context); // Close the review page
      } else {
        // Handle the case where the user is not authenticated
        print('User not authenticated');
      }
    } catch (error) {
      // Handle errors such as Firestore write errors
      print('Error adding review to Firestore: $error');
    }
  }
}

