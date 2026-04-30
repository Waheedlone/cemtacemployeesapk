import 'package:cnattendance/data/source/network/model/rules/CompanyRulesReponse.dart';
import 'package:cnattendance/repositories/companyrulerepository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class RulesScreen extends StatefulWidget {
  @override
  _RulesScreenState createState() => _RulesScreenState();
}

class _RulesScreenState extends State<RulesScreen> {
  Future<CompanyRulesReponse>? _rulesFuture;

  @override
  void initState() {
    super.initState();
    _rulesFuture = CompanyRuleRepository().getContent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Company Rules", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _rulesFuture = CompanyRuleRepository().getContent();
          });
        },
        child: FutureBuilder<CompanyRulesReponse>(
          future: _rulesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (snapshot.hasData && snapshot.data!.data.isNotEmpty) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
                child: Html(
                  data: snapshot.data!.data.first.description,
                ),
              );
            } else {
              return Center(child: Text("No rules found."));
            }
          },
        ),
      ),
    );
  }
}
