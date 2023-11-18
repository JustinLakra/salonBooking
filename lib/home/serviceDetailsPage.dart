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
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    'Service ID: $serviceId',
                    style: const TextStyle(
                      fontSize: 30,
                    ),
                  ),
                  Text(
                    'About: $about',
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    'Cost: $cost',
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    'Duration: $duration',
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                child: ElevatedButton(
                    onPressed: (){
                      navigation().navigateToPage(context, AppointmentsScreen(selectedService: serviceId));
                    },
                    child: const Text(
                      'Book an appointment',
                    ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}