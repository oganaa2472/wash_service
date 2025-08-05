class OrderQueries {
  static String getWashCarOrders(String companyId) => '''
    query WashCarOrder {
      washCarOrder(searchBy:["organization_id=$companyId"]) {
        id,
        organizationId,
        carId,
        carPlateNumber,
      selectedService {
            totalCount
            edgeCount
            edges {
                cursor
                node {
                    id
                    organizationId
                    name
                    description
                    price
                    order
                    isActive
                    createdAt
                    deleteDate
                    updatedAt
                }
            }
        }
        totalPrice,
        status,
        paymentStatus,
        completedAt,
        orderDate
      }
    }
  ''';
} 