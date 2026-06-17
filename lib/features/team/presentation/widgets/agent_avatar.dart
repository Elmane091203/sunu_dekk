import 'package:flutter/material.dart';

import '../../../../app/theme.dart';
import '../../domain/agent.dart';

class AgentAvatar extends StatelessWidget {
  final Agent agent;
  final double size;
  final Color background;
  final Color foreground;
  const AgentAvatar({
    super.key,
    required this.agent,
    this.size = 44,
    this.background = const Color(0xFFD5EDE2),
    this.foreground = sdGreenBaobab,
  });

  @override
  Widget build(BuildContext context) {
    final isAdmin = agent.role == 'admin';
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: background,
            shape: BoxShape.circle,
          ),
          child: Text(
            agent.initials,
            style: TextStyle(
              color: foreground,
              fontWeight: FontWeight.w700,
              fontSize: size * 0.4,
            ),
          ),
        ),
        if (!agent.actif)
          Positioned(
            right: -2,
            bottom: -2,
            child: Container(
              width: size * 0.32,
              height: size * 0.32,
              decoration: BoxDecoration(
                color: sdRed,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
              child: const Icon(Icons.block, color: Colors.white, size: 9),
            ),
          )
        else if (isAdmin)
          Positioned(
            right: -2,
            bottom: -2,
            child: Container(
              width: size * 0.36,
              height: size * 0.36,
              decoration: BoxDecoration(
                color: sdGoldTeranga,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
              child:
                  const Icon(Icons.star, color: Colors.white, size: 11),
            ),
          ),
      ],
    );
  }
}
