import 'package:flutter/widgets.dart';

/// Breakpoints SunuDekk. Inspires Material 3 + tablette administrative.
class SdBreakpoints {
  SdBreakpoints._();
  static const double tablet = 600;
  static const double desktop = 1024;
}

extension SdResponsive on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;
  bool get isTablet => screenWidth >= SdBreakpoints.tablet;
  bool get isDesktop => screenWidth >= SdBreakpoints.desktop;

  /// Helper : choisit la valeur la plus adaptee a la taille courante.
  T responsive<T>({required T phone, T? tablet, T? desktop}) {
    if (isDesktop && desktop != null) return desktop;
    if (isTablet && tablet != null) return tablet;
    return phone;
  }
}
