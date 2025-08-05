import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../../domain/entities/company.dart';
import '../../../domain/entities/car.dart';
import '../../../domain/entities/wash_service.dart';
import '../../../domain/entities/washer.dart';
import '../../../domain/entities/wash_employee.dart';
import '../../bloc/car/car_bloc.dart';
import '../../bloc/car/car_event.dart';
import '../../bloc/car/car_state.dart';
import '../../bloc/wash_service/wash_service_bloc.dart';
import '../../bloc/wash_service/wash_service_event.dart';
import '../../bloc/wash_service/wash_service_state.dart';
import '../../bloc/wash_employee/wash_employee_bloc.dart';
import '../../bloc/wash_employee/wash_employee_event.dart';
import '../../bloc/wash_employee/wash_employee_state.dart';
import '../../../data/datasources/car_remote_data_source.dart';
import '../../../data/repositories/car_repository_impl.dart';
import '../../../domain/usecases/get_car_list.dart';
import '../../../data/datasources/wash_service_remote_data_source.dart';
import '../../../data/repositories/wash_service_repository_impl.dart';
import '../../../domain/usecases/get_wash_services.dart';
import '../../../data/datasources/wash_employee_remote_data_source.dart';
import '../../../data/repositories/wash_employee_repository_impl.dart';
import '../../../domain/usecases/get_wash_employees.dart';
import '../../../data/datasources/order_mutation_data_source.dart';
import '../../../data/datasources/employee_mutation_data_source.dart';
import '../../../core/graphql/graphql_client.dart';

class AddOrderPage extends StatefulWidget {
  final Company company;
  
  const AddOrderPage({
    Key? key,
    required this.company,
  }) : super(key: key);

  @override
  State<AddOrderPage> createState() => _AddOrderPageState();
}

class _AddOrderPageState extends State<AddOrderPage> {
  int currentStep = 0;
  Car? selectedCar;
  WashService? selectedService;
  List<WashEmployee> selectedWashers = [];
  
  // Form controllers for new car
  final TextEditingController plateNumberController = TextEditingController();
  
  // Mask formatter for car plate number
  final plateMaskFormatter = MaskTextInputFormatter(
    mask: '####AAA',
    filter: {"#": RegExp(r'[0-9]'), "A": RegExp(r'[^0-9]')},
  );
  
  // Car data will be loaded from GraphQL
  List<Car> availableCars = [];
  
  // Service data will be loaded from GraphQL
  List<WashService> availableServices = [];
  
  // Employee data will be loaded from GraphQL
  List<WashEmployee> availableWashers = [];
  
  // Order ID after creation
  String? createdOrderId;

  @override
  void dispose() {
    plateNumberController.dispose();
    super.dispose();
  }

