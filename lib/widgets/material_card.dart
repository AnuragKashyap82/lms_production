import 'package:eduventure/Model/material_model.dart';
import 'package:flutter/material.dart';
import '../utils/colors.dart';

class MaterialCard extends StatefulWidget {
  final MaterialModel materialModel;
  const MaterialCard({Key? key, required this.materialModel}) : super(key: key);

  @override
  State<MaterialCard> createState() => _MaterialCardState();
}

class _MaterialCardState extends State<MaterialCard> {
  @override
  Widget build(BuildContext context) {
    return
      Padding(
          padding: EdgeInsets.all(4),
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: gray02,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.library_books_rounded,
                  size: 36, color: colorPrimary,
                ),
                SizedBox(
                  width: 8,
                ),
                Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${widget.materialModel.subName}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        widget.materialModel.subTopic,
                        style: TextStyle(
                            fontWeight: FontWeight.w100, fontSize: 12),
                      ),
                    ]),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        widget.materialModel.dateTime,
                        style:
                        TextStyle(fontWeight: FontWeight.w100, fontSize: 12),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ));
  }
}
