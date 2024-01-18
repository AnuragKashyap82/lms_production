import 'package:eduventure/Model/result_model.dart';
import 'package:flutter/material.dart';
import '../utils/colors.dart';

class ResultCard extends StatefulWidget {
  final ResultModel resultModel;
  const ResultCard({Key? key, required this.resultModel}) : super(key: key);

  @override
  State<ResultCard> createState() => _ResultCardState();
}

class _ResultCardState extends State<ResultCard> {
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
                Icons.school_rounded,
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
                      "Result Year: ${widget.resultModel.resultYear}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      widget.resultModel.branch,
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
                      widget.resultModel.dateTime,
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
