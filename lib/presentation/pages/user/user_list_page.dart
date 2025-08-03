import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/entities/company.dart';
import '../../bloc/user/user_bloc.dart';
import '../../bloc/user/user_event.dart';
import '../../bloc/user/user_state.dart';

class UserListPage extends StatefulWidget {
  final Company? company;
  
  const UserListPage({Key? key, this.company}) : super(key: key);

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  @override
  void initState() {
    super.initState();
    print('UserListPage: initState called');
    print('UserListPage: Company: ${widget.company?.name ?? 'No company'}');
    // Fetch users when page loads
    context.read<UserBloc>().add(const FetchUsers());
    print('UserListPage: FetchUsers event dispatched');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ажилдын жагсаалт',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<UserBloc>().add(const FetchUsers());
            },
          ),
        ],
      ),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          print('UserListPage: BlocBuilder state: ${state.runtimeType}');
          if (state is UserLoading) {
            print('UserListPage: Showing loading state');
            return Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                color: Theme.of(context).primaryColor,
                size: 50,
              ),
            );
          } else if (state is UserLoaded) {
            print('UserListPage: UserLoaded state with ${state.users.length} users');
            if (state.users.isEmpty) {
              print('UserListPage: No users found, showing empty state');
              return _buildEmptyState();
            }
            print('UserListPage: Building user list with ${state.users.length} users');
            return _buildUserList(state.users);
          } else if (state is UserError) {
            print('UserListPage: Error state: ${state.message}');
            return _buildErrorState(state.message);
          }
          print('UserListPage: Default state, showing empty state');
          return _buildEmptyState();
        },
      ),
    );
  }

  Widget _buildUserList(List<User> users) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<UserBloc>().add(const FetchUsers());
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return _buildUserCard(user);
        },
      ),
    );
  }

  Widget _buildUserCard(User user) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          _showUserDetails(user);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                    child: Icon(
                      Icons.person,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${user.username ?? 'N/A'} ${user.lastName ?? ''}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (user.email != null && user.email!.isNotEmpty)
                          Row(
                            children: [
                              Icon(
                                Icons.email,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  user.email!,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey[400],
                  ),
                ],
              ),
              if (user.phone != null && user.phone!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.phone,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      user.phone!,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Хэрэглэгч олдсонгүй',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Шинэ хэрэглэгч нэмэх бол доорх товчийг дарна уу',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              context.read<UserBloc>().add(const FetchUsers());
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Дахин ачаалах'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Алдаа гарлаа',
            style: TextStyle(
              fontSize: 18,
              color: Colors.red[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              message,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              context.read<UserBloc>().add(const FetchUsers());
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Дахин оролдох'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showUserDetails(User user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                child: Icon(
                  Icons.person,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Хэрэглэгчийн мэдээлэл',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Нэр:', user.username ?? 'N/A'),
              _buildDetailRow('Овог:', user.lastName ?? 'N/A'),
              _buildDetailRow('И-мэйл:', user.email ?? 'N/A'),
              _buildDetailRow('Утас:', user.phone ?? 'N/A'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Хаах'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // TODO: Navigate to edit user page
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Засах функц удахгүй нэмэгдэнэ')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Засах'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 60,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
