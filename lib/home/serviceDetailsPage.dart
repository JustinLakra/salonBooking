import 'package:flutter/material.dart';
import 'package:salon/Components/Navigators.dart';
import 'package:salon/home/bookAnAppointmentPage.dart';

class ServiceDetailsPage extends StatelessWidget {
  final String serviceId;
  final String about;
  final int cost;
  final int duration;

  const ServiceDetailsPage({
    required this.serviceId,
    required this.about,
    required this.cost,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Service ID: $serviceId'),
            Text('About: $about'),
            Text('Cost: $cost'),
            Text('Duration: $duration'),
            ElevatedButton(
                onPressed: (){
                  navigation().navigateToPage(context, AppointmentsScreen(selectedService: serviceId));
                },
                child: const Text(
                  'Book an appointment',
                ),
            )
          ],
        ),
      ),
    );
  }
}