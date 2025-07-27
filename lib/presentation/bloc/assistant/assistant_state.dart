import 'package:equatable/equatable.dart';

class AssistantState extends Equatable {
  final List<ChatMessage> messages;
  final bool isLoading;
  final String? error;

  const AssistantState({
    this.messages = const [],
    this.isLoading = false,
    this.error,
  });

  AssistantState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    String? error,
  }) {
    return AssistantState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [messages, isLoading, error];
}

class ChatMessage extends Equatable {
  final String text;
  final bool isUser;
  const ChatMessage({required this.text, required this.isUser});

  @override
  List<Object?> get props => [text, isUser];
} 