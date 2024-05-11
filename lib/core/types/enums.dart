// enum StatusCode { operationSucceeded, operationFailed, serverError }

// extension FetchCode on StatusCode {
//   int get code {
//     switch (this) {
//       case StatusCode.operationSucceeded:
//         return 200;
//       case StatusCode.operationFailed:
//         return 400;
//       case StatusCode.serverError:
//         return 500;
//     }
//   }
// }

enum StatusCode {
  operationSucceeded(200),
  operationFailed(400),
  unAuthorized(401),
  forbidden(403),
  serverError(500),
  ;

  const StatusCode(this.code);

  final int code;
}

enum Status { initial, loading, success, failure }

enum SocialType { facebook, google, apple }

enum AccountType { basic_account, agency_account, exhibition_account }

enum Gender { male, female }

enum PaymentType {
  cash('cash'),
  installment('installment'),
  both('both');

  final String value;
  const PaymentType(this.value);
}

enum CarsCondition {
  New('new'),
  used('used'),
  both('both');

  final String value;
  const CarsCondition(this.value);
}

enum TransmissionType {
  manual('manual'),
  automatic('automatic'),
  both('both');

  final String value;
  const TransmissionType(this.value);
}

enum WheelDriveType { front, back, four }

enum Currency { iqd, usd }

enum AuthenticateBy { phone, email }

enum SendOTPBy { email, sms, whatsapp }

enum OSType { ios, android }

AccountType? stringToAccountType(String? value) {
  if (value == null) return null;
  switch (value) {
    case 'basic_account':
      return AccountType.basic_account;
    case 'agency_account':
      return AccountType.agency_account;
    case 'exhibition_account':
      return AccountType.exhibition_account;
    default:
      return AccountType.basic_account;
  }
}

CarsCondition? stringToCarsCondition(String? value) {
  if (value == null) return null;
  switch (value) {
    case 'new':
      return CarsCondition.New;
    case 'used':
      return CarsCondition.used;
    case 'both':
      return CarsCondition.both;
    default:
      return CarsCondition.New;
  }
}

PaymentType? stringToPaymentType(String? value) {
  if (value == null) return null;
  switch (value) {
    case 'cash':
      return PaymentType.cash;
    case 'installment':
      return PaymentType.installment;
    case 'both':
      return PaymentType.both;
    default:
      return PaymentType.cash;
  }
}

String handlePayment(PaymentType type) {
  switch (type) {
    case PaymentType.cash:
      return 'cash';
    case PaymentType.installment:
      return 'installment';
    case PaymentType.both:
      return 'both';
  }
}

enum SortBy {
  low_to_high('من الاقل سعرا الي الاعلي'),
  high_to_low('من الاعلي سعرا الي الاقل'),
  lowest_distance('من الاقل مسافة مقطوعة الي الاعلي'),
  high_distance('من الاعلي مسافة مقطوعة الي الاقل'),
  latest('من الاحدث الي الاقدم'),
  oldest('من الاقدم الي الاحدث'),
  none('none');

  final String title;
  const SortBy(this.title);
}
