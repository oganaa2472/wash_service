import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/company.dart';
import '../../../domain/entities/order.dart';
import '../../../core/constants/app_constants.dart';
import '../../bloc/order/order_bloc.dart';
import '../../bloc/order/order_event.dart';
import '../../bloc/order/order_state.dart';
import '../../../data/datasources/order_remote_data_source.dart';
import '../../../data/repositories/order_repository_impl.dart';
import '../../../domain/usecases/get_wash_car_orders.dart';
import '../../../core/graphql/graphql_client.dart';
import 'home_page.dart';

class WashServicePage extends StatefulWidget {
  final Company company;
  
  const WashServicePage({
    Key? key,
    required this.company,
  }) : super(key: key);

  @override
  State<WashServicePage> createState() => _WashServicePageState();
}

class _WashServicePageState extends State<WashServicePage> {
  bool isLoading = false;
  int index = 0;
  bool _loading = false;
  
  // Form controllers
  final TextEditingController numberController = TextEditingController();
  final TextEditingController serialController = TextEditingController();
  final TextEditingController phoneController = TextEditingController(text: '');
  
  // Mask formatter for car number
  final maskFormatter = MaskTextInputFormatter(
    mask: '####AAA',
    filter: {"#": RegExp(r'[0-9]'), "A": RegExp(r'[^0-9]')},
  );

  @override
  void initState() {
    super.initState();
    initData();
  }

