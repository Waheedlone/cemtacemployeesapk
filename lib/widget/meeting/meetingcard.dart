import 'package:cnattendance/data/source/network/model/meeting/Participator.dart';
import 'package:cnattendance/screen/profile/meetingdetailscreen.dart';
import 'package:cnattendance/widget/meeting/meetingparticipator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MeetingCard extends StatelessWidget {
  final int id;
  final String title;
  final String venue;
  final String date;
  final List<Participator> participator;
  final String image;

  MeetingCard(
      this.id, this.title, this.venue, this.date, this.participator, this.image);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, MeetingDetailScreen.routeName,
            arguments: id);
      },
      child: Card(
        color: Colors.white12,
        elevation: 0,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 10.0, bottom: 10.0, left: 10.0, right: 100.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Venue : $venue',
                      style:
                          const TextStyle(color: Colors.white54, fontSize: 15),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      date,
                      style:
                          const TextStyle(color: Colors.white54, fontSize: 15),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (image.isNotEmpty)
                      Image.network(
                        image,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Text('Meeting File Not available',
                              style: TextStyle(color: Colors.white54));
                        },
                      )
                    else
                      const Text('Meeting File Not available',
                          style: TextStyle(color: Colors.white54)),
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      children: participator
                          .map((item) => MeetingParticipator(item))
                          .toList(),
                    )
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SvgPicture.asset(
                  'assets/icons/meeting.svg',
                  width: 80,
                  height: 80,
                  color: Colors.white10,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
