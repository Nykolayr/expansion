import 'package:flutter/material.dart';

import 'package:expansion/core/constants/asset_paths.dart';
import 'package:expansion/core/themes/expansion_colors.dart';

/// Позиции кнопок главного меню на splash (legacy `Direct`).
enum SplashMenuDirect {
  leftTop,
  leftBottom,
  middleTop,
  middleBottom,
  rightTop,
  rightBottom,
}

extension SplashMenuDirectX on SplashMenuDirect {
  Color get labelColor {
    switch (this) {
      case SplashMenuDirect.leftBottom:
      case SplashMenuDirect.rightBottom:
      case SplashMenuDirect.middleTop:
        return ExpansionColors.black;
      default:
        return ExpansionColors.accent;
    }
  }

  String get svgAsset {
    switch (this) {
      case SplashMenuDirect.leftBottom:
        return 'bottom_in.svg';
      case SplashMenuDirect.rightBottom:
        return 'bottom_right_in.svg';
      case SplashMenuDirect.leftTop:
        return 'top_in.svg';
      case SplashMenuDirect.rightTop:
        return 'top_right_in.svg';
      case SplashMenuDirect.middleBottom:
        return 'bottom_middle_in.svg';
      case SplashMenuDirect.middleTop:
        return 'top_middle_in.svg';
    }
  }

  String svgPath() => AssetPaths.svg(svgAsset);

  double get labelPaddingLeft {
    switch (this) {
      case SplashMenuDirect.leftBottom:
      case SplashMenuDirect.leftTop:
        return 2;
      case SplashMenuDirect.rightTop:
      case SplashMenuDirect.rightBottom:
        return 4;
      default:
        return 0;
    }
  }

  bool get isLabelLeft {
    switch (this) {
      case SplashMenuDirect.leftBottom:
      case SplashMenuDirect.leftTop:
        return true;
      default:
        return false;
    }
  }
}
