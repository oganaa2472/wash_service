class ServiceQueries {
 static String getCategory  = '''query {
  washCategory {
   	id,
    name
  }
}''';

static String getUsers = '''query Users {
    users(skip: 0, first: 10) {
        id
        lastLogin
        username
        firstName
        lastName
        email
        isStaff
        isActive
        dateJoined
        phone
        isPhoneVerified
        isMailVerified
        password
        isSuperuser
    }
}''';
static String createWashService = '''
  mutation CreateWashService(\$name: String!, \$price: Decimal!, \$categoryId: ID!, \$organizationId: Int!) {
    washService(
      input: {
        name: \$name,
        price: \$price,
        categoryId: \$categoryId,
        organizationId: \$organizationId
      }
    ) {
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
  }
''';

static String addWashEmployee = '''
  mutation AddWashEmployee(\$organizationId: Int!, \$employeeId: Int!, \$skillPercentage: Decimal!) {
    washEmployee(
      input: {
        organizationId: \$organizationId,
        employeeId: \$employeeId,
        skillPercentage: \$skillPercentage
      }
    ) {
      organizationEmployee {
        id
        organizationId
        employeeId
        fullName
        skillPercentage
        salaryInfo
        isActive
        joinedAt
        leftAt
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