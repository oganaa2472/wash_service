class TimeQueries {
  static String getServerTime = '''
    query GetServerTime {
      serverTime {
        currentTime
        timezone
      }
    }
  ''';

  static String getTimeSlots = '''
    query GetTimeSlots(\$date: String!) {
      timeSlots(date: \$date) {
        id
        startTime
        endTime
        isAvailable
      }
    }
  ''';

  static String bookTimeSlot = '''
    mutation BookTimeSlot(\$slotId: ID!, \$serviceId: ID!) {
      bookTimeSlot(input: {
        timeSlotId: \$slotId
        serviceId: \$serviceId
      }) {
        booking {
          id
          startTime
          endTime
          status
        }
        errors {
          field
          message
        }
      }
    }
  ''';
} 