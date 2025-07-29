import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../../core/graphql/graphql_client.dart';
import '../../../data/datasources/payment_method_remote_data_source.dart';
import '../../../data/repositories/payment_method_repository_impl.dart';
import '../../../domain/usecases/get_payment_methods.dart';
import '../../bloc/payment_method/payment_method_bloc.dart';
import '../../bloc/payment_method/payment_method_event.dart';
import '../../bloc/payment_method/payment_method_state.dart';
import '../../../domain/entities/payment_method.dart';
import '../../../domain/entities/company.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../data/datasources/payment_order_mutation_data_source.dart';

class PaymentPage extends StatefulWidget {
  final double totalAmount;
  final String orderId;
  final Company? company;

  const PaymentPage({
    Key? key,
    required this.totalAmount,
    required this.orderId,
    this.company,
  }) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final List<PaymentMethod> selectedPaymentMethods = [];
  final Map<String, TextEditingController> amountControllers = {};
  final Map<String, String> amountErrors = {};
  double remainingAmount = 0.0;

  @override
  void initState() {
    super.initState();
    remainingAmount = widget.totalAmount;
  }

  @override
  void dispose() {
    amountControllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  void _addPaymentMethod(PaymentMethod paymentMethod) {
    if (!selectedPaymentMethods.contains(paymentMethod)) {
      setState(() {
        selectedPaymentMethods.add(paymentMethod);
        amountControllers[paymentMethod.id] = TextEditingController();
        amountErrors[paymentMethod.id] = '';
      });
    }
  }

  void _removePaymentMethod(PaymentMethod paymentMethod) {
    setState(() {
      selectedPaymentMethods.remove(paymentMethod);
      amountControllers[paymentMethod.id]?.dispose();
      amountControllers.remove(paymentMethod.id);
      amountErrors.remove(paymentMethod.id);
      _updateRemainingAmount();
    });
  }

  void _updateRemainingAmount() {
    double totalEntered = 0.0;
    for (var method in selectedPaymentMethods) {
      final controller = amountControllers[method.id];
      if (controller != null && controller.text.isNotEmpty) {
        totalEntered += double.tryParse(controller.text) ?? 0.0;
      }
    }
    setState(() {
      remainingAmount = widget.totalAmount - totalEntered;
    });
  }

  void _validateAmounts() {
    setState(() {
      amountErrors.clear();
      double totalEntered = 0.0;
      
      for (var method in selectedPaymentMethods) {
        final controller = amountControllers[method.id];
        final amount = double.tryParse(controller?.text ?? '');
        
        if (amount == null || amount <= 0) {
          amountErrors[method.id] = 'Хэмжээ оруулна уу';
        } else {
          totalEntered += amount;
        }
      }
      
      if (totalEntered != widget.totalAmount) {
        for (var method in selectedPaymentMethods) {
          amountErrors[method.id] = 'Нийт дүн ${widget.totalAmount} байх ёстой';
        }
      }
    });
  }

  Widget _buildCompanyAccountInfo() {
    if (widget.company?.accounts == null || widget.company!.accounts!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[50]!, Colors.blue[100]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue[200]!, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue[600],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.account_balance,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Банкны мэдээлэл',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...widget.company!.accounts!.map((account) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.account_circle,
                        size: 18,
                        color: Colors.blue[600],
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          account.accountName,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildAccountInfoRow(
                    Icons.person,
                    'Эзэн',
                    account.accountOwner,
                  ),
                  const SizedBox(height: 8),
                  _buildAccountInfoRow(
                    Icons.credit_card,
                    'IBAN',
                    account.iban,
                  ),
                  const SizedBox(height: 8),
                  _buildAccountInfoRow(
                    Icons.account_balance_wallet,
                    'Данс',
                    account.account,
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[800],
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  IconData _getPaymentMethodIcon(String methodName) {
    final name = methodName.toLowerCase();
    if (name.contains('card') || name.contains('карт')) {
      return Icons.credit_card;
    } else if (name.contains('cash') || name.contains('бэлнэ')) {
      return Icons.money;
    } else if (name.contains('bank') || name.contains('банк')) {
      return Icons.account_balance;
    } else if (name.contains('mobile') || name.contains('утас')) {
      return Icons.phone_android;
    } else {
      return Icons.payment;
    }
  }

  void _processPayment() async {
    _validateAmounts();
    
    if (amountErrors.isNotEmpty) {
      return;
    }

    try {
      final client = GraphQLConfig.initializeClient().value;
      final paymentDataSource = PaymentOrderMutationDataSource(client);
      
      // Process each payment method
      final List<Map<String, dynamic>> paymentResults = [];
      
      for (var method in selectedPaymentMethods) {
        final amount = amountControllers[method.id]!.text;
        
        final paymentId = await paymentDataSource.processOrderPayment(
          orderId: widget.orderId,
          amount: amount,
          paymentMethodId: method.id,
          isConfirmed: true,
          paymentDate: DateTime.now().toIso8601String(),
        );
        
        paymentResults.add({
          'paymentMethodId': method.id,
          'amount': double.parse(amount),
          'paymentMethodName': method.name,
        
        });
      }

      // Show success dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Амжилттай'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Төлбөр амжилттай төлөгдлөө'),
              SizedBox(height: 8),
              ...paymentResults.map((payment) => Padding(
                padding: EdgeInsets.symmetric(vertical: 2),
                child: Text('${payment['paymentMethodName']}: ${payment['amount']}₮'),
              )),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(true); // Return to previous page with success result
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Төлбөр төлөх үед алдаа гарлаа: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Төлбөр төлөх',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocProvider(
        create: (context) => PaymentMethodBloc(
          GetPaymentMethods(
            PaymentMethodRepositoryImpl(
              PaymentMethodRemoteDataSource(
                GraphQLConfig.initializeClient().value,
              ),
            ),
          ),
        )..add(FetchPaymentMethods()),
        child: BlocBuilder<PaymentMethodBloc, PaymentMethodState>(
          builder: (context, state) {
            if (state is PaymentMethodLoading) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[600]!),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Төлбөрийн аргуудыг уншиж байна...',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is PaymentMethodError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red[300],
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Алдаа гарлаа',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      state.message,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<PaymentMethodBloc>().add(FetchPaymentMethods());
                      },
                      icon: Icon(Icons.refresh),
                      label: Text('Дахин оролдох'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[600],
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is PaymentMethodLoaded) {
              return _buildPaymentContent(state.paymentMethods);
            }
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.payment_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Төлбөрийн арга олдсонгүй',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPaymentContent(List<PaymentMethod> paymentMethods) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Company account information
          _buildCompanyAccountInfo(),
          
          // Payment summary card
          Container(
            margin: const EdgeInsets.only(bottom: 24),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.payment,
                        color: Colors.green[700],
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Төлбөрийн дэлгэрэнгүй',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Нийт дүн',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          '${widget.totalAmount.toStringAsFixed(0)}₮',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: remainingAmount < 0 ? Colors.red[100] : Colors.green[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Үлдсэн: ${remainingAmount.toStringAsFixed(0)}₮',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: remainingAmount < 0 ? Colors.red[700] : Colors.green[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Payment methods section
          Text(
            'Төлбөрийн арга сонгох',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16),
          // Payment methods list
          ...paymentMethods.map((method) {
            final isSelected = selectedPaymentMethods.contains(method);
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    if (isSelected) {
                      _removePaymentMethod(method);
                    } else {
                      _addPaymentMethod(method);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue[50] : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? Colors.blue[300]! : Colors.grey[200]!,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.blue[600] : Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            _getPaymentMethodIcon(method.name),
                            color: isSelected ? Colors.white : Colors.grey[600],
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            method.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? Colors.blue[800] : Colors.grey[800],
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.blue[600] : Colors.grey[300],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isSelected ? Icons.check : Icons.radio_button_unchecked,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
          if (selectedPaymentMethods.isNotEmpty) ...[
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.orange[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.edit_note,
                          color: Colors.orange[700],
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Төлбөрийн хэмжээ оруулах',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...selectedPaymentMethods.map((method) {
                    final controller = amountControllers[method.id];
                    final error = amountErrors[method.id];
                    
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                _getPaymentMethodIcon(method.name),
                                color: Colors.blue[600],
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  method.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.remove_circle,
                                  color: Colors.red[400],
                                ),
                                onPressed: () => _removePaymentMethod(method),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: controller,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Хэмжээ',
                              errorText: error,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.grey[300]!),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.grey[300]!),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.blue[600]!),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.red[400]!),
                              ),
                              suffixText: '₮',
                              suffixStyle: TextStyle(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w600,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            onChanged: (value) {
                              _updateRemainingAmount();
                            },
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ],
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: selectedPaymentMethods.isNotEmpty ? _processPayment : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[600],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.payment, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Төлбөр төлөх',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}