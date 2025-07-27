import 'package:equatable/equatable.dart';

abstract class AssistantEvent extends Equatable {
  const AssistantEvent();

  @override
  List<Object?> get props => [];
}

class SendMessageEvent extends AssistantEvent {
  final String message;
  const SendMessageEvent(this.message);

  @override
  List<Object?> get props => [message];
} 