import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../utils/app_colors.dart';

class Task {
  final String id;
  final String title;
  final String description;
  final DateTime pickupDateTime;
  final DateTime deliveryDateTime;
  final Duration estimatedDuration;
  final String pickupLocation;
  final String deliveryLocation;
  final List<DeliveryType> deliveryTypes;
  final String status;
  final double amount;
  // Old task data
  final String weight;
  final String company;
  final LatLng pickupCoords;
  final LatLng deliveryCoords;
  final String distance;
  final String volume;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.pickupDateTime,
    required this.deliveryDateTime,
    required this.estimatedDuration,
    required this.pickupLocation,
    required this.deliveryLocation,
    required this.deliveryTypes,
    required this.status,
    required this.amount,
    required this.weight,
    required this.company,
    required this.pickupCoords,
    required this.deliveryCoords,
    required this.distance,
    required this.volume,
  });

  // Sample tasks for testing
  static List<Task> getSampleTasks() {
    return [
      Task(
        id: '1',
        title: 'Deliver Fresh Produce',
        description: 'Fresh vegetables and fruits delivery to local market',
        pickupDateTime: DateTime.now().add(const Duration(hours: 1)),
        deliveryDateTime: DateTime.now().add(const Duration(hours: 3)),
        estimatedDuration: const Duration(hours: 2),
        pickupLocation: '123 Farm Road, Rural Area',
        deliveryLocation: '456 Market Street, City Center',
        deliveryTypes: [DeliveryType.COLD, DeliveryType.FRAGILE],
        status: 'Pending',
        amount: 150.0,
        weight: '54.1 lbs',
        volume: '3.4 m³',
        company: 'Fresh Foods Inc',
        pickupCoords: const LatLng(52.2297, 21.0122),
        deliveryCoords: const LatLng(52.2497, 21.0422),
        distance: '15.5 km • 25 min EST',
      ),
      Task(
        id: '2',
        title: 'Transport Construction Materials',
        description: 'Building materials delivery to construction site',
        pickupDateTime: DateTime.now().add(const Duration(hours: 4)),
        deliveryDateTime: DateTime.now().add(const Duration(hours: 7)),
        estimatedDuration: const Duration(hours: 3),
        pickupLocation: '789 Warehouse Ave, Industrial Zone',
        deliveryLocation: '321 Construction Site, New Development',
        deliveryTypes: [DeliveryType.COVERED],
        status: 'Assigned',
        amount: 300.0,
        weight: '250.0 lbs',
        volume: '9.9 m³',
        company: 'BuildRight Construction',
        pickupCoords: const LatLng(52.2197, 20.9922),
        deliveryCoords: const LatLng(52.2397, 21.0222),
        distance: '22.3 km • 40 min EST',
      ),
      Task(
        id: '3',
        title: 'Medical Supplies Delivery',
        description: 'Urgent medical supplies to local hospital',
        pickupDateTime: DateTime.now().add(const Duration(minutes: 30)),
        deliveryDateTime: DateTime.now().add(const Duration(hours: 1, minutes: 30)),
        estimatedDuration: const Duration(hours: 1),
        pickupLocation: '567 Medical Depot, Healthcare District',
        deliveryLocation: '890 City Hospital, Downtown',
        deliveryTypes: [DeliveryType.FRAGILE],
        status: 'In Progress',
        amount: 200.0,
        weight: '32.6 lbs',
        volume: '2.3 m³',
        company: 'MediCare Supplies',
        pickupCoords: const LatLng(52.2397, 21.0322),
        deliveryCoords: const LatLng(52.2597, 21.0522),
        distance: '12.8 km • 20 min EST',
      ),
    ];
  }
} 