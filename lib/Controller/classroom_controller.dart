import 'package:get/get.dart';

import '../Model/classroom_model.dart';
import '../Repository/classroom_repository.dart';

class ClassroomController extends GetxController {
  static ClassroomController get instance => Get.find();

  final isLoading = false.obs;
  final _classroomRepository = Get.put(ClassroomRepository()); // Adjust repository reference
  RxList<ClassroomModel> allClassrooms = <ClassroomModel>[].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    fetchClassrooms();
    super.onInit();
  }

  Future<void> fetchClassrooms() async {
    try {
      isLoading.value = true;
      final classrooms = await _classroomRepository.getAllClassrooms(); // Adjust repository method

      // Filter all Classrooms
      allClassrooms.assignAll(classrooms);

    } catch (e) {
      print(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
