class EmployeeQueries {
  static String getWashEmployees(String companyId) => '''
    query washEmployee {
      washEmployee(searchBy:["organization_id=$companyId"]) {
        skillPercentage,
        employeeId,
        id,
        isActive
        employee {
          id,
          username,
          lastName,
          phone,
          email,
          isMailVerified,
          isPhoneVerified
        }
      }
    }
  ''';
} 