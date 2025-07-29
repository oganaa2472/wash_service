class PaymentOrderMutations {
  static String washOrderPayment({
    required String orderId,
    required String amount,
    required String paymentMethodId,
    required bool isConfirmed,
    required String paymentDate,
  }) => '''
    mutation WashOrderPayment {
      washOrderPayment(input: {
        orderId: $orderId,
        amount: "$amount",
        paymentMethodId: $paymentMethodId,
        isConfirmed: $isConfirmed,
        paymentDate: "$paymentDate"
      }) {
        orderPayment {
          id
          
        }
      }
    }
  ''';
} 