import 'package:cnattendance/provider/meetingprovider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class MeetingDetailScreen extends StatefulWidget {
  static const routeName = '/meetingdetailscreen';

  @override
  State<StatefulWidget> createState() => MeetingDetailState();
}

class MeetingDetailState extends State<MeetingDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as int;
    final item = Provider.of<MeetingProvider>(context)
        .meetingList
        .where((item) => item.id == args)
        .first;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Meeting Detail',
          style: TextStyle(color: HexColor("#011754")),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: HexColor("#011754"),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    item.image,
                    height: 200,
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width,
                  )),
              gaps(20),
              Text(
                item.title,
                style: TextStyle(
                    color: HexColor("#011754"),
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              gaps(10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 20,
                    color: HexColor("#ED1C24"),
                  ),
                  SizedBox(width: 10),
                  Text(
                    '${item.meetingDate} ${item.meetingStartTime}',
                    style: TextStyle(color: Colors.grey[700], fontSize: 15),
                  ),
                ],
              ),
              gaps(10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.location_on,
                    size: 20,
                    color: HexColor("#ED1C24"),
                  ),
                  SizedBox(width: 10),
                  Text(
                    item.venue,
                    style: TextStyle(color: Colors.grey[700], fontSize: 15),
                  )
                ],
              ),
              gaps(10),
              Divider(),
              gaps(10),
              Text(
                'Agenda',
                style: TextStyle(
                    color: HexColor("#011754"),
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              Html(
                style: {
                  "body": Style(
                      color: Colors.black87,
                      fontSize: FontSize.medium,
                      textAlign: TextAlign.justify)
                },
                data: item.agenda,
              ),
              gaps(10),
              Divider(),
              gaps(10),
              Text(
                'Participants',
                style: TextStyle(
                    color: HexColor("#011754"),
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              gaps(10),
              ListView.separated(
                  primary: false,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        item.participator[index].name,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        item.participator[index].post,
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.network(
                          item.participator[index].avatar,
                          height: 50,
                          width: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      height: 1,
                      color: Colors.grey[200],
                    );
                  },
                  itemCount: item.participator.length)
            ],
          ),
        ),
      ),
    );
  }

  Widget gaps(int value) {
    return SizedBox(
      height: value.toDouble(),
    );
  }
}
