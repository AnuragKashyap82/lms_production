import 'package:get/get.dart';

import '../Model/result_model.dart';
import '../Repository/result_repository.dart';

class ResultController extends GetxController {
  static ResultController get instance => Get.find();

  final isLoading = false.obs;
  final _resultRepository = Get.put(ResultRepository()); // Adjust repository reference
  RxList<ResultModel> allResults = <ResultModel>[].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    fetchResults("cse", "7th Semester");
    super.onInit();
  }

  Future<void> fetchResults(String semester, String branch) async {
    try {
      isLoading.value = true;
      final results = await _resultRepository.getAllResults(); // Adjust repository method

      final filteredResults = results
          .where((result) =>
      result.semester == semester && result.branch == branch)
          .toList();
      allResults.assignAll(filteredResults);

    } catch (e) {
      print(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
