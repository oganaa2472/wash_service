class OrderMutations {
  static String addOrder({
    required String carId,
    required String carPlateNumber,
    required String organizationId,
    required List<int> selectedServices,
 
    required String totalPrice,
    required String completedAt,
  }) => '''
    mutation WashCarOrder {
      washCarOrder(input: {
        carId: $carId,
        carPlateNumber: "$carPlateNumber",
        organizationId: $organizationId,
        selectedService: $selectedServices,
       
        totalPrice: "$totalPrice",
        completedAt: "$completedAt"
      }) {
        carWashOrder {
          id
        }
      }
    }
  ''';

  static String completeOrder({
    required String orderId,
  }) => '''
    mutation CompleteOrder {
      completeOrder(input: {
        orderId: $orderId
      }) {
        order {
          id
          status
          completedAt
        }
      }
    }
  ''';
} 