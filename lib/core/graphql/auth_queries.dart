class AuthQueries {
  static String requestOtpEmail = '''
    mutation mailCode(\$email: String!) {
      mailCode(email: \$email) {
        __typename
        mail {
          id
        }
      }
    }
  ''';

  static String requestOtpPhone = '''
    mutation smsCode(\$phone: String!) {
      smsCode(phone: \$phone) {
        __typename
        phone {
          id
        }
      }
    }
  ''';

  static String verifyOtp = '''
    mutation verifyCode(\$contact: String!, \$code: String!, \$isPhone: Boolean!) {
      verifyCode(input: {
        contact: \$contact,
        code: \$code,
        isPhone: \$isPhone
      }) {
        token
        user {
          id
          name
          email
          phoneNumber
        }
      }
    }
  ''';

  static String getCurrentUser = '''
    query me {
      me {
        id
        name
        email
        phoneNumber
      }
    }
  ''';

  static String logout = '''
    mutation logout {
      logout {
        success
        message
      }
    }
  ''';
} 