import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_constants.dart';

class ResponsiveHelper {
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < AppConstants.mobileBreakpoint;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= AppConstants.mobileBreakpoint &&
      MediaQuery.of(context).size.width < AppConstants.tabletBreakpoint;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= AppConstants.tabletBreakpoint;

  static double getScreenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double getScreenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static EdgeInsets getScreenPadding(BuildContext context) {
    if (isMobile(context)) {
      return EdgeInsets.all(AppConstants.defaultPadding.w);
    } else if (isTablet(context)) {
      return EdgeInsets.all(AppConstants.largePadding.w);
    } else {
      return EdgeInsets.symmetric(
        horizontal: getScreenWidth(context) * 0.1,
        vertical: AppConstants.largePadding.h,
      );
    }
  }

  static double getCardWidth(BuildContext context) {
    final screenWidth = getScreenWidth(context);
    if (isMobile(context)) {
      return screenWidth - (AppConstants.defaultPadding * 2).w;
    } else if (isTablet(context)) {
      return screenWidth * 0.8;
    } else {
      return screenWidth * 0.6;
    }
  }

  static int getGridColumns(BuildContext context) {
    if (isMobile(context)) {
      return 2;
    } else if (isTablet(context)) {
      return 3;
    } else {
      return 4;
    }
  }

  static double getFontSize(BuildContext context, double baseFontSize) {
    if (isMobile(context)) {
      return baseFontSize.sp;
    } else if (isTablet(context)) {
      return (baseFontSize * 1.1).sp;
    } else {
      return (baseFontSize * 1.2).sp;
    }
  }

  static double getButtonHeight(BuildContext context) {
    if (isMobile(context)) {
      return AppConstants.buttonHeight.h;
    } else if (isTablet(context)) {
      return (AppConstants.buttonHeight * 1.1).h;
    } else {
      return (AppConstants.buttonHeight * 1.2).h;
    }
  }

  static EdgeInsets getButtonPadding(BuildContext context) {
    if (isMobile(context)) {
      return EdgeInsets.symmetric(
        horizontal: 20.w,
        vertical: 12.h,
      );
    } else if (isTablet(context)) {
      return EdgeInsets.symmetric(
        horizontal: 24.w,
        vertical: 16.h,
      );
    } else {
      return EdgeInsets.symmetric(
        horizontal: 32.w,
        vertical: 20.h,
      );
    }
  }

  static double getBorderRadius(BuildContext context) {
    if (isMobile(context)) {
      return AppConstants.defaultBorderRadius.r;
    } else if (isTablet(context)) {
      return (AppConstants.defaultBorderRadius * 1.2).r;
    } else {
      return (AppConstants.defaultBorderRadius * 1.4).r;
    }
  }

  static double getIconSize(BuildContext context, double baseSize) {
    if (isMobile(context)) {
      return baseSize.w;
    } else if (isTablet(context)) {
      return (baseSize * 1.2).w;
    } else {
      return (baseSize * 1.4).w;
    }
  }
}

class SizeHelper {
  // Common sizes
  static double get smallPadding => AppConstants.smallPadding.w;
  static double get defaultPadding => AppConstants.defaultPadding.w;
  static double get largePadding => AppConstants.largePadding.w;
  
  static double get smallRadius => (AppConstants.defaultBorderRadius * 0.5).r;
  static double get defaultRadius => AppConstants.defaultBorderRadius.r;
  static double get largeRadius => AppConstants.largeBorderRadius.r;
  
  // Text sizes
  static double get smallText => 12.sp;
  static double get bodyText => 14.sp;
  static double get titleText => 16.sp;
  static double get headingText => 20.sp;
  static double get largeHeading => 24.sp;
  static double get extraLargeHeading => 32.sp;
  
  // Icon sizes
  static double get smallIcon => 16.w;
  static double get defaultIcon => 24.w;
  static double get largeIcon => 32.w;
  static double get extraLargeIcon => 48.w;
  
  // Button dimensions
  static double get buttonHeight => AppConstants.buttonHeight.h;
  static double get smallButtonHeight => (AppConstants.buttonHeight * 0.8).h;
  static double get largeButtonHeight => (AppConstants.buttonHeight * 1.2).h;
  
  // Card dimensions
  static double get cardElevation => AppConstants.cardElevation;
  static double get smallCardElevation => AppConstants.cardElevation * 0.5;
  static double get largeCardElevation => AppConstants.cardElevation * 1.5;
}
