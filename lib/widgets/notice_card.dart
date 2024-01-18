import 'package:eduventure/Model/notice_model.dart';
import 'package:flutter/material.dart';
import '../utils/colors.dart';

class NoticeCard extends StatefulWidget {
  final NoticeModel noticeModel;
  const NoticeCard({Key? key, required this.noticeModel}) : super(key: key);

  @override
  State<NoticeCard> createState() => _NoticeCardState();
}

class _NoticeCardState extends State<NoticeCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: gray02,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          children: [
            Icon(
              Icons.school_rounded,
              size: 36,
              color: colorPrimary,
            ),
            SizedBox(
              width: 8,
            ),
            Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.noticeModel.noticeTitle,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    widget.noticeModel.noticeNo,
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
                    widget.noticeModel.dateTime,
                    style: TextStyle(fontWeight: FontWeight.w100, fontSize: 12),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
