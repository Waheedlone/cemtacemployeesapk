import 'package:cnattendance/provider/gatepassprovider.dart';
import 'package:cnattendance/widget/gatepass/gate_pass_request_sheet.dart';
import 'package:cnattendance/widget/gatepass/gatepass_list.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class GatePassScreen extends StatefulWidget {
  static const routeName = '/gate-passes';

  @override
  _GatePassScreenState createState() => _GatePassScreenState();
}

class _GatePassScreenState extends State<GatePassScreen> {
  bool _initial = true;

  @override
  void didChangeDependencies() {
    if (_initial) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<GatePassProvider>(context, listen: false).fetchGatePasses();
      });
      _initial = false;
    }
    super.didChangeDependencies();
  }

  void _showRequestSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const GatePassRequestSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Gate Passes', style: TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showRequestSheet(context),
        backgroundColor: HexColor('#ED1C24'),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Request', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            Provider.of<GatePassProvider>(context, listen: false).fetchGatePasses(),
        child: GatePassList(),
      ),
    );
  }
}

