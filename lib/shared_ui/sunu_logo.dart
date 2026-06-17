import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app/theme.dart';

enum SunuLogoVersion { logo1, logo2 }

class SunuLogo extends StatelessWidget {
  final double size;
  final SunuLogoVersion version;

  const SunuLogo({
    super.key,
    this.size = 56,
    this.version = SunuLogoVersion.logo1,
  });

  String get _assetPath => switch (version) {
    SunuLogoVersion.logo1 => 'assets/brand/logo1.svg',
    SunuLogoVersion.logo2 => 'assets/brand/logo2.svg',
  };

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      _assetPath,
      width: size,
      height: size,
      fit: BoxFit.fill,
    );
  }
}

class SunuLogoWordmark extends StatelessWidget {
  final double logoSize;
  final Color color;
  final bool showTagline;
  final SunuLogoVersion version;

  const SunuLogoWordmark({
    super.key,
    this.logoSize = 44,
    this.color = sdGreenBaobab,
    this.showTagline = true,
    this.version = SunuLogoVersion.logo2,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SunuLogo(size: logoSize, version: version),
        if (showTagline) ...[
          const SizedBox(width: 12),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showTagline) ...[
                const SizedBox(height: 4),
                Text(
                  'La performance au service du territoire.',
                  style: GoogleFonts.inter(
                    color: sdGreenBaobab,
                    fontSize: logoSize * 0.22,
                    height: 1.1,
                  ),
                ),
              ],
            ],
          ),
        ],
      ],
    );
  }
}
