import 'package:flutter/material.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Finished', 'Awaiting', 'Assigned'];

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
      'distance': '55.9 km • 1 hour 1 min EST',
      'destination': 'Sochaczew',
      'destinationAddress': 'Warszawska 82, 96-515 Sochaczew',
      'status': 'awaiting',
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
      'distance': '42.3 km • 45 min EST',
      'destination': 'Fresh Foods Store',
      'destinationAddress': 'Grocery Street 45, 01-234 Praga',
      'status': 'assigned',
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
      'distance': '38.7 km • 52 min EST',
      'destination': 'Electronics Store',
      'destinationAddress': 'Digital Avenue 90, 03-456 Mokotów',
      'status': 'finished',
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
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
                  color: Colors.grey[600],
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
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey[200],
            child: const Icon(Icons.person),
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
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'ONLINE',
              style: TextStyle(
                color: Colors.green,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskFilters() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'My Task',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
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
                    backgroundColor: Colors.white,
                    selectedColor: Colors.white,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.black : Colors.grey,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    side: BorderSide(
                      color: isSelected ? Colors.black : Colors.grey.shade300,
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
          style: TextStyle(color: Colors.grey[600]),
        ),
      );
    }
    
    return ListView.separated(
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
          distance: task['distance'],
          destination: task['destination'],
          destinationAddress: task['destinationAddress'],
          status: task['status'],
        );
      },
    );
  }

  Widget _buildTaskCard({
    required String title,
    required String id,
    required String type,
    required String weight,
    required String price,
    required String location,
    required String company,
    required String address,
    required String distance,
    required String destination,
    required String destinationAddress,
    required String status,
  }) {
    Color getTypeColor(String taskType) {
      switch (taskType) {
        case 'AWAITING':
          return const Color(0xFF1E6B5C);
        case 'ASSIGNED':
          return const Color(0xFFFFB74D);
        case 'FINISHED':
          return Colors.grey;
        default:
          return Colors.grey;
      }
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: getTypeColor(type).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        type,
                        style: TextStyle(
                          color: getTypeColor(type),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          company,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          id,
                          style: const TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      price,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                if (weight.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Contains: $weight',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (address.isNotEmpty) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildLocationRow(
                    icon: Icons.location_on,
                    iconColor: const Color(0xFF1E6B5C),
                    title: location,
                    subtitle: address,
                  ),
                  if (distance.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(left: 32),
                      child: Text(
                        distance,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                        ),
                      ),
                    ),
                  if (destination.isNotEmpty && destinationAddress.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _buildLocationRow(
                      icon: Icons.location_on_outlined,
                      iconColor: Colors.orange,
                      title: destination,
                      subtitle: destinationAddress,
                    ),
                  ],
                ],
              ),
            ),
          ],
          if (type == 'AWAITING') ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _handleDeclineTask(id),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Decline'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _handleAcceptTask(id),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Accept'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLocationRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: iconColor, size: 24),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
} 