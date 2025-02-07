import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class TasksPage extends StatefulWidget {
  final String? highlightedTaskId;
  
  const TasksPage({
    super.key,
    this.highlightedTaskId,
  });

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final ScrollController _scrollController = ScrollController();
  final double taskCardHeight = 200; // Approximate height of each task card
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Finished', 'Awaiting', 'Assigned'];
  List<LatLng> routePoints = [];
  final PolylinePoints polylinePoints = PolylinePoints();

  final List<Map<String, dynamic>> _tasks = [
    {
      'title': 'Solar Panel',
      'id': '#GE73895',
      'type': 'AWAITING',
      'weight': '54.1 lbs',
      'price': '€45.00',
      'company': 'Green Energy ITD',
      'location': 'Warszawa',
      'address': 'Warehouse Pickup - Okopowa 17/2, 01-042 Warszawa',
      'pickupCoords': const LatLng(55.2297, 23.0122),
      'distance': '55.9 km • 1 hour 1 min EST',
      'destination': 'Sochaczew',
      'destinationAddress': 'Warszawska 82, 96-515 Sochaczew',
      'destinationCoords': const LatLng(52.2297, 20.7810),
      'status': 'awaiting',
      'date': 'Today',
      'time': '15:30',
    },
    {
      'title': 'Fresh Fruits',
      'id': '#HFF7403',
      'type': 'ASSIGNED',
      'weight': '32.6 lbs',
      'price': '€32.50',
      'company': 'Happy Fresh Inc',
      'location': 'Central Market',
      'address': 'Market Square 123, 00-001 Warszawa',
      'pickupCoords': const LatLng(52.2369, 21.0127),
      'distance': '42.3 km • 45 min EST',
      'destination': 'Fresh Foods Store',
      'destinationAddress': 'Grocery Street 45, 01-234 Praga',
      'destinationCoords': const LatLng(52.2550, 21.0394),
      'status': 'assigned',
      'date': 'Today',
      'time': '13:15',
    },
    {
      'title': 'Electronics',
      'id': '#EL8901',
      'type': 'FINISHED',
      'weight': '25.3 lbs',
      'price': '€38.75',
      'company': 'Tech Solutions',
      'location': 'Tech Warehouse',
      'address': 'Industrial Park 78, 02-345 Wola',
      'pickupCoords': const LatLng(52.2320, 20.9532),
      'distance': '38.7 km • 52 min EST',
      'destination': 'Electronics Store',
      'destinationAddress': 'Digital Avenue 90, 03-456 Mokotów',
      'destinationCoords': const LatLng(52.1907, 21.0244),
      'status': 'finished',
      'date': 'Yesterday',
      'time': '16:45',
    },
  ];

  List<Map<String, dynamic>> get filteredTasks {
    if (_selectedFilter == 'All') {
      return _tasks;
    }
    return _tasks.where((task) => 
      task['type'] == _selectedFilter.toUpperCase()
    ).toList();
  }

  void _handleAcceptTask(String taskId) {
    setState(() {
      final taskIndex = _tasks.indexWhere((task) => task['id'] == taskId);
      if (taskIndex != -1) {
        _tasks[taskIndex] = {
          ..._tasks[taskIndex],
          'type': 'ASSIGNED',
          'status': 'assigned',
        };
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task accepted')),
        );
      }
    });
  }

  void _handleDeclineTask(String taskId) {
    setState(() {
      final taskIndex = _tasks.indexWhere((task) => task['id'] == taskId);
      if (taskIndex != -1) {
        _tasks[taskIndex] = {
          ..._tasks[taskIndex],
          'type': 'FINISHED',
          'status': 'finished',
        };
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task declined')),
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.highlightedTaskId != null) {
      // Scroll to highlighted task
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Find the task index and scroll to it
        final taskIndex = _tasks.indexWhere(
          (task) => task['id'] == widget.highlightedTaskId
        );
        if (taskIndex != -1) {
          // You'll need to add a ScrollController to your ListView
          _scrollController.animateTo(
            taskIndex * (taskCardHeight + 16), // Approximate position
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildUserCard(),
            _buildTaskFilters(),
            Expanded(
              child: _buildTasksList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Monday',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Dec 30, 2022',
                style: TextStyle(
                  color: AppColors.getSecondaryTextColor(context),
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.getCardColor(context),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
            child: Icon(
              Icons.person,
              color: isDark ? Colors.grey[300] : Colors.grey[600],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'David Russel',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'PO 12345',
                style: TextStyle(
                  color: AppColors.getSecondaryTextColor(context),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isDark ? Colors.green[900] : Colors.green[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'ONLINE',
              style: TextStyle(
                color: isDark ? Colors.green[300] : Colors.green,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskFilters() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'My Task',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.getTextColor(context),
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _filters.map((filter) {
                final isSelected = _selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(filter),
                    selected: isSelected,
                    backgroundColor: isDark ? Colors.grey[800] : Colors.white,
                    selectedColor: isDark ? Colors.grey[700] : Colors.white,
                    labelStyle: TextStyle(
                      color: isSelected 
                          ? (isDark ? Colors.white : Colors.black)
                          : AppColors.getSecondaryTextColor(context),
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    side: BorderSide(
                      color: isSelected 
                          ? (isDark ? Colors.white : Colors.black)
                          : (isDark ? Colors.grey[600]! : Colors.grey[300]!),
                      width: 1,
                    ),
                    onSelected: (bool selected) {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTasksList() {
    final tasks = filteredTasks;
    if (tasks.isEmpty) {
      return Center(
        child: Text(
          'No ${_selectedFilter.toLowerCase()} tasks found',
          style: TextStyle(color: AppColors.getSecondaryTextColor(context)),
        ),
      );
    }
    
    return ListView.separated(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: tasks.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final task = tasks[index];
        return _buildTaskCard(
          title: task['title'],
          id: task['id'],
          type: task['type'],
          weight: task['weight'],
          price: task['price'],
          location: task['location'],
          company: task['company'],
          address: task['address'],
          pickupCoords: task['pickupCoords'],
          distance: task['distance'],
          destination: task['destination'],
          destinationAddress: task['destinationAddress'],
          destinationCoords: task['destinationCoords'],
          status: task['status'],
        );
      },
    );
  }

  // Add this property to track expanded task
  String? _expandedTaskId;

  Widget _buildTaskCard({
    required String title,
    required String id,
    required String type,
    required String weight,
    required String price,
    required String location,
    required String company,
    required String address,
    required LatLng pickupCoords,
    required String distance,
    required String destination,
    required String destinationAddress,
    required LatLng destinationCoords,
    required String status,
  }) {
    final bool isHighlighted = widget.highlightedTaskId == id;
    final bool isExpanded = _expandedTaskId == id;
    
    Color getTypeColor(String taskType) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      switch (taskType) {
        case 'AWAITING':
          return isDark ? Colors.teal : const Color(0xFF1E6B5C);
        case 'ASSIGNED':
          return isDark ? Colors.amber : const Color(0xFFFFB74D);
        case 'FINISHED':
          return isDark ? Colors.grey[400]! : Colors.grey;
        default:
          return isDark ? Colors.grey[400]! : Colors.grey;
      }
    }

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => DraggableScrollableSheet(
            initialChildSize: 0.8,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            builder: (context, scrollController) => Container(
              decoration: BoxDecoration(
                color: AppColors.getCardColor(context),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    height: 4,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  SizedBox(
                    height: 300,
                    child: FutureBuilder<List<LatLng>>(
                      future: getRoutePoints(pickupCoords, destinationCoords),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          routePoints = snapshot.data!;
                        }
                        return FlutterMap(
                          options: MapOptions(
                            initialCenter: LatLng(
                              (pickupCoords.latitude + destinationCoords.latitude) / 2,
                              (pickupCoords.longitude + destinationCoords.longitude) / 2,
                            ),
                            initialZoom: 11,  // Reduced zoom to show more area
                            bounds: LatLngBounds.fromPoints([
                              pickupCoords,
                              destinationCoords,
                            ]),
                            boundsOptions: const FitBoundsOptions(
                              padding: EdgeInsets.all(50),
                            ),
                          ),
                          children: [
                            TileLayer(
                              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName: 'com.example.app',
                            ),
                            PolylineLayer(
                              polylines: [
                                Polyline(
                                  points: routePoints.isEmpty ? [pickupCoords, destinationCoords] : routePoints,
                                  color: const Color(0xFF1E6B5C),
                                  strokeWidth: 4.0,
                                ),
                              ],
                            ),
                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: pickupCoords,
                                  width: 80,
                                  height: 80,
                                  child: Icon(
                                    Icons.warehouse_outlined,
                                    color: const Color(0xFF1E6B5C),
                                    size: 40,
                                  ),
                                ),
                                Marker(
                                  point: LatLng(
                                    (pickupCoords.latitude + destinationCoords.latitude) / 2,
                                    (pickupCoords.longitude + destinationCoords.longitude) / 2 + 0.01,
                                  ),
                                  width: 100,
                                  height: 40,
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1E6B5C),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      distance,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                Marker(
                                  point: destinationCoords,
                                  width: 80,
                                  height: 80,
                                  child: const Icon(
                                    Icons.warehouse_outlined,
                                    color: Colors.orange,
                                    size: 40,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              company,
                              style: TextStyle(
                                color: AppColors.getSecondaryTextColor(context),
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildLocationRow(
                              icon: Icons.location_on,
                              iconColor: const Color(0xFF1E6B5C),
                              title: location,
                              subtitle: address,
                              taskId: id,
                            ),
                            if (distance.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(left: 32),
                                child: Text(
                                  distance,
                                  style: const TextStyle(
                                    color: Color(0xFF1E6B5C),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            const SizedBox(height: 16),
                            _buildLocationRow(
                              icon: Icons.location_on_outlined,
                              iconColor: Colors.orange,
                              title: destination,
                              subtitle: destinationAddress,
                              taskId: id,
                            ),
                            const SizedBox(height: 24),
                            if (type == 'AWAITING')
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () {
                                        _handleDeclineTask(id);
                                        Navigator.pop(context);
                                      },
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.red,
                                        side: const BorderSide(color: Colors.red),
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                      ),
                                      child: const Text('Reject'),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        _handleAcceptTask(id);
                                        Navigator.pop(context);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Theme.of(context).primaryColor,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                      ),
                                      child: const Text('Pickup Load'),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.getCardColor(context),
          borderRadius: BorderRadius.circular(16),
          border: isHighlighted ? Border.all(
            color: Theme.of(context).brightness == Brightness.dark 
                ? Colors.tealAccent
                : Theme.of(context).primaryColor,
            width: 2,
          ) : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.getTextColor(context),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5F3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          type == 'AWAITING' ? 'PICKUP' : type,
                          style: const TextStyle(
                            color: Color(0xFF1E6B5C),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            company,
                            style: TextStyle(
                              color: AppColors.getSecondaryTextColor(context),
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            id,
                            style: const TextStyle(
                              color: Colors.orange,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        price,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E6B5C),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'Today',
                        style: const TextStyle(
                          color: Color(0xFF1E6B5C),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '•',
                        style: TextStyle(
                          color: AppColors.getSecondaryTextColor(context),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Container, $weight',
                        style: TextStyle(
                          color: AppColors.getSecondaryTextColor(context),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E6B5C),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.warehouse_outlined,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          Container(
                            width: 2,
                            height: 30,
                            color: Colors.grey[300],
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.warehouse_outlined,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  location,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  address,
                                  style: TextStyle(
                                    color: AppColors.getSecondaryTextColor(context),
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8F5F3),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                distance,
                                style: const TextStyle(
                                  color: Color(0xFF1E6B5C),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  destination,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  destinationAddress,
                                  style: TextStyle(
                                    color: AppColors.getSecondaryTextColor(context),
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String taskId,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.teal
              : iconColor,
          size: 24
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: AppColors.getTextColor(context),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  color: AppColors.getSecondaryTextColor(context),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<List<LatLng>> getRoutePoints(LatLng start, LatLng end) async {
    final response = await http.get(Uri.parse(
      'https://router.project-osrm.org/route/v1/driving/'
      '${start.longitude},${start.latitude};'
      '${end.longitude},${end.latitude}'
      '?overview=full&geometries=polyline'
    ));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final String geometry = data['routes'][0]['geometry'];
      final points = polylinePoints.decodePolyline(geometry);
      return points.map((p) => LatLng(p.latitude, p.longitude)).toList();
    }
    return [start, end];
  }
} 