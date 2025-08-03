class ServiceQueries {
 static String getCategory  = '''query {
  washCategory {
   	id,
    name
  }
}''';
static String createWashService = '''
  mutation CreateWashService(\$name: String!, \$price: String!, \$categoryId: Int!, \$organizationId: String!) {
    washService(
      input: {
        name: \$name,
        price: \$price,
        categoryId: \$categoryId,
        organizationId: \$organizationId
      }
    ) {
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