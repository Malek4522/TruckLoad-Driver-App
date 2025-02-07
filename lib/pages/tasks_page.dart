import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../utils/app_localizations.dart';

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
  final double taskCardHeight = 200;
  String _selectedFilter = 'all';
  final List<String> _filters = ['all', ...TaskStatus.values.map((e) => e.displayName)];
  List<LatLng> routePoints = [];
  final PolylinePoints polylinePoints = PolylinePoints();
  late List<Task> _tasks;

  @override
  void initState() {
    super.initState();
    _tasks = Task.getSampleTasks();
    if (widget.highlightedTaskId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final taskIndex = _tasks.indexWhere(
          (task) => task.id == widget.highlightedTaskId
        );
        if (taskIndex != -1) {
          _scrollController.animateTo(
            taskIndex * (taskCardHeight + 16),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  void _handleAcceptTask(String taskId) {
    setState(() {
      final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
      if (taskIndex != -1) {
        final oldTask = _tasks[taskIndex];
        _tasks[taskIndex] = oldTask.copyWith(status: TaskStatus.IN_WAY);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task accepted')),
        );
      }
    });
  }

  void _handleDeclineTask(String taskId) {
    setState(() {
      final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
      if (taskIndex != -1) {
        final oldTask = _tasks[taskIndex];
        _tasks[taskIndex] = oldTask.copyWith(status: TaskStatus.REJECTED);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task declined')),
        );
      }
    });
  }

  void _handleProgressTask(String taskId) {
    setState(() {
      final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
      if (taskIndex != -1) {
        final oldTask = _tasks[taskIndex];
        final nextStatus = oldTask.status.nextStatus;
        if (nextStatus != null) {
          _tasks[taskIndex] = oldTask.copyWith(status: nextStatus);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Task status updated to ${nextStatus.displayName}')),
          );
        }
      }
    });
  }

  void _handleAccident(String taskId) {
    setState(() {
      final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
      if (taskIndex != -1) {
        final oldTask = _tasks[taskIndex];
        _tasks[taskIndex] = oldTask.copyWith(status: TaskStatus.ACCIDENT);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Task marked as accident'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(loc),
            _buildUserCard(),
            _buildTaskFilters(loc),
            Expanded(
              child: _buildTasksList(loc),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations loc) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                loc.get('tasks'),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                DateFormat('MMM dd, yyyy').format(DateTime.now()),
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

  Widget _buildTaskFilters(AppLocalizations loc) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            loc.get('my_tasks'),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.getTextColor(context),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _filters.length,
              itemBuilder: (context, index) {
                final filter = _filters[index];
                final isSelected = _selectedFilter == filter;
                final taskStatus = filter == 'all' 
                    ? null 
                    : TaskStatus.values.firstWhere(
                        (status) => status.displayName == filter
                      );

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(
                      filter == 'all' ? loc.get('all_tasks') : filter,
                      style: TextStyle(
                        color: isSelected 
                            ? Colors.white 
                            : taskStatus?.color ?? Theme.of(context).textTheme.bodyMedium?.color,
                        fontWeight: isSelected ? FontWeight.bold : null,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _selectedFilter = filter);
                      }
                    },
                    backgroundColor: taskStatus?.color.withOpacity(0.1) ?? 
                        (Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey[800]
                            : Colors.white),
                    selectedColor: taskStatus?.color ?? Theme.of(context).primaryColor,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    showCheckmark: false,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTasksList(AppLocalizations loc) {
    final filteredTasks = _tasks.where((task) {
      if (_selectedFilter == 'all') return true;
      return task.status.displayName == _selectedFilter;
    }).toList();

    if (filteredTasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assignment_outlined,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              loc.get('no_tasks'),
              style: TextStyle(
                color: AppColors.getSecondaryTextColor(context),
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: filteredTasks.length,
      itemBuilder: (context, index) => _buildTaskCard(context, filteredTasks[index]),
    );
  }

  Widget _buildTaskCard(BuildContext context, Task task) {
    final bool isHighlighted = widget.highlightedTaskId == task.id;

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
                      future: getRoutePoints(
                        task.pickupCoords,
                        task.deliveryCoords,
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          routePoints = snapshot.data!;
                        }
                        return FlutterMap(
                          options: MapOptions(
                            initialCenter: LatLng(
                              (task.pickupCoords.latitude + task.deliveryCoords.latitude) / 2,
                              (task.pickupCoords.longitude + task.deliveryCoords.longitude) / 2,
                            ),
                            initialZoom: 12,
                          ),
                          children: [
                            TileLayer(
                              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName: 'com.example.app',
                            ),
                            PolylineLayer(
                              polylines: [
                                Polyline(
                                  points: routePoints.isEmpty 
                                      ? [task.pickupCoords, task.deliveryCoords] 
                                      : routePoints,
                                  color: const Color(0xFF1E6B5C),
                                  strokeWidth: 4.0,
                                ),
                              ],
                            ),
                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: task.pickupCoords,
                                  width: 80,
                                  height: 80,
                                  child: const Icon(
                                    Icons.location_on,
                                    color: Color(0xFF1E6B5C),
                                    size: 40,
                                  ),
                                ),
                                Marker(
                                  point: LatLng(
                                    (task.pickupCoords.latitude + task.deliveryCoords.latitude) / 2,
                                    (task.pickupCoords.longitude + task.deliveryCoords.longitude) / 2 + 0.01,
                                  ),
                                  width: 100,
                                  height: 40,
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
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
                                      task.distance,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                Marker(
                                  point: task.deliveryCoords,
                                  width: 80,
                                  height: 80,
                                  child: const Icon(
                                    Icons.flag,
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
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      task.title,
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      task.company,
                                      style: TextStyle(
                                        color: Theme.of(context).textTheme.bodyMedium?.color,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.phone_outlined,
                                          color: AppColors.getSecondaryTextColor(context),
                                          size: 16,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '+48 123 456 789',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        IconButton(
                                          icon: const Icon(Icons.content_copy, size: 14),
                                          onPressed: () {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text('Phone number copied to clipboard'),
                                                duration: Duration(seconds: 2),
                                              ),
                                            );
                                          },
                                          color: Theme.of(context).primaryColor,
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: task.status == 'Completed'
                                      ? Colors.green.withOpacity(0.2)
                                      : task.status == 'In Progress'
                                          ? Colors.orange.withOpacity(0.2)
                                          : Colors.blue.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  task.status.displayName,
                                  style: TextStyle(
                                    color: task.status == 'Completed'
                                        ? Colors.green
                                        : task.status == 'In Progress'
                                            ? Colors.orange
                                            : Colors.blue,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            task.description,
                            style: TextStyle(
                              color: Theme.of(context).textTheme.bodyMedium?.color,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.grey.withOpacity(0.2),
                              ),
                            ),
                            child: IntrinsicHeight(
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Row(
                                      children: [
                                        const Icon(Icons.inventory_2_outlined, size: 20),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Weight',
                                                style: TextStyle(
                                                  color: Theme.of(context).textTheme.bodyMedium?.color,
                                                  fontSize: 11,
                                                ),
                                              ),
                                              Text(
                                                task.weight,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  VerticalDivider(
                                    width: 16,
                                    thickness: 1,
                                    color: Colors.grey.withOpacity(0.2),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Row(
                                      children: [
                                        const Icon(Icons.view_in_ar_outlined, size: 20),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Volume',
                                                style: TextStyle(
                                                  color: Theme.of(context).textTheme.bodyMedium?.color,
                                                  fontSize: 11,
                                                ),
                                              ),
                                              Text(
                                                task.volume,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  VerticalDivider(
                                    width: 16,
                                    thickness: 1,
                                    color: Colors.grey.withOpacity(0.2),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      '\$${task.amount.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1E6B5C),
                                      ),
                                      textAlign: TextAlign.end,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          _buildLocationSection(
                            'Pickup',
                            task.pickupLocation,
                            _formatDateTime(task.pickupDateTime),
                            Icons.location_on,
                            const Color(0xFF1E6B5C),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 32),
                            child: Text(
                              task.distance,
                              style: const TextStyle(
                                color: Color(0xFF1E6B5C),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildLocationSection(
                            'Delivery',
                            task.deliveryLocation,
                            _formatDateTime(task.deliveryDateTime),
                            Icons.flag,
                            Colors.orange,
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: task.deliveryTypes.map((type) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E6B5C).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                type.name,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF1E6B5C),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )).toList(),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Icon(
                                Icons.phone_outlined,
                                color: AppColors.getSecondaryTextColor(context),
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '+48 123 456 789',
                                style: TextStyle(
                                  color: AppColors.getTextColor(context),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.content_copy, size: 16),
                                onPressed: () {
                                  // Copy to clipboard functionality can be added here
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Phone number copied to clipboard'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                },
                                color: Theme.of(context).primaryColor,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          if (task.status == TaskStatus.AWAITING)
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () {
                                      _handleDeclineTask(task.id);
                                      Navigator.pop(context);
                                    },
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.red,
                                      side: const BorderSide(color: Colors.red),
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                    ),
                                    child: const Text('Decline'),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _handleAcceptTask(task.id);
                                      Navigator.pop(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF1E6B5C),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                    ),
                                    child: const Text('Accept'),
                                  ),
                                ),
                              ],
                            ),
                          if (task.status.canProgress && task.status != TaskStatus.AWAITING)
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () {
                                      _handleAccident(task.id);
                                      Navigator.pop(context);
                                    },
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.red,
                                      side: const BorderSide(color: Colors.red),
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                    ),
                                    child: const Text('Report Accident'),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _handleProgressTask(task.id);
                                      Navigator.pop(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF1E6B5C),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                    ),
                                    child: Text(
                                      task.status == TaskStatus.IN_WAY
                                          ? 'Mark as Arrived'
                                          : task.status == TaskStatus.ARRIVED
                                              ? 'Mark as Completed'
                                              : 'Progress Task'
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
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
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: isHighlighted ? Border.all(
            color: Theme.of(context).primaryColor,
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
                      Expanded(
                        child: Text(
                          task.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: task.status == 'Completed'
                              ? Colors.green.withOpacity(0.2)
                              : task.status == 'In Progress'
                                  ? Colors.orange.withOpacity(0.2)
                                  : Colors.blue.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          task.status.displayName,
                          style: TextStyle(
                            color: task.status == 'Completed'
                                ? Colors.green
                                : task.status == 'In Progress'
                                    ? Colors.orange
                                    : Colors.blue,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDateTime(task.pickupDateTime),
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                      ),
                      Text(
                        '\$${task.amount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E6B5C),
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
                              Icons.location_on,
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
                              Icons.flag,
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
                            Text(
                              task.pickupLocation,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E6B5C).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                _formatDuration(task.estimatedDuration),
                                style: const TextStyle(
                                  color: Color(0xFF1E6B5C),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Text(
                              task.deliveryLocation,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: task.deliveryTypes.map((type) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E6B5C).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        type.name,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF1E6B5C),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationSection(
    String title,
    String location,
    String datetime,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                  fontSize: 12,
                ),
              ),
              Text(
                location,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              Text(
                datetime,
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('MMM dd, HH:mm').format(dateTime);
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '${hours}h ${minutes}m';
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