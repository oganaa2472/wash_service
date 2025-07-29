class OrderQueries {
  static const String getWashCarOrders = '''
    query WashCarOrder {
      washCarOrder(searchBy:["organization_id=21"]) {
        id,
        organizationId,
        carId,
        carPlateNumber,
        selectedService{
          name
        },
        totalPrice,
        status,
        paymentStatus,
        completedAt,
        orderDate
      }
    }
  ''';
} 