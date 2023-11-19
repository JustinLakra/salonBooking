import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Components/NavBar.dart';
import 'package:salon/home/serviceDetailsPage.dart';

class Home extends StatefulWidget {
  final String gender;
  const Home({required this.gender});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    final String gender = widget.gender;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(65),
        child: AppBar(
          backgroundColor: Colors.white,
          toolbarHeight: 65,
          title: const Text(
            "SHADOWZ",
            style: TextStyle(
              fontFamily: "Open Sans",
              fontSize: 40,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
        ),
      ),
      drawer: const NavBar(),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('Services').where('gender', isEqualTo: gender).snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                var service = snapshot.data!.docs[index];
                var about = service['about'] ?? '';
                var cost = service['cost'] ?? 0;
                var duration = service['duration'] ?? 0;
                var gender = service['gender'];

                return ListTile(
                    title: Text(service.id),
                    subtitle: Text('Cost: $cost ₹ | Duration: $duration mins | Gender: $gender'),
                    onTap: () {
                      // Navigate to ServiceDetailsPage when the ListTile is tapped
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) =>
                            ServiceDetailsPage(
                                serviceId: service.id,
                                about: about,
                                cost: cost,
                                duration: duration,
                                gender: gender
                            ),
                      ),
                      );
                    }
                );
              },
            );
          },
        ),
      ),
    );
  }
}