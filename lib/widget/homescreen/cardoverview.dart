import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class CardOverView extends StatelessWidget {
  final String type;
  final String value;
  final IconData icon;
 
  CardOverView({required this.type, required this.value, required this.icon});
 
  @override
  Widget build(BuildContext context) {
    // Using the Brand Red design cleanly across all dashboard cards as requested
    Color primaryColor = HexColor('#ED1C24');
 
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: Colors.grey.withOpacity(0.15),
            width: 1,
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Increased icon size and optimized padding to make the icon pop more and match the circle better
            final double iconSize = (constraints.maxWidth * 0.24).clamp(32.0, 48.0);
            final double circlePadding = (constraints.maxWidth * 0.05).clamp(10.0, 16.0);
            
            final double valueSize = (constraints.maxWidth * 0.2).clamp(18.0, 28.0);
            final double typeSize = (constraints.maxWidth * 0.1).clamp(11.0, 14.0);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(circlePadding),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      size: iconSize,
                      color: primaryColor,
                    ),
                  ),
                  SizedBox(height: constraints.maxHeight * 0.05),
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        value,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: HexColor('#00002B'),
                          fontSize: valueSize,
                          fontFamily: 'GoogleSans',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Expanded(
                    child: Center(
                      child: Text(
                        type,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: typeSize,
                          fontWeight: FontWeight.w600,
                          height: 1.1,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}