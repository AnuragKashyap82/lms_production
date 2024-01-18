import 'package:eduventure/Model/user_model.dart';
import 'package:eduventure/Repository/faculty_repositiory.dart';
import 'package:get/get.dart';

class FacultyController extends GetxController {
  static FacultyController get instance => Get.find();

  final isLoading = false.obs;
  final _noticeRepository = Get.put(FacultyRepository()); // Adjust repository reference
  RxList<UserModel> allFaculties = <UserModel>[].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    fetchFaculty();
    super.onInit();
  }

  Future<void> fetchFaculty() async {
    try {
      isLoading.value = true;
      final faculty = await _noticeRepository.getAllFaculty(); // Adjust repository method

      // Filter all Notices
      allFaculties.assignAll(faculty);

    } catch (e) {
      print(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
