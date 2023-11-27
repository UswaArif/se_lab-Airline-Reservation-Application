class PaymentMethodRepository{
  static PaymentMethodRepository? _instance;
  PaymentMethodRepository._();

  // Factory constructor to create or retrieve the instance
  factory PaymentMethodRepository() {
    _instance ??= PaymentMethodRepository._(); // Create the instance if it doesn't exist
    return _instance!;
  }

  // Your other class methods and properties here
  //final _db = FirebaseFirestore.instance;
}