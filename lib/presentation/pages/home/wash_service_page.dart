import 'package:flutter/material.dart';
import '../../../domain/entities/company.dart';
import '../../../domain/entities/order.dart';
import '../../../domain/entities/worker.dart';
// Placeholder pages for navigation
// WasherListPage with improved UI/UX
class WasherListPage extends StatefulWidget {
  final List<Worker> workers;
  const WasherListPage({Key? key, required this.workers}) : super(key: key);
  @override
  State<WasherListPage> createState() => _WasherListPageState();
}

class _WasherListPageState extends State<WasherListPage> {
  String search = '';
  @override
  Widget build(BuildContext context) {
    final filtered = widget.workers.where((w) => w.name.toLowerCase().contains(search.toLowerCase())).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('All Washers'), backgroundColor: Colors.blue),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search washers...',
                prefixIcon: const Icon(Icons.search, color: Colors.blue),
                filled: true,
                fillColor: Colors.blue.shade50,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
              onChanged: (v) => setState(() => search = v),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                Text('Washer List', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue.shade900)),
                const SizedBox(width: 8),
                Container(width: 8, height: 8, decoration: BoxDecoration(color: Colors.blue, shape: BoxShape.circle)),
                const SizedBox(width: 8),
                Text('${filtered.length} found', style: TextStyle(color: Colors.blueGrey.shade400)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.separated(
              itemCount: filtered.length,
              separatorBuilder: (context, i) => Divider(indent: 32, endIndent: 32, color: Colors.blue.shade50, height: 1),
              itemBuilder: (context, i) => Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                child: ListTile(
                  leading: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(colors: [Color(0xFFB3E5FC), Color(0xFF2196F3)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                    ),
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 24,
                      child: filtered[i].avatar != null
                          ? ClipOval(child: Image.network(filtered[i].avatar!, width: 40, height: 40, fit: BoxFit.cover))
                          : const Icon(Icons.person, color: Colors.white, size: 28),
                    ),
                  ),
                  title: Text(filtered[i].name, style: const TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// OrderListPage with improved UI/UX
class OrderListPage extends StatefulWidget {
  final List<Order> orders;
  const OrderListPage({Key? key, required this.orders}) : super(key: key);
  @override
  State<OrderListPage> createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  String search = '';
  @override
  Widget build(BuildContext context) {
    final filtered = widget.orders.where((o) => o.id.toString().contains(search) || o.status.toLowerCase().contains(search.toLowerCase())).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('All Orders'), backgroundColor: Colors.blue),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search orders...',
                prefixIcon: const Icon(Icons.search, color: Colors.blue),
                filled: true,
                fillColor: Colors.blue.shade50,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
              onChanged: (v) => setState(() => search = v),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                Text('Order History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue.shade900)),
                const SizedBox(width: 8),
                Container(width: 8, height: 8, decoration: BoxDecoration(color: Colors.blue, shape: BoxShape.circle)),
                const SizedBox(width: 8),
                Text('${filtered.length} found', style: TextStyle(color: Colors.blueGrey.shade400)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.separated(
              itemCount: filtered.length,
              separatorBuilder: (context, i) => Divider(indent: 32, endIndent: 32, color: Colors.blue.shade50, height: 1),
              itemBuilder: (context, i) => Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                child: ListTile(
                  leading: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(colors: [Color(0xFFB3E5FC), Color(0xFF2196F3)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                    ),
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 24,
                      child: const Icon(Icons.receipt_long, color: Colors.white, size: 28),
                    ),
                  ),
                  title: Text('Order #${filtered[i].id}', style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text('Status: ${filtered[i].status}\nCreated: ${filtered[i].createdAt.toLocal().toString().split(' ')[0]}'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WashServicePage extends StatelessWidget {
  final Company company;
  WashServicePage({Key? key, required this.company}) : super(key: key);

  // Mock data for demonstration
  List<String> get mockCategories => [
        'Quick Wash',
        'Deep Clean',
        'Full Service',
        'Premium',
      ];

  final Map<String, int> mockIncome = {
    'day': 150000,
    'week': 800000,
    'month': 3200000,
  };

  List<Order> get mockOrders => [
        Order(
          id: 1,
          companyId: int.parse(company.id),
          serviceCategoryId: 1,
          carId: 1,
          workerIds: [1, 2],
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          status: 'Completed',
        ),
        Order(
          id: 2,
          companyId: int.parse(company.id),
          serviceCategoryId: 2,
          carId: 2,
          workerIds: [2],
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
          status: 'In Progress',
        ),
      ];

  List<Worker> get mockWorkers => [
        Worker(id: 1, name: 'Бат-Эрдэнэ', avatar: null),
        Worker(id: 2, name: 'Сараа', avatar: null),
        Worker(id: 3, name: 'Тэмүүжин', avatar: null),
      ];

  final List<String> vehicleTypes = [
    "Жижиг тэрэг",
    "Дунд оврын жийп",
    "Том оврын жийп",
    "Микро автобус",
    "Портер",
    "Портер (Амбаартай)",
    "Приус 41 / Fielder / Krossover",
  ];
  final List<Map<String, dynamic>> washServices = [
    {
      "title": "БҮТЭН УГААЛГА",
      "prices": [35000, 50000, 60000, 65000, 40000, 45000, 40000]
    },
    {
      "title": "ГАДАР УГААЛГА",
      "prices": [25000, 25000, 30000, 35000, 25000, 35000, 25000]
    },
    {
      "title": "ДОТОР УГААЛГА",
      "prices": [25000, 30000, 35000, 40000, 20000, 20000, 30000]
    },
  ];

  final List<String> periods = ['Day', 'Week', 'Month'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(company.name),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Income Report Section
            Text('Income', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue.shade900)),
            const SizedBox(height: 12),
            _IncomeCard(mockIncome: mockIncome, periods: periods),
            const SizedBox(height: 28),
            // Wash Category Section
            Text('Wash Categories', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue.shade900)),
            const SizedBox(height: 12),
            _CategoryManager(vehicleTypes: vehicleTypes, washServices: washServices),
            const SizedBox(height: 28),
            // (Wash Service Price Table removed as requested)
            // Order History Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Order History', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue.shade900)),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => OrderListPage(orders: mockOrders)),
                    );
                  },
                  child: const Text('See All', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (mockOrders.isEmpty)
              const Text('No orders yet.', style: TextStyle(color: Colors.grey)),
            ...mockOrders.map((order) => Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.shade100,
                      child: const Icon(Icons.receipt_long, color: Colors.blue),
                    ),
                    title: Text('Order #${order.id}'),
                    subtitle: Text('Status: ${order.status}\nCreated: ${order.createdAt.toLocal().toString().split(' ')[0]}'),
                  ),
                )),
            const SizedBox(height: 28),
            // Washer List Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Washer List', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue.shade900)),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => WasherListPage(workers: mockWorkers)),
                    );
                  },
                  child: const Text('See All', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (mockWorkers.isEmpty)
              const Text('No washers yet.', style: TextStyle(color: Colors.grey)),
            ...mockWorkers.map((worker) => Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.shade50,
                      child: worker.avatar != null
                          ? Image.network(worker.avatar!)
                          : const Icon(Icons.person, color: Colors.blue),
                    ),
                    title: Text(worker.name),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

// Income card widget with dropdown
class _IncomeCard extends StatefulWidget {
  final Map<String, int> mockIncome;
  final List<String> periods;
  const _IncomeCard({required this.mockIncome, required this.periods});

  @override
  State<_IncomeCard> createState() => _IncomeCardState();
}

class _IncomeCardState extends State<_IncomeCard> {
  String selectedPeriod = 'Day';

  @override
  Widget build(BuildContext context) {
    String key = selectedPeriod.toLowerCase();
    int income = widget.mockIncome[key] ?? 0;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Income', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Text('$income₮', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
            ],
          ),
          DropdownButton<String>(
            value: selectedPeriod,
            items: widget.periods.map((period) => DropdownMenuItem(
              value: period,
              child: Text(period),
            )).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  selectedPeriod = value;
                });
              }
            },
            underline: Container(),
            style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
            dropdownColor: Colors.blue.shade50,
          ),
        ],
      ),
    );
  }
}

