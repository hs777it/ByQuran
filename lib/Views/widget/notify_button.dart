import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'custom_text.dart';
import '../../constant.dart';

class NotifyButton extends StatelessWidget {
  const NotifyButton({super.key, required this.active, this.onChanged});

  final bool active;
  final Function(bool)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Switch(
            activeColor: kMainColor,
            value: active,
            onChanged: onChanged,
            // (value) async {
            //   await OneSignal.shared.disablePush(!value);
            //   setState(() {});
            // },
          ),
          CustomText(
            text: 'تفعيل الإشعارات',
            color: kMainColor,
            fontSize: 17.sp,
          )
        ],
      ),
    );
  }
}
