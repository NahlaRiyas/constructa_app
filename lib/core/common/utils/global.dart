import 'package:flutter/material.dart';
import '../../../theme/palette.dart';


/// Global dimensions initialized as double w = 0.0 and double height = 0.0
double w = 0.0;
double height = 0.0;
double devicePixelRatio = 1.0;
Orientation globalOrientation = Orientation.portrait;

/// Global helper function to initialize screen dimensions using MediaQuery
void initScreenSize(BuildContext context) {
  final mediaQuery = MediaQuery.of(context);
  w = mediaQuery.size.width;
  height = mediaQuery.size.height;
  devicePixelRatio = mediaQuery.devicePixelRatio;
  globalOrientation = mediaQuery.orientation;
}

/// Accessing app colors via AppColors.colorName
Color primaryColor = AppColors.primary;
Color secondaryColor = AppColors.secondary;
Color backgroundColor = AppColors.background;
