import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class RequestOtpEvent extends AuthEvent {
  final String contact;
  final bool isPhone;

  const RequestOtpEvent({
    required this.contact,
    required this.isPhone,
  });

  @override
  List<Object?> get props => [contact, isPhone];
}

class VerifyOtpEvent extends AuthEvent {
  final String contact;
  final String otp;
  final bool isPhone;

  const VerifyOtpEvent({
    required this.contact,
    required this.otp,
    required this.isPhone,
  });

  @override
  List<Object?> get props => [contact, otp, isPhone];
}

class LogoutEvent extends AuthEvent {}

class GetCurrentUserEvent extends AuthEvent {} 