class ServiceQueries {
  static String getWashServices(String companyId) => '''
    query WashService {
      washService {
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
        category {
          id
          name
          description
          order
          carInfo
          createdAt
          deleteDate
          updatedAt
        }
      }
    }
  ''';
} 