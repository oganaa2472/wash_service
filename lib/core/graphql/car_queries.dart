class CarQueries {
  static const String getCarList = '''
    query carlist {
      car {
        id
        phone
        licensePlate
        make {
          name
        }
        model {
          name
        }
        color
      }
    }
  ''';
} 