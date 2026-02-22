import 'package:cnattendance/provider/payslipprovider.dart';
import 'package:cnattendance/widget/radialDecoration.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaySlipDetailScreen extends StatelessWidget {
  static const String routeName = "/paySlipDetail";

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PaySlipProvider>(context);
    return Container(
      decoration: RadialDecoration(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text('PaySlip #PAY54654'),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    "assets/icons/icon_app.png",
                    width: 150,
                    height: 150,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cyclone Nepal Infotech',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Sankhamul, Kathmandu, Nepal',
                          style: TextStyle(color: Colors.white54, fontSize: 15),
                        ),
                        Text(
                          'Cyclone Nepal Infotech',
                          style: TextStyle(color: Colors.white54, fontSize: 15),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Salary Month',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'September 2022',
                          style: TextStyle(color: Colors.white54, fontSize: 15),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Brishav Shakya',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Android Developer',
                      style: TextStyle(color: Colors.white54, fontSize: 15),
                    ),
                    Text(
                      'Emp Id : FT-0001',
                      style: TextStyle(color: Colors.white54, fontSize: 15),
                    ),
                    Text(
                      'Joining Date : July 22 2019',
                      style: TextStyle(color: Colors.white54, fontSize: 15),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  'Earnings',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                ListView.builder(
                  primary: false,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: provider.earningList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      tileColor: Colors.black26,
                      visualDensity: VisualDensity.compact,
                      dense: true,
                      title: Text(
                        provider.earningList[index].title,
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      trailing: Text('Rs. ${provider.earningList[index].value}',
                          style: TextStyle(color: Colors.white, fontSize: 15)),
                    );
                  },
                ),
                ListTile(
                  tileColor: Colors.black26,
                  visualDensity: VisualDensity.compact,
                  dense: true,
                  title: Text(
                    "Total Earning",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                  trailing: Text("Rs. ${provider.getTotalEarning()}",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold)),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  'Deductions',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                ListView.builder(
                  primary: false,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: provider.deductionList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      tileColor: Colors.black26,
                      visualDensity: VisualDensity.compact,
                      dense: true,
                      title: Text(
                        provider.deductionList[index].title,
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      trailing: Text(
                          'Rs. ${provider.deductionList[index].value}',
                          style: TextStyle(color: Colors.white, fontSize: 15)),
                    );
                  },
                ),
                ListTile(
                  tileColor: Colors.black26,
                  visualDensity: VisualDensity.compact,
                  dense: true,
                  title: Text(
                    "Total Deduction",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                  trailing: Text("Rs. ${provider.getTotalDeduction()}",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold)),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.black38,
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Net Salary',
                        style: TextStyle(color: Colors.white30, fontSize: 15),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      RichText(
                        text: TextSpan(
                            style: TextStyle(color: Colors.white, fontSize: 15),
                            text:
                                'Rs. ${provider.getTotalEarning() - provider.getTotalDeduction()}',
                            children: [
                              TextSpan(
                                text:
                                    ' (Sixty three thousand five hundred and four paisa only)',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              )
                            ]),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
