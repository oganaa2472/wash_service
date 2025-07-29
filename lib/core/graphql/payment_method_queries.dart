class PaymentMethodQueries {
  static const String getPaymentMethods = '''
    query washorderpayment {
      washPaymentMethod {
        name
        id
      }
    }
  ''';
} 