import 'package:eduventure/Controller/user_controller.dart';
import 'package:eduventure/Model/time_table_model.dart';
import 'package:eduventure/Repository/time_table_faculty_reepository.dart';
import 'package:get/get.dart';
import '../Repository/time_table_repository.dart';

class FacultyTimeTableControllerController extends GetxController {
  static FacultyTimeTableControllerController get instance => Get.find();

  final UserController userController = Get.find();

  final isLoading = false.obs;
  final _facultyTimeTableRepository = Get.put(TimetableFacultyRepository()); // Adjust repository reference
  RxList<TimetableModel> mondayTimeTable = <TimetableModel>[].obs;
  RxList<TimetableModel> tuesdayTimeTable = <TimetableModel>[].obs;
  RxList<TimetableModel> wednesdayTimeTable = <TimetableModel>[].obs;
  RxList<TimetableModel> thursdayTimeTable = <TimetableModel>[].obs;
  RxList<TimetableModel> fridayTimeTable = <TimetableModel>[].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    fetchTimeTable();
    super.onInit();
  }


  Future<void> fetchTimeTable() async {
      try {
        isLoading.value = true;
        final timeTable = await _facultyTimeTableRepository.getAllFacultyTimetables(userController.userData().uid); // Adjust repository method

        ///Filter by day
        final filteredTimeTable = timeTable.where((anurag) => anurag.day == "Monday").toList();
        mondayTimeTable.assignAll(filteredTimeTable);

        print("DATA: [$mondayTimeTable]");

        ///Filter by day
        final filteredTuesTimeTable = timeTable.where((anurag) => anurag.day == "Tuesday").toList();
        tuesdayTimeTable.assignAll(filteredTuesTimeTable);

        ///Filter by day
        final filteredWedTimeTable = timeTable.where((anurag) => anurag.day == "Wednesday").toList();
        wednesdayTimeTable.assignAll(filteredWedTimeTable);

        ///Filter by day
        final filteredThurTimeTable = timeTable.where((anurag) => anurag.day == "Thursday").toList();
        thursdayTimeTable.assignAll(filteredThurTimeTable);

        ///Filter by day
        final filteredFriTimeTable = timeTable.where((anurag) => anurag.day == "Friday").toList();
        fridayTimeTable.assignAll(filteredFriTimeTable);

      } catch (e) {
        print(e.toString());
      } finally {
        isLoading.value = false;
      }
  }
}
