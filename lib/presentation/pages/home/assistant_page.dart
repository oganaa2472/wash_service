import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../bloc/assistant/assistant_bloc.dart';
import '../../bloc/assistant/assistant_event.dart';
import '../../bloc/assistant/assistant_state.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/localization/locale_provider.dart';
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

  void _showLanguageDialog(BuildContext context, LocaleProvider localeProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.language, color: Colors.blue),
              const SizedBox(width: 8),
              const Text(
                'Select Language',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.flag),
                title: const Text('English'),
                subtitle: const Text('EN'),
                selected: localeProvider.locale.languageCode == 'en',
                onTap: () {
                  localeProvider.setLanguage('en');
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Language changed to English'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.flag),
                title: const Text('Монгол'),
                subtitle: const Text('MN'),
                selected: localeProvider.locale.languageCode == 'mn',
                onTap: () {
                  localeProvider.setLanguage('mn');
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Хэл Монгол руу өөрчлөгдлөө'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
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
            const Divider(),
            // Settings Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Settings',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.of(context).pop();
                context.go('/settings');
              },
            ),
            
            Consumer<LocaleProvider>(
              builder: (context, localeProvider, child) {
                return ListTile(
                  leading: const Icon(Icons.language),
                  title: const Text('Language'),
                  subtitle: Text(
                    localeProvider.locale.languageCode == 'en' ? 'English' : 'Монгол',
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    _showLanguageDialog(context, localeProvider);
                  },
                );
              },
            ),
            const Divider(),
            // Account Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Account',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout'),
              onTap: () {
                Navigator.of(context).pop();
                context.go('/login');
              
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