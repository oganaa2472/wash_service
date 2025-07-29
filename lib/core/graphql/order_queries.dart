class OrderQueries {
  static String getWashCarOrders(String companyId) => '''
    query WashCarOrder {
      washCarOrder(searchBy:["organization_id=$companyId"]) {
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