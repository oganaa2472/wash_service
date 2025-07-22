class AuthQueries {
  static String login = '''
    mutation Login(\$email: String!, \$password: String!) {
      login(input: { email: \$email, password: \$password }) {
        user {
          id
          name
          email
          phoneNumber
        }
        token
      }
    }
  ''';

  static String register = '''
    mutation Register(\$name: String!, \$email: String!, \$password: String!, \$phoneNumber: String!) {
      register(input: {
        name: \$name,
        email: \$email,
        password: \$password,
        phoneNumber: \$phoneNumber
      }) {
        user {
          id
          name
          email
          phoneNumber
        }
        token
      }
    }
  ''';

  static String getCurrentUser = '''
    query GetCurrentUser {
      me {
        id
        name
        email
        phoneNumber
      }
    }
  ''';

  static String logout = '''
    mutation Logout {
      logout {
        success
        message
      }
    }
  ''';
} 