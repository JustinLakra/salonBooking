import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../main.dart';

class AppointmentsScreen extends StatefulWidget {
  final String selectedService;
  final String gender;
  final int cost;

  const AppointmentsScreen({Key? key, required this.selectedService, required this.gender, required this.cost}) : super(key: key);

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  late String selectedService;
  late String gender;
  late int cost;
  final CollectionReference appointments = FirebaseFirestore.instance.collection('Appointments');

  @override
  void initState() {
    super.initState();
    selectedService = widget.selectedService;
    gender = widget.gender;
    cost = widget.cost;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointments for $selectedService'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: appointments.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
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
                      builder: (context) => SlotsPage(date: date, selectedService: selectedService, gender: gender, cost: cost),
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
  final String gender;
  final int cost;

  const SlotsPage({required this.date, required this.selectedService, required this.gender, required this.cost});

  Future<void> showPopup(BuildContext context, String slot, String date, String selectedService, String gender) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to book $selectedService on $date for $gender from $slot?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Close the popup
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
            TextButton(
              onPressed: () async {
                //await confirmBooking(slot, date, selectedService, gender, "Online");
                await _showPaymentPopup(context, slot, date, selectedService, gender, "Online", cost);
                //Navigator.of(context).pop();// Close the popup after confirming
                //Todo qr
              },
              child: const Text('Online Payment'),
            ),
            TextButton(
              onPressed: () async {
                await confirmBooking(slot, date, selectedService, gender, "Offline, COD", cost);
                Navigator.of(context).pop();// Close the popup after confirming
                navigatorKey.currentState!.popUntil((route) => route.isFirst);
              },
              child: const Text('Offline Payment'),
            ),
          ],
        );
      },
    );
  }
  Future<void> _showPaymentPopup (BuildContext context, String slot, String date, String service, String gender, String mode, int cost) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Payment Details'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                // QR code image
                /*QrImageView(
                  data: 'Your QR Code Data Here', // Replace with your actual data
                  version: QrVersions.auto,
                  size: 150,
                ),*/
                Image.asset('assets/qrCode.png'),
                SizedBox(height: 16.0),
                // Pay button
                ElevatedButton(
                  onPressed: () async{
                    await confirmBooking(slot, date, selectedService, gender, "Online", cost);
                    Navigator.of(context).pop();
                    navigatorKey.currentState!.popUntil((route) => route.isFirst);
                  },
                  child: Text('Pay'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> confirmBooking(String slot, String date, String service, String gender, String mode, int cost) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('Appointments').doc(date).get();

      if (snapshot.exists) {
        Map<String, dynamic>? appointmentData = snapshot.data() as Map<String, dynamic>?;

        //if (appointmentData != null && appointmentData.containsKey(slot)) {
          //Map<String, dynamic>? slots = appointmentData[slot] as Map<String, dynamic>?;

          if (appointmentData != null && appointmentData.containsKey(slot)) {
            appointmentData[slot]['Status'] = 'Waiting for staff to be assigned';
            appointmentData[slot]['Service'] = '$service - $gender';
            appointmentData[slot]['Availability'] = 'booked';
            appointmentData[slot]['User'] = FirebaseAuth.instance.currentUser!.uid;
            appointmentData[slot]['Mode'] = mode;

            // Update the document with the modified 'slots' field
            await FirebaseFirestore.instance.collection('Appointments').doc(date).update({slot: appointmentData[slot]});
            var now = DateTime.now();
            String time = now.day.toString() + '/' + now.month.toString() + '/' + now.year.toString()+ "," +now.hour.toString() + ':' + now.minute.toString();

            return await FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).update({
              'Notifications.${"You have succesfully booked " + service + " for " + gender + " on " + date  + " from " + slot + " for  ₹" + cost.toString() + " !" + "Your payment mode is " + mode + "forbidden_character_period"}':
              time,

            }

            );

          } else {
            print('Slot not found in the document');
          }
        } else {
          print('Invalid document structure');
        }
      //} else {
        //print('Document does not exist');
      //}
    } catch (error) {
      print('Error updating document: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Slots for $date'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('Appointments').doc(date).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
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

              return ListTile(
                title: Text('Slot: $slot'),
                onTap: () {
                  showPopup(context, slot, date, selectedService, gender);
                },
              );
            },
          );
        },
      ),
    );
  }
}


