

import 'package:fitnessapp/src/common/constant/colors.dart';
import 'package:fitnessapp/src/common/constant/fitbitconst.dart';
import 'package:fitnessapp/src/common/utils/custom_cotainer.dart';
import 'package:fitnessapp/src/common/utils/text_widget.dart';
import 'package:fitnessapp/src/repository/fitbit_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FitbitMapScreen extends StatefulWidget {
  const FitbitMapScreen({super.key});

  @override
  _FitbitMapScreenState createState() => _FitbitMapScreenState();
}

class _FitbitMapScreenState extends State<FitbitMapScreen> {



@override
  void dispose() {
    FitBitConst.mapController!.dispose(); // Dispose of the map controller
    FitBitConst.mapController=null; // Dispose of the map controller
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: GoogleMap(
            initialCameraPosition: FitBitConst.points.isNotEmpty
                ? CameraPosition(target: FitBitConst.points.first, zoom: 14)
                : const CameraPosition(
                    target: LatLng(37.7749, -122.4194), zoom: 10),
            polylines: FitBitConst.polylines,
            markers: FitBitConst.markers,
            onMapCreated: (GoogleMapController controller) {
              FitBitConst.mapController = controller;
            Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted && FitBitConst.points.isNotEmpty) {
          FitBitRepo().autoZoomToPolyline();
        }
          });
            },
          ),
        ),
        Positioned(
          bottom: 5.h,
          left: 3.w,
          child: CustomContainer(
          padding: EdgeInsets.symmetric(horizontal: 5.w,vertical: 3.h),
            color: AppColors.primaryColor,
            borderRadius: 5.sp,
            child:  Row(
              children: [
                TextWidget(
                                      text: (FitBitConst.totalDistance??0.0).toString().substring(0,4),
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.txtColor,
                                    ),
                TextWidget(
                                      text: " Kilometers",
                                      fontSize: 12.sp,
                                      color: AppColors.txtColor,
                                    ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
