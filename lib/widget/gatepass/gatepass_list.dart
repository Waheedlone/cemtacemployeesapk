import 'package:cnattendance/provider/gatepassprovider.dart';
import 'package:cnattendance/screen/gatepassdetailscreen.dart';
import 'package:cnattendance/widget/gatepass/gatepass_list_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GatePassList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GatePassProvider>(context);
    final items = provider.gatePasses;

    if (provider.isLoading && items.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    if (items.isEmpty) {
      return ListView(
        physics: AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long_outlined, size: 64, color: Colors.grey[300]),
                  SizedBox(height: 16),
                  Text("No gate passes found", style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return ListView.builder(
      physics: AlwaysScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (ctx, index) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => GatePassDetailScreen(gatePass: items[index]),
            ));
          },
          child: GatePassListItem(gatePass: items[index]),
        );
      },
    );
  }
}