  void _nextStep() async {
    if (currentStep == 0) {
      // Car selection step
      if (selectedCar == null && plateNumberController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Машин сонгох эсвэл машины дугаар оруулна уу'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      
      // If no car selected but plate number entered, create a temporary car
      if (selectedCar == null && plateNumberController.text.trim().isNotEmpty) {
        final plateNumber = plateNumberController.text.trim();
        selectedCar = Car(
          id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
          phone: '',
          licensePlate: plateNumber,
          make: CarMake(name: 'Unknown'),
          model: CarModel(name: 'Unknown'),
          color: '',
        );
      }
    } else if (currentStep == 1) {
      // Service selection step
      if (selectedService == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Үйлчилгээ сонгоно уу'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      
      // Create order after service selection
      try {
        final client = GraphQLConfig.initializeClient().value;
        final mutationDataSource = OrderMutationDataSource(client);
        
        final orderId = await mutationDataSource.addOrder(
          carId: selectedCar!.id.startsWith('temp_') ? '0' : selectedCar!.id,
          carPlateNumber: selectedCar!.licensePlate,
          organizationId: widget.company.id,
          selectedServices: [int.parse(selectedService!.id)],
        
          // totalPrice: selectedService!.price.toString(),
          // completedAt: DateTime.now().toIso8601String(),
        );
        
        createdOrderId = orderId;
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Захиалга үүсгэгдлээ. ID: $orderId'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Алдаа гарлаа: $e'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    } else if (currentStep == 2) {
      // Washer selection step
      if (selectedWashers.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Угаагч сонгоно уу'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    if (currentStep < 2) {
      setState(() {
        currentStep++;
      });
    } else {
      _submitOrder();
    }
  }

  void _submitOrder() async {
    if (createdOrderId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Захиалгын ID олдсонгүй'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Assign selected employees to the order
    try {
      
      final client = GraphQLConfig.initializeClient().value;
      final employeeMutationDataSource = EmployeeMutationDataSource(client);
      
      // Calculate base salary pool (30% of service price)
      double baseSalaryPool = double.parse(selectedService!.price) * 0.3;
      
      // Calculate equal share for each worker
      double equalShare = baseSalaryPool / selectedWashers.length;
     
      for (final washer in selectedWashers) {
        // Calculate individual salary based on skill percentage
        double calculatedSalary = equalShare * double.parse(washer.skillPercentage) / 100;
        
        print('Washer ID: ${washer.id}, Skill Percentage: ${washer.skillPercentage}'); 
        await employeeMutationDataSource.assignEmployeeToOrder(
          orderId: createdOrderId!,
          workId: washer.id,
          // assignedAt: DateTime.now().toIso8601String(),
          // calculatedSalary: calculatedSalary.toString(),
        );
      }
       
       // Show success message and return to wash service page
       ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(
           content: Text('Ажилчид амжилттай хуваарилагдлаа'),
           backgroundColor: Colors.green,
         ),
       );
       
       // Return to wash service page
       Navigator.of(context).pop();
       
     } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Алдаа гарлаа: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Шинэ захиалга', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF2196F3),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // Progress indicator
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                for (int i = 0; i < 3; i++)
                  Expanded(
                    child: Container(
                      height: 4,
                      margin: EdgeInsets.only(right: i < 2 ? 8 : 0),
                      decoration: BoxDecoration(
                        color: i <= currentStep ? const Color(0xFF2196F3) : Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          // Step titles
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Машин',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: currentStep == 0 ? FontWeight.bold : FontWeight.normal,
                      color: currentStep == 0 ? const Color(0xFF2196F3) : Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    'Үйлчилгээ',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: currentStep == 1 ? FontWeight.bold : FontWeight.normal,
                      color: currentStep == 1 ? const Color(0xFF2196F3) : Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    'Ажилчин',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: currentStep == 2 ? FontWeight.bold : FontWeight.normal,
                      color: currentStep == 2 ? const Color(0xFF2196F3) : Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Step content
          Expanded(
            child: _buildCurrentStep(),
          ),
          
          // Navigation buttons
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _nextStep,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2196F3),
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      currentStep == 2 ? 'Сонгох' : 'Дараах',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (currentStep) {
      case 0:
        return _buildCarSelectionStep();
      case 1:
        return _buildServiceSelectionStep();
      case 2:
        return _buildWasherSelectionStep();
      default:
        return _buildCarSelectionStep();
    }
  }

  Widget _buildCarSelectionStep() {
    return BlocProvider(
      create: (context) {
        final client = GraphQLConfig.initializeClient().value;
        final remoteDataSource = CarRemoteDataSource(client);
        final repository = CarRepositoryImpl(remoteDataSource);
        final useCase = GetCarList(repository);
        return CarBloc(useCase)..add(const FetchCarList());
      },
      child: BlocBuilder<CarBloc, CarState>(
        builder: (context, state) {
          if (state is CarLoading) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (state is CarError) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
                    const SizedBox(height: 16),
                    const Text(
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
                        context.read<CarBloc>().add(const FetchCarList());
                      },
                      child: const Text('Дахин оролдох'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is CarLoaded) {
            availableCars = state.cars;
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Машин сонгох',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                
                // Existing cars
                const Text(
                  'Бүртгэлтэй машинууд',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                
                Expanded(
                  child: availableCars.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.directions_car_outlined, size: 64, color: Colors.grey[400]),
                              const SizedBox(height: 16),
                              Text(
                                'Машин байхгүй байна',
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
                          itemCount: availableCars.length,
                          itemBuilder: (context, index) {
                            final car = availableCars[index];
                            final isSelected = selectedCar?.id == car.id;
                            
                            return Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              color: isSelected ? const Color(0xFF2196F3).withOpacity(0.1) : null,
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: isSelected ? const Color(0xFF2196F3) : Colors.grey[300],
                                  child: Icon(
                                    Icons.directions_car,
                                    color: isSelected ? Colors.white : Colors.grey[600],
                                  ),
                                ),
                                title: Text(car.licensePlate),
                                subtitle: Text('${car.make.name} ${car.model.name} • ${car.phone}'),
                                trailing: isSelected ? const Icon(Icons.check_circle, color: Color(0xFF2196F3)) : null,
                                onTap: () {
                                  setState(() {
                                    selectedCar = car;
                                  });
                                },
                              ),
                            );
                          },
                        ),
                ),
                
                const SizedBox(height: 16),
                
                // Car number input field
                const Text(
                  'Машины дугаар оруулах',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: plateNumberController,
                  inputFormatters: [plateMaskFormatter],
                  decoration: InputDecoration(
                    hintText: 'Жишээ: 1234ABC',
                    labelText: 'Машины дугаар',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.directions_car),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Хэрэв машинаа дээрх жагсаалтаас олдохгүй бол дугаараа оруулна уу',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildServiceSelectionStep() {
    return BlocProvider(
      create: (context) {
        final client = GraphQLConfig.initializeClient().value;
        final remoteDataSource = WashServiceRemoteDataSource(client);
        final repository = WashServiceRepositoryImpl(remoteDataSource);
        final useCase = GetWashServices(repository);
        return WashServiceBloc(useCase)..add(FetchWashServices(widget.company.id));
      },
      child: BlocBuilder<WashServiceBloc, WashServiceState>(
        builder: (context, state) {
          if (state is WashServiceLoading) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (state is WashServiceError) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
                    const SizedBox(height: 16),
                    const Text(
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
                        context.read<WashServiceBloc>().add(FetchWashServices(widget.company.id));
                      },
                      child: const Text('Дахин оролдох'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is WashServiceLoaded) {
            availableServices = state.services;
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Үйлчилгээ сонгох',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                
                Expanded(
                  child: availableServices.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.local_car_wash_outlined, size: 64, color: Colors.grey[400]),
                              const SizedBox(height: 16),
                              Text(
                                'Үйлчилгээ байхгүй байна',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        )
                      : _buildServicesByCategory(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildWasherSelectionStep() {
    return BlocProvider(
      create: (context) {
        final client = GraphQLConfig.initializeClient().value;
        final remoteDataSource = WashEmployeeRemoteDataSource(client);
        final repository = WashEmployeeRepositoryImpl(remoteDataSource);
        final useCase = GetWashEmployees(repository);
        return WashEmployeeBloc(useCase)..add(FetchWashEmployees(widget.company.id));
      },
      child: BlocBuilder<WashEmployeeBloc, WashEmployeeState>(
        builder: (context, state) {
          if (state is WashEmployeeLoading) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (state is WashEmployeeError) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
                    const SizedBox(height: 16),
                    const Text(
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
                        context.read<WashEmployeeBloc>().add(FetchWashEmployees(widget.company.id));
                      },
                      child: const Text('Дахин оролдох'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is WashEmployeeLoaded) {
            availableWashers = state.employees;
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Угаагч сонгох',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  '${selectedWashers.length} угаагч сонгосон',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                
                Expanded(
                  child: availableWashers.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.person_outlined, size: 64, color: Colors.grey[400]),
                              const SizedBox(height: 16),
                              Text(
                                'Ажилчин байхгүй байна',
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
                          itemCount: availableWashers.length,
                          itemBuilder: (context, index) {
                            final washer = availableWashers[index];
                            final isSelected = selectedWashers.any((w) => w.id == washer.id);
                            
                            return Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              color: isSelected ? const Color(0xFF2196F3).withOpacity(0.1) : null,
                              child: ListTile(
                                leading: Checkbox(
                                  value: isSelected,
                                  onChanged: (bool? newValue) {
                                    setState(() {
                                      if (newValue!) {
                                        selectedWashers.add(washer);
                                      } else {
                                        selectedWashers.remove(washer);
                                      }
                                    });
                                  },
                                ),
                                title: Text('${washer.employee.username} ${washer.employee.lastName}'),
                                subtitle: Text('${washer.employee.phone} • ${washer.skillPercentage}%'),
                                onTap: () {
                                  setState(() {
                                    if (isSelected) {
                                      selectedWashers.remove(washer);
                                    } else {
                                      selectedWashers.add(washer);
                                    }
                                  });
                                },
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  IconData _getServiceIcon(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'quick wash':
      case 'хурдан угаалга':
        return Icons.local_car_wash;
      case 'deep clean':
      case 'гүн цэвэрлэгээ':
        return Icons.cleaning_services;
      case 'premium':
      case 'премиум':
        return Icons.auto_awesome;
      case 'full service':
      case 'бүрэн үйлчилгээ':
        return Icons.car_rental;
      default:
        return Icons.design_services;
    }
  }

  Widget _buildServicesByCategory() {
    final groupedServices = <String, List<WashService>>{};
    for (final service in availableServices) {
      final categoryName = service.category.name;
      if (!groupedServices.containsKey(categoryName)) {
        groupedServices[categoryName] = [];
      }
      groupedServices[categoryName]!.add(service);
    }

    // Sort categories by their order
    final sortedCategories = groupedServices.keys.toList()
      ..sort((a, b) {
        final categoryA = availableServices.firstWhere((s) => s.category.name == a).category;
        final categoryB = availableServices.firstWhere((s) => s.category.name == b).category;
        return categoryA.order.compareTo(categoryB.order);
      });

    // Sort services within each category by their order
    for (final categoryName in groupedServices.keys) {
      groupedServices[categoryName]!.sort((a, b) => a.order.compareTo(b.order));
    }

    return ListView.builder(
      itemCount: sortedCategories.length,
      itemBuilder: (context, index) {
        final categoryName = sortedCategories[index];
        final services = groupedServices[categoryName]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                categoryName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2196F3),
                ),
              ),
            ),
            ...services.map((service) {
              final isSelected = selectedService?.id == service.id;
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                color: isSelected ? const Color(0xFF2196F3).withOpacity(0.1) : null,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isSelected ? const Color(0xFF2196F3) : Colors.grey[300],
                    child: Icon(
                      _getServiceIcon(service.category.name),
                      color: isSelected ? Colors.white : Colors.grey[600],
                    ),
                  ),
                  title: Text(service.name),
                  subtitle: Text('${service.price} ₮ • ${service.category.name}'),
                  trailing: isSelected ? const Icon(Icons.check_circle, color: Color(0xFF2196F3)) : null,
                  onTap: () {
                    setState(() {
                      selectedService = service;
                    });
                  },
                ),
              );
            }).toList(),
          ],
        );
      },
    );
  }
} 