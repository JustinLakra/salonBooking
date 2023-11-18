import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReviewsViewPage extends StatefulWidget {
  @override
  _ReviewsViewPageState createState() => _ReviewsViewPageState();
}

class _ReviewsViewPageState extends State<ReviewsViewPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reviews'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Reviews').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          List<Widget> reviewWidgets = snapshot.data!.docs.map((DocumentSnapshot document) {
            var data = document.data() as Map<String, dynamic>;
            return ReviewWidget(data: data);
          }).toList();

          return ListView(
            children: reviewWidgets,
          );
        },
      ),
    );
  }
}

class ReviewWidget extends StatelessWidget {
  final Map<String, dynamic> data;

  ReviewWidget({required this.data});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Service: ${data['Service']}'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Rating: ${data['Rating']}'),
          Text('Review: ${data['Body']}'),
          FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance.collection('Users').doc(data['User']).get(),
            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.hasData) {
                  var userData = snapshot.data!.data() as Map<String, dynamic>?;

                  if (userData != null && userData.containsKey('Name')) {
                    return Text('User: ${userData['Name']}');
                  } else {
                    return Text('User: Unknown');
                  }
                } else {
                  return Text('User: Unknown');
                }
              } else {
                return Text('Loading user...');
              }
            },
          ),
        ],
      ),
    );
  }
}