class _CategoryManager extends StatefulWidget {
  final List<String> vehicleTypes;
  final List<Map<String, dynamic>> washServices;
  const _CategoryManager({required this.vehicleTypes, required this.washServices});

  @override
  State<_CategoryManager> createState() => _CategoryManagerState();
}

class _CategoryManagerState extends State<_CategoryManager> {
  late String selectedVehicleType;
  late List<Map<String, dynamic>> categories;

  @override
  void initState() {
    super.initState();
    selectedVehicleType = widget.vehicleTypes.first;
    categories = List<Map<String, dynamic>>.from(widget.washServices);
  }

  void _showAddCategoryDialog() {
    final _formKey = GlobalKey<FormState>();
    String newCategory = '';
    String newPrice = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Category'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Category Name'),
                  validator: (v) => v == null || v.isEmpty ? 'Enter category' : null,
                  onChanged: (v) => newCategory = v,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Price for $selectedVehicleType'),
                  keyboardType: TextInputType.number,
                  validator: (v) => v == null || v.isEmpty ? 'Enter price' : null,
                  onChanged: (v) => newPrice = v,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    // Add new category with price for selected vehicle type
                    int idx = widget.vehicleTypes.indexOf(selectedVehicleType);
                    List<int> prices = List.filled(widget.vehicleTypes.length, 0);
                    prices[idx] = int.tryParse(newPrice) ?? 0;
                    categories.add({
                      'title': newCategory,
                      'prices': prices,
                    });
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    int vehicleIdx = widget.vehicleTypes.indexOf(selectedVehicleType);
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gradient header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
              gradient: LinearGradient(
                colors: [Color(0xFF2196F3), Color(0xFF64B5F6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.directions_car, color: Colors.white, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedVehicleType,
                      dropdownColor: const Color(0xFF64B5F6),
                      icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
                      items: widget.vehicleTypes.map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(type, style: const TextStyle(color: Colors.white)),
                      )).toList(),
                      onChanged: (v) {
                        if (v != null) setState(() => selectedVehicleType = v);
                      },
                    ),
                  ),
                ),
                
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: categories.isEmpty
                ? const Text('No categories yet.', style: TextStyle(color: Colors.grey))
                : Wrap(
                    spacing: 12,
                    runSpacing: 10,
                    children: categories.map((cat) {
                      int price = (cat['prices'] as List)[vehicleIdx];
                      return Chip(
                        label: Text('${cat['title']} (${price > 0 ? '$price₮' : '—'})', style: const TextStyle(color: Colors.white)),
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 2,
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }
} 