import 'dart:async';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'assistant_event.dart';
import 'assistant_state.dart';

class AssistantBloc extends Bloc<AssistantEvent, AssistantState> {
  AssistantBloc() : super(const AssistantState()) {
    on<SendMessageEvent>(_onSendMessage);
  }

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<AssistantState> emit,
  ) async {
    final userMessage = ChatMessage(text: event.message, isUser: true);
    emit(state.copyWith(
      messages: List.from(state.messages)..add(userMessage),
      isLoading: true,
      error: null,
    ));
    try {
      final reply = await sendToOpenAI(event.message);
      final assistantMessage = ChatMessage(
        text: reply ?? 'Assistant: Хариу ирсэнгүй.',
        isUser: false,
      );
      emit(state.copyWith(
        messages: List.from(state.messages)..add(assistantMessage),
        isLoading: false,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<String?> sendToOpenAI(String userMessage) async {
    String apiUrl = 'https://api.openai.com/v1/chat/completions';
    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer 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',
        },
        body: json.encode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {
              'role': 'system',
              'content': '''\
You are an assistant for MGL Smart Service, a car wash company in Mongolia.
Our services include:
- Quick Wash
- Deep Clean
- Full Service
- Premium

We are open from 8am to 8pm every day.
Prices start from 10,000₮.
Our main location is in Ulaanbaatar, but we have several branches.
You can book a service via our mobile app or by calling +976-12345678.
We offer a 10% discount for first-time customers.

If the user asks about our services, pricing, how to book, location, or special offers, answer with this information in Mongolian.
''',
            },
            {
              'role': 'user',
              'content': 'Please respond in Mongolian only: $userMessage',
            },
          ],
          'max_tokens': 250,
        }),
      );
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var responseText = data['choices'][0]['message']['content'];
        if (responseText != null) {
          return utf8.decode(responseText.runes.toList()).trim();
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }
} 