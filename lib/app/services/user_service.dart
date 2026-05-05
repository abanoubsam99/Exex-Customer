
class UserViewModel {
  final String? userName;
  UserViewModel({this.userName});
}

class UserModel {
  final UserViewModel? userViewModel;
  UserModel({this.userViewModel});
}

class UserService {
  final currentUser = _Rx<UserModel?>(UserModel(userViewModel: UserViewModel(userName: 'Guest')));
  void logout() {}
}

class _Rx<T> {
  T value;
  _Rx(this.value);
}