  Future<void> initData() async {
    setState(() {
      isLoading = true;
    });
    
    // Simulate data loading
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _checkForm() async {
    if (numberController.text.length != 7) {
      _showSnackBar("Улсын дугаараа оруулна уу");
      return;
    }
    if (phoneController.text.length != 8) {
      _showSnackBar("Утасны дугаараа оруулна уу");
      return;
    }
    
    // Navigate to order creation
    _showSnackBar("Захиалга үүсгэх хуудас руу шилжиж байна...");
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Scaffold(
            appBar: AppBar(
              leading: InkWell(
                onTap: () {
                  context.go('/home', extra: {'userType': UserType.operator});
                },
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Угаалга эхлэх', style: TextStyle(fontSize: 18, color: Colors.white)),
                  if (widget.company.name.isNotEmpty)
                    Text(
                      widget.company.name,
                      style: const TextStyle(fontSize: 13, color: Colors.white70),
                    ),
                ],
              ),
              backgroundColor: Color(0xFF2196F3),
              centerTitle: false,
              actions: [
                IconButton(
                  icon: const Icon(Icons.info_outline, color: Colors.white),
                  tooltip: 'Дэлгэрэнгүй',
                  onPressed: () {
                    _showSnackBar("Дэлгэрэнгүй мэдээлэл");
                  },
                ),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.white,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Color(0xFF2196F3),
              unselectedItemColor: Colors.grey[400],
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.list_alt),
                  label: "Захиалга",
                  tooltip: "Захиалгын мэдээлэл",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.payment),
                  label: "Төлөлт",
                  tooltip: "Төлбөрийн мэдээлэл",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.verified_user),
                  label: "Цалин",
                  tooltip: "Цалингийн мэдээлэл",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.group),
                  label: "Ажилтан",
                  tooltip: "Ажилчдын мэдээлэл",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.design_services_outlined),
                  label: "Цэс",
                  tooltip: "Үйлчилгээний цэс",
                ),
              ],
              currentIndex: index,
              onTap: (int i) {
                setState(() {
                  index = i;
                });
              },
            ),
            floatingActionButton: index == 0
                ? Tooltip(
                    message: "Захиалга нэмэх",
                    child: FloatingActionButton(
                      child: const Icon(Icons.add, color: Colors.white),
                      backgroundColor: Color(0xFF2196F3),
                      onPressed: () {
                        _showAddOrderDialog();
                      },
                    ),
                  )
                : null,
            body: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _buildCurrentTab(),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: const Text('Угаалгын үйлчилгээ', style: TextStyle(color: Colors.white)),
              centerTitle: true,
              backgroundColor: Color(0xFF2196F3),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LoadingAnimationWidget.fourRotatingDots(
                    color: Colors.blue,
                    size: 60,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Уншиж байна...',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          );
  }

  Widget _buildCurrentTab() {
    switch (index) {
      case 0:
        return _buildOrdersTab();
      case 1:
        return _buildPaymentsTab();
      case 2:
        return _buildSalaryTab();
      case 3:
        return _buildWorkersTab();
      case 4:
        return _buildServicesTab();
      default:
        return _buildOrdersTab();
    }
  }

  Widget _buildOrdersTab() {
    return BlocProvider(
      create: (context) {
        final client = GraphQLConfig.initializeClient().value;
        final remoteDataSource = OrderRemoteDataSource(client);
        final repository = OrderRepositoryImpl(remoteDataSource);
        final useCase = GetWashCarOrders(repository);
        return OrderBloc(useCase)..add(const FetchWashCarOrders());
      },
      child: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state is OrderLoading) {
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          }

          if (state is OrderError) {
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
                      const SizedBox(height: 16),
                      Text(
                        'Алдаа гарлаа',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.message,
                        style: TextStyle(color: Colors.grey[600]),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context.read<OrderBloc>().add(const FetchWashCarOrders());
                        },
                        child: const Text('Дахин оролдох'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          if (state is OrderLoaded) {
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Захиалгын жагсаалт',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Өнөөдөр: ${DateTime.now().day}/${DateTime.now().month}',
                          style: TextStyle(color: Colors.grey[600], fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: state.orders.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.list_alt_outlined, size: 64, color: Colors.grey[400]),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Захиалга байхгүй байна',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount: state.orders.length,
                              itemBuilder: (context, index) {
                                final order = state.orders[index];
                                return _buildOrderCard(order);
                              },
                            ),
                    ),
                  ],
                ),
              ),
            );
          }

          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Text('Захиалга уншиж байна...'),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOrderCard(Order order) {
    final isCompleted = order.status.toLowerCase() == 'completed';
    final isPaid = order.paymentStatus.toLowerCase() == 'paid';
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade50,
          child: const Icon(Icons.local_car_wash, color: Colors.blue),
        ),
        title: Text('Захиалга #${order.id}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${order.selectedService.name} • ${order.carPlateNumber}'),
            Text(
              '₮${order.totalPrice} • ${_formatDate(order.orderDate)}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isCompleted ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                isCompleted ? 'Дууссан' : 'Хийгдэж байна',
                style: TextStyle(
                  color: isCompleted ? Colors.green : Colors.orange,
                  fontWeight: FontWeight.w500,
                  fontSize: 10,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isPaid ? Colors.blue.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                isPaid ? 'Төлөгдсөн' : 'Төлөгдөөгүй',
                style: TextStyle(
                  color: isPaid ? Colors.blue : Colors.red,
                  fontWeight: FontWeight.w500,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildPaymentsTab() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Төлбөрийн мэдээлэл',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildPaymentCard(
                    'Өнөөдөр',
                    '₮150,000',
                    Colors.green,
                    Icons.today,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildPaymentCard(
                    'Энэ долоо хоног',
                    '₮850,000',
                    Colors.blue,
                    Icons.date_range,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Сүүлийн төлбөрүүд',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.green.shade50,
                      child: const Icon(Icons.payment, color: Colors.green),
                    ),
                    title: Text('Төлбөр #${2001 + index}'),
                    subtitle: Text('₮${15000 + (index * 5000)} • ${DateTime.now().subtract(Duration(days: index)).day}/${DateTime.now().subtract(Duration(days: index)).month}'),
                    trailing: const Icon(Icons.check_circle, color: Colors.green),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentCard(String title, String amount, Color color, IconData icon) {
    return Card(
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(color: color, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              amount,
              style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSalaryTab() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Цалингийн мэдээлэл',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildSalaryCard(
                    'Нийт ажилчин',
                    '8',
                    Colors.blue,
                    Icons.people,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSalaryCard(
                    'Энэ сар',
                    '₮2,500,000',
                    Colors.green,
                    Icons.account_balance_wallet,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Ажилчдын жагсаалт',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: 8,
                itemBuilder: (context, index) {
                  final names = ['Бат', 'Болд', 'Дорж', 'Сүхээ', 'Ганбаатар', 'Энхбаатар', 'Мөнхбаатар', 'Батбаатар'];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.orange.shade50,
                      child: Text(
                        names[index].substring(0, 1),
                        style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(names[index]),
                    subtitle: Text('₮${300000 + (index * 25000)} • ${20 + index} ажил'),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Идэвхтэй',
                        style: TextStyle(color: Colors.green, fontSize: 12),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSalaryCard(String title, String value, Color color, IconData icon) {
    return Card(
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(color: color, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkersTab() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Ажилчдын жагсаалт',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    _showSnackBar("Ажилчин нэмэх");
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: 6,
                itemBuilder: (context, index) {
                  final names = ['Бат', 'Болд', 'Дорж', 'Сүхээ', 'Ганбаатар', 'Энхбаатар'];
                  final statuses = ['Идэвхтэй', 'Идэвхтэй', 'Чөлөөтэй', 'Идэвхтэй', 'Идэвхтэй', 'Чөлөөтэй'];
                  final colors = [Colors.green, Colors.green, Colors.orange, Colors.green, Colors.green, Colors.orange];
                  
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue.shade50,
                        child: Text(
                          names[index].substring(0, 1),
                          style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(names[index]),
                      subtitle: Text('${20 + index} ажил • ${DateTime.now().subtract(Duration(days: index)).day}/${DateTime.now().subtract(Duration(days: index)).month}'),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: colors[index].withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          statuses[index],
                          style: TextStyle(color: colors[index], fontSize: 12),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServicesTab() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Үйлчилгээний цэс',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: const [
                  _ServiceCard(
                    icon: Icons.local_car_wash,
                    title: 'Хурдан угаалга',
                    price: '₮15,000',
                    color: Colors.blue,
                  ),
                  _ServiceCard(
                    icon: Icons.cleaning_services,
                    title: 'Гүн цэвэрлэгээ',
                    price: '₮25,000',
                    color: Colors.green,
                  ),
                  _ServiceCard(
                    icon: Icons.auto_awesome,
                    title: 'Премиум угаалга',
                    price: '₮35,000',
                    color: Colors.purple,
                  ),
                  _ServiceCard(
                    icon: Icons.car_rental,
                    title: 'Бүрэн үйлчилгээ',
                    price: '₮50,000',
                    color: Colors.orange,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddOrderDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Шинэ захиалга'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: numberController,
                inputFormatters: [maskFormatter],
                decoration: const InputDecoration(
                  labelText: 'Машины дугаар',
                  hintText: '1234ABC',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Утасны дугаар',
                  hintText: '99999999',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Цуцлах'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _checkForm();
              },
              child: const Text('Үргэлжлүүлэх'),
            ),
          ],
        );
      },
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String price;
  final Color color;

  const _ServiceCard({
    required this.icon,
    required this.title,
    required this.price,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$title сонгосон')),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                price,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 