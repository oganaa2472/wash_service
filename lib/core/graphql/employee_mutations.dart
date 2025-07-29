class EmployeeMutations {
  static String assignEmployeeToOrder({
    required String orderId,
    required String workId,
    required String assignedAt,
    required String calculatedSalary,
  }) => '''
    mutation WashEmployee {
      washOrderEmployee(
        input: { 
          orderId: $orderId, 
          workId: $workId, 
          assignedAt: "$assignedAt",
          calculatedSalary: "$calculatedSalary"
        }
      ) {
        orderEmployee {
          id
        }
      }
    }
  ''';
} 