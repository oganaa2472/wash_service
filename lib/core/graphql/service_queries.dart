class ServiceQueries {
  static String getWashServices(String companyId) => '''
    query WashService {
      washService(searchBy:["organization_id=$companyId"]) {
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