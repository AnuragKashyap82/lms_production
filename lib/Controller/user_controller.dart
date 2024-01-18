import 'package:eduventure/Model/user_model.dart';
import 'package:eduventure/Repository/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  final _auth = FirebaseAuth.instance;
  Rx<UserModel> userData = UserModel.empty().obs;
  static UserController get instance => Get.find();

  final isLoading = false.obs;
  final _userRepository = Get.put(UserRepository());

  @override
  void onInit() {
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      isLoading.value = true;
      final user = _auth.currentUser;
      if (user != null) {
        final data = await _userRepository.getUserData(user.uid);
        isLoading.value = false;
        userData.value = data;
      }
    } catch (e) {
      print(e.toString());
      isLoading.value = false;
    }
  }
}
