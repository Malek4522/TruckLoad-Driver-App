import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../utils/app_colors.dart';

class TaskDetailPage extends StatefulWidget {
  final Map<String, dynamic> task;

  const TaskDetailPage({
    super.key,
    required this.task,
  });

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  // Example coordinates - you should replace these with actual geocoded addresses
  static const LatLng _pickupLocation = LatLng(52.2297, 21.0122); // Warsaw
  static const LatLng _deliveryLocation = LatLng(52.2297, 20.7810); // Sochaczew

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                FlutterMap(
                  options: MapOptions(
                    initialCenter: _pickupLocation,
                    initialZoom: 12,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.app',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: _pickupLocation,
                          width: 80,
                          height: 80,
                          child: Icon(
                            Icons.location_on,
                            color: AppColors.getAccentColor(context),
                            size: 40,
                          ),
                        ),
                        Marker(
                          point: _deliveryLocation,
                          width: 80,
                          height: 80,
                          child: const Icon(
                            Icons.location_on,
                            color: Colors.orange,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Positioned(
                  top: 40,
                  left: 16,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.getCardColor(context),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildLocationInfo(
                  title: 'Pickup Location',
                  location: widget.task['location'],
                  address: widget.task['address'],
                  icon: Icons.location_on,
                  color: AppColors.getAccentColor(context),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Divider(),
                ),
                _buildLocationInfo(
                  title: 'Delivery Location',
                  location: widget.task['destination'],
                  address: widget.task['destinationAddress'],
                  icon: Icons.location_on_outlined,
                  color: Colors.orange,
                ),
                const SizedBox(height: 16),
                Text(
                  widget.task['distance'],
                  style: TextStyle(
                    color: AppColors.getSecondaryTextColor(context),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationInfo({
    required String title,
    required String location,
    required String address,
    required IconData icon,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, color: color),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                location,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                address,
                style: TextStyle(
                  color: AppColors.getSecondaryTextColor(context),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
} 