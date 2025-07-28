import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../bloc/assistant/assistant_bloc.dart';
import '../../bloc/assistant/assistant_event.dart';
import '../../bloc/assistant/assistant_state.dart';
import 'home_page.dart';

class AssistantPage extends StatelessWidget {
  const AssistantPage({Key? key}) : super(key: key);

  void _navigateToHome(BuildContext context, int tabIndex) {
    context.go('/home', extra: {
      'userType': UserType.customer,
      'tabIndex': tabIndex,
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AssistantBloc()
        ..add(const SendMessageEvent('Сайн байна уу! Би танд хэрхэн туслах вэ?')), // Welcome message
      child: const _AssistantView(),
    );
  }
}

class _AssistantView extends StatefulWidget {
  const _AssistantView({Key? key}) : super(key: key);

  @override
  State<_AssistantView> createState() => _AssistantViewState();
}

class _AssistantViewState extends State<_AssistantView> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _sendMessage(BuildContext context) {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    context.read<AssistantBloc>().add(SendMessageEvent(text));
    _controller.clear();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Navigation', style: TextStyle(color: Colors.white, fontSize: 22)),
            ),
            ListTile(
              leading: const Icon(Icons.local_car_wash),
              title: const Text('Car Wash'),
              onTap: () {
                Navigator.of(context).pop();
                context.go('/home', extra: {
                  'userType': UserType.customer,
                  'tabIndex': 0,
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.build),
              title: const Text('Car Repair'),
              onTap: () {
                Navigator.of(context).pop();
                context.go('/home', extra: {
                  'userType': UserType.customer,
                  'tabIndex': 1,
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.engineering),
              title: const Text('Operator Mode'),
              onTap: () {
                Navigator.of(context).pop();
                context.go('/home', extra: {
                  'userType': UserType.operator,
                  'tabIndex': 0,
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.system_update),
              title: const Text('Version Check'),
              onTap: () {
                Navigator.of(context).pop();
                context.go('/version-check');
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('AI Assistant'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<AssistantBloc, AssistantState>(
              builder: (context, state) {
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: state.messages.length,
                  itemBuilder: (context, index) {
                    final message = state.messages[index];
                    final isUser = message.isUser;
                    
                    return Align(
                      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isUser ? Colors.blue : Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          message.text,
                          style: TextStyle(
                            color: isUser ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _sendMessage(context),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => _sendMessage(context),
                  icon: const Icon(Icons.send),
                  color: Colors.blue,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 