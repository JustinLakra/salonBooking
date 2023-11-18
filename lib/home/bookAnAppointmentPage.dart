import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentsScreen extends StatefulWidget {

  final String selectedService;
  const AppointmentsScreen({Key? key, required this.selectedService})
      : super(key: key);

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {

  late String selectedService;
  final CollectionReference appointments =
  FirebaseFirestore.instance.collection('Appointments');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedService = widget.selectedService;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointments for ${widget.selectedService}'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: appointments.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              var appointment = snapshot.data!.docs[index];
              var date = appointment.id;

              return ListTile(
                title: Text(date),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SlotsPage(date: date, selectedService: widget.selectedService,),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}


class SlotsPage extends StatelessWidget {
  final String date;
  final String selectedService;

  const SlotsPage({required this.date, required this.selectedService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Slots for $date'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Appointments')
            .doc(date)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          var documentData = snapshot.data!.data() as Map<String, dynamic>? ?? {};
          var slots = documentData.entries.where((entry) {
            var slot = entry.value;
            return slot is Map<String, dynamic> &&
                slot.containsKey('Status') &&
                slot['Status'] == 'Available';
          }).toList();

          return ListView.builder(
            itemCount: slots.length,
            itemBuilder: (BuildContext context, int index) {
              var entry = slots[index];
              var slot = entry.key;

              // Display the entire slot map
              return ListTile(
                title: Text('Slot: $slot'),
                onTap: (){

                },
              );
            },
          );
        },
      ),
    );
  }
}
