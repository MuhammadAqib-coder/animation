import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NearBySearchView extends StatefulWidget {
  const NearBySearchView({super.key});

  @override
  State<NearBySearchView> createState() => _NearBySearchViewState();
}

class _NearBySearchViewState extends State<NearBySearchView> {
  String type = '';
  var controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Near By Search"),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context, type);
              },
              child: const Text("Search"))
        ],
      ),
      body: Column(
        children: [
          TextField(
            controller: controller,
            decoration: InputDecoration(
                hintText: 'restuarant, hospital etc',
                isDense: true,
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide(color: Colors.black, width: 2.sp))),
          ),
        ],
      ),
    );
  }
}
