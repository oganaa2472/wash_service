import 'package:flutter_bloc/flutter_bloc.dart';
import 'user_event.dart';
import 'user_state.dart';
import '../../../domain/usecases/get_users.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUsers getUsers;

  UserBloc(this.getUsers) : super(UserInitial()) {
    on<FetchUsers>(_onFetchUsers);
  }

  Future<void> _onFetchUsers(
    FetchUsers event,
    Emitter<UserState> emit,
  ) async {
    print('UserBloc: Starting to fetch users');
    emit(UserLoading());
    try {
      print('UserBloc: Calling getUsers use case');
      final users = await getUsers();
      print('UserBloc: Received ${users.length} users');
      for (var user in users) {
        print('User: ${user.username} ${user.lastName} - ${user.email} - ${user.phone}');
      }
      emit(UserLoaded(users));
    } catch (e) {
      print('UserBloc: Error fetching users: $e');
      emit(UserError(e.toString()));
    }
  }
}
