import 'package:cnattendance/data/source/network/model/meeting/Participator.dart';
import 'package:flutter/material.dart';

class MeetingParticipator extends StatelessWidget {
  final Participator participator;

  MeetingParticipator(this.participator);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: participator.avatar.isNotEmpty
                  ? Image.network(
                      participator.avatar,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/dummy_avatar.png',
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        );
                      },
                    )
                  : Image.asset(
                      'assets/images/dummy_avatar.png',
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  participator.name,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                Text(
                  participator.post,
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
