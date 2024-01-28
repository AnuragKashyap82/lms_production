import 'package:eduventure/Controller/material_controller.dart';
import 'package:eduventure/screens/material_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../utils/colors.dart';
import '../widgets/material_card.dart';

class AllMaterialsScreen extends StatefulWidget {
  final String semester;
  final String branch;
  final String userType;
  const AllMaterialsScreen({Key? key, required this.semester, required this.branch, required this.userType}) : super(key: key);

  @override
  State<AllMaterialsScreen> createState() => _AllMaterialsScreenState();
}

class _AllMaterialsScreenState extends State<AllMaterialsScreen> {

  MaterialController materialsController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    materialsController.fetchMaterials(widget.semester, widget.branch);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorPrimary,

        elevation: 0,
        iconTheme: IconThemeData(color: colorBlack),
        title: Text("${widget.semester} - ${widget.branch}",style: TextStyle(fontSize: 16, color: colorBlack, fontWeight: FontWeight.bold),),
      ),
      body: Obx(() {
        if (materialsController.isLoading.value)
          return  Center(
            child:
            CircularProgressIndicator(strokeWidth: 2, color: colorPrimary),
          );
        if (materialsController.allMaterials.isEmpty) {
          return Center(
            child: Text(
              "No Material",
              style: TextStyle(
                fontSize: 14,
                color: colorBlack,
              ),
            ),
          );
        }
        return ListView.builder(
          itemCount: materialsController.allMaterials.length,
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          itemBuilder: (_, index) {
            final material = materialsController.allMaterials[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => MaterialDetailsScreen(
                  materialModel: material,
                  userType: widget.userType,
                )));
              },
              child: Container(
                child: MaterialCard(
                  materialModel: material,
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
