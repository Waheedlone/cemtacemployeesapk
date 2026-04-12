import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class CardOverView extends StatelessWidget {
  final String type;
  final String value;
  final IconData icon;
 
  CardOverView({required this.type, required this.value, required this.icon});
 
  @override
  Widget build(BuildContext context) {
    Color primaryColor;
    List<Color> gradientColors;
 
    // Strict Project Color Theme (Red #ED1C24 and Deep Blue #00002B)
    if (type == 'Request' || type == 'Requisitions Request' || type == 'Shift Handover') {
      primaryColor = HexColor('#ED1C24'); // Brand Red
      gradientColors = [HexColor('#ED1C24').withOpacity(0.08), Colors.white];
    } else {
      primaryColor = HexColor('#00002B'); // Brand Deep Blue
      gradientColors = [HexColor('#00002B').withOpacity(0.08), Colors.white];
    }
 
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 600),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double opacity, child) {
        return Opacity(
          opacity: opacity,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - opacity)),
            child: child,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: gradientColors,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(
            color: primaryColor.withOpacity(0.15),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 26,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                value,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: HexColor('#00002B'),
                  fontSize: 24,
                  fontFamily: 'Outfit',
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                type,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: HexColor('#00002B').withOpacity(0.8),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  height: 1.1,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}