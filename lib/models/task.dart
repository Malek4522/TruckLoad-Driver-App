import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../utils/app_colors.dart';

enum TaskStatus {
  AWAITING,
  REJECTED,
  IN_WAY,
  ARRIVED,
  COMPLETED,
  ACCIDENT
}

extension TaskStatusExtension on TaskStatus {
  String get displayName {
    switch (this) {
      case TaskStatus.AWAITING:
        return 'Awaiting';
      case TaskStatus.REJECTED:
        return 'Rejected';
      case TaskStatus.IN_WAY:
        return 'In Way';
      case TaskStatus.ARRIVED:
        return 'Arrived';
      case TaskStatus.COMPLETED:
        return 'Completed';
      case TaskStatus.ACCIDENT:
        return 'Accident';
    }
  }

  Color get color {
    switch (this) {
      case TaskStatus.AWAITING:
        return Colors.blue;
      case TaskStatus.REJECTED:
        return Colors.red;
      case TaskStatus.IN_WAY:
        return Colors.orange;
      case TaskStatus.ARRIVED:
        return Colors.amber;
      case TaskStatus.COMPLETED:
        return Colors.green;
      case TaskStatus.ACCIDENT:
        return Colors.red;
    }
  }

  bool get canProgress {
    return this != TaskStatus.REJECTED && 
           this != TaskStatus.COMPLETED && 
           this != TaskStatus.ACCIDENT;
  }

  TaskStatus? get nextStatus {
    switch (this) {
      case TaskStatus.AWAITING:
        return TaskStatus.IN_WAY;
      case TaskStatus.IN_WAY:
        return TaskStatus.ARRIVED;
      case TaskStatus.ARRIVED:
        return TaskStatus.COMPLETED;
      default:
        return null;
    }
  }
}

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
  final TaskStatus status;
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

  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? pickupDateTime,
    DateTime? deliveryDateTime,
    Duration? estimatedDuration,
    String? pickupLocation,
    String? deliveryLocation,
    List<DeliveryType>? deliveryTypes,
    TaskStatus? status,
    double? amount,
    String? weight,
    String? company,
    LatLng? pickupCoords,
    LatLng? deliveryCoords,
    String? distance,
    String? volume,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      pickupDateTime: pickupDateTime ?? this.pickupDateTime,
      deliveryDateTime: deliveryDateTime ?? this.deliveryDateTime,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      deliveryLocation: deliveryLocation ?? this.deliveryLocation,
      deliveryTypes: deliveryTypes ?? this.deliveryTypes,
      status: status ?? this.status,
      amount: amount ?? this.amount,
      weight: weight ?? this.weight,
      company: company ?? this.company,
      pickupCoords: pickupCoords ?? this.pickupCoords,
      deliveryCoords: deliveryCoords ?? this.deliveryCoords,
      distance: distance ?? this.distance,
      volume: volume ?? this.volume,
    );
  }

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
        status: TaskStatus.AWAITING,
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
        status: TaskStatus.IN_WAY,
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
        status: TaskStatus.ARRIVED,
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

  // Update color-related code in the Task class
  static const Color defaultColor = Color(0xFF00359E); // Changed from green to blue #00359E

  // For dark mode, we might want to use a slightly lighter shade of the same blue
  static const Color darkModeColor = Color(0xFF1E4CAF); // Lighter shade of #00359E for better visibility in dark mode
} 