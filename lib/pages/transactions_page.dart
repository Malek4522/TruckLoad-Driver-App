import 'package:flutter/material.dart';
import 'tasks_page.dart';
import '../utils/app_colors.dart';
import '../utils/app_localizations.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loc.get('transactions'),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(26),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                loc.get('total_earnings'),
                                style: TextStyle(
                                  color: Colors.white.withAlpha(204),
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                '\$1,248.30',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(51),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.account_balance_wallet_outlined,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loc.get('insights'),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.getTextColor(context),
                      ),
                    ),
                    const SizedBox(height: 16),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.8,
                      children: [
                        _buildInsightCard(
                          title: loc.get('today_earnings'),
                          amount: '\$116.25',
                          icon: Icons.today,
                          color: Colors.blue,
                        ),
                        _buildInsightCard(
                          title: loc.get('pending_amount'),
                          amount: '\$45.00',
                          icon: Icons.pending,
                          color: Colors.orange,
                        ),
                        _buildInsightCard(
                          title: loc.get('last_month'),
                          amount: '\$3,542.80',
                          icon: Icons.calendar_month,
                          color: Colors.purple,
                        ),
                        _buildInsightCard(
                          title: loc.get('avg_per_day'),
                          amount: '\$118.09',
                          icon: Icons.analytics,
                          color: Colors.green,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  TabBar(
                    controller: _tabController,
                    labelColor: Theme.of(context).brightness == Brightness.dark 
                        ? Colors.white 
                        : Theme.of(context).primaryColor,
                    unselectedLabelColor: AppColors.getSecondaryTextColor(context),
                    indicator: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Theme.of(context).brightness == Brightness.dark 
                              ? Colors.white 
                              : Theme.of(context).primaryColor,
                          width: 2,
                        ),
                      ),
                    ),
                    tabs: [
                      Tab(text: loc.get('active')),
                      Tab(text: loc.get('history')),
                    ],
                  ),
                  [
                    // Active transactions
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            loc.get('active'),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.getTextColor(context),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              _buildTransactionCard(
                                context,
                                date: loc.get('today'),
                                time: '15:30',
                                taskId: '#GE73895',
                                amount: '\$45.00',
                                status: loc.get('awaiting'),
                                customerName: 'Green Energy ITD',
                                location: 'Warszawa',
                              ),
                              _buildTransactionCard(
                                context,
                                date: loc.get('today'),
                                time: '13:15',
                                taskId: '#HFF7403',
                                amount: '\$32.50',
                                status: loc.get('in_way'),
                                customerName: 'Happy Fresh Inc',
                                location: 'Central Market',
                              ),
                              _buildTransactionCard(
                                context,
                                date: loc.get('today'),
                                time: '11:45',
                                taskId: '#FF4501',
                                amount: '\$28.75',
                                status: loc.get('awaiting'),
                                customerName: 'Fresh Foods Market',
                                location: 'Downtown',
                              ),
                              _buildTransactionCard(
                                context,
                                date: loc.get('today'),
                                time: '10:30',
                                taskId: '#TL9012',
                                amount: '\$35.20',
                                status: loc.get('in_way'),
                                customerName: 'Tech Labs',
                                location: 'Business District',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // History transactions
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            loc.get('history'),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.getTextColor(context),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              _buildTransactionCard(
                                context,
                                date: loc.get('yesterday'),
                                time: '16:45',
                                taskId: '#EL8901',
                                amount: '\$38.75',
                                status: loc.get('completed'),
                                customerName: 'Tech Solutions',
                                location: 'Tech Warehouse',
                              ),
                              _buildTransactionCard(
                                context,
                                date: loc.get('yesterday'),
                                time: '14:30',
                                taskId: '#MK7302',
                                amount: '\$42.50',
                                status: loc.get('completed'),
                                customerName: 'Market King',
                                location: 'Shopping Center',
                              ),
                              _buildTransactionCard(
                                context,
                                date: loc.get('yesterday'),
                                time: '11:15',
                                taskId: '#FS6104',
                                amount: '\$31.25',
                                status: loc.get('completed'),
                                customerName: 'Food Store',
                                location: 'City Mall',
                              ),
                              _buildTransactionCard(
                                context,
                                date: loc.get('yesterday'),
                                time: '09:00',
                                taskId: '#EP5203',
                                amount: '\$45.80',
                                status: loc.get('completed'),
                                customerName: 'Express Post',
                                location: 'Logistics Center',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ][_tabController.index],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInsightCard({
    required String title,
    required String amount,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withAlpha(51),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: AppColors.getSecondaryTextColor(context),
                    fontSize: 13,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            amount,
            style: TextStyle(
              color: AppColors.getTextColor(context),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionCard(BuildContext context, {
    required String date,
    required String time,
    required String taskId,
    required String amount,
    required String status,
    required String customerName,
    required String location,
  }) {
    final loc = AppLocalizations.of(context);
    
    Color getStatusColor() {
      switch (status.toLowerCase()) {
        case 'completed':
          return const Color(0xFF1E6B5C);
        case 'pending':
          return Colors.orange;
        default:
          return Colors.grey;
      }
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                title: Text(loc.get('task_details')),
              ),
              body: TasksPage(highlightedTaskId: taskId),
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.getCardColor(context),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(13),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            date,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            time,
                            style: TextStyle(
                              color: AppColors.getSecondaryTextColor(context),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        amount,
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E6B5C).withAlpha(26),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              taskId,
                              style: const TextStyle(
                                color: Color(0xFF1E6B5C),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: getStatusColor().withAlpha(26),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              status,
                              style: TextStyle(
                                color: getStatusColor(),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.getCardColor(context),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.person_outline,
                    color: AppColors.getSecondaryTextColor(context),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          customerName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          location,
                          style: TextStyle(
                            color: AppColors.getSecondaryTextColor(context),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 