class OrderMutations {
  static String addOrder({
    required String carId,
    required String carPlateNumber,
    required String organizationId,
    required String selectedServiceId,
    required String status,
    required String totalPrice,
    required String completedAt,
  }) => '''
    mutation WashCarOrder {
      washCarOrder(input: {
        carId: $carId,
        carPlateNumber: "$carPlateNumber",
        organizationId: $organizationId,
        selectedServiceId: $selectedServiceId,
        totalPrice: "$totalPrice",
        completedAt: "$completedAt"
      }) {
        carWashOrder {
          id
        }
      }
    }
  ''';
} 