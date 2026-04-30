import 'package:cnattendance/provider/aboutprovider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';

class AboutScreen extends StatelessWidget {
  static const routeName = '/about';

  final String title;

  AboutScreen(this.title, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => AboutProvider(), child: About(title));
  }
}

class About extends StatefulWidget {
  final String title;

  About(this.title, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => AboutScreenState();
}

class AboutScreenState extends State<About> {
  @override
  Widget build(BuildContext context) {
    bool isAboutUs = widget.title == 'about-us';
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          isAboutUs ? 'About Us' : 'Cemtac Application User Guide',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(Duration(seconds: 1));
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isAboutUs) ...[
                  _buildHeroSection(),
                  _buildAboutContent(),
                ] else ...[
                  _buildGuideHero(),
                  _buildGuideContent(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.red.shade900, Colors.red.shade600],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cementing Dreams,',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          Text(
            'Strengthening Reality',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 22,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 20),
          Container(
            height: 4,
            width: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutContent() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
      children: [
  _buildParagraph(
    'Established in 2008 by Mr. Riaz Ahmad Panjra, Cemtac Cements began operations as a 200 TPD cement plant with a clear focus on quality, operational excellence, and innovation. In 2016, the company expanded its production capacity by an additional 300 TPD, reinforcing its commitment to growth and technology-led manufacturing.',
    isFirst: true,
  ),
  _buildParagraph(
    'Today, Cemtac Cements is recognized as a reliable and progressive player in the cement industry of Jammu & Kashmir. The company remains committed to delivering high-quality products, maintaining strong customer trust, and operating with a focus on sustainability, responsible practices, and long-term value creation for the region.',
  ),
  SizedBox(height: 40),
  Center(
    child: Opacity(
      opacity: 0.5,
      child: Text(
        '© 2026 Cemtac Cements. All rights reserved.',
        style: TextStyle(fontSize: 12, color: Colors.grey),
      ),
    ),
  ),
],
      ),
    );
  }

  Widget _buildGuideHero() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_stories, color: Colors.red, size: 30),
              SizedBox(width: 10),
              Text(
                'Project Interaction Manual',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            'An exhaustive guide for every button, flow, and function within the Digital HR application.',
            style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildGuideContent() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          _buildGuideSection(
            '1. Authentication & Security',
            Icons.security,
            [
              'Login Flow: Enter your unique username and password. Use the eye icon to toggle password visibility. Successful login securely stores your session.',
              'Face Registration: New users must complete a face capture. This biometric data is used for secure attendance verification and cannot be bypassed.',
            ],
          ),
          _buildGuideSection(
            '2. Dashboard & Navigation',
            Icons.dashboard_customize,
            [
              'Dynamic Header: View your personalized greeting and notification count. Tap the bell icon for the latest updates.',
              'Face Center: Perform real-time face verification before marking attendance. The central red icon initiates the capture window.',
              'Service Grid: Direct access to Attendance Logs, Holidays, Leave Calendar, Gate Pass, and Shift Handover.',
            ],
          ),
          _buildGuideSection(
            '3. Attendance & Tracking',
            Icons.history,
            [
              'Check-In/Out: Only active after successful face verification. Records your exact timestamp and location.',
              'Monthly Report: View a visual calendar with status dots. Deep-dive into daily production hours and absent/present streaks.',
            ],
          ),
          _buildGuideSection(
            '4. Leave & Time-Off',
            Icons.event_note,
            [
              'Application: Select leave type, define start/end dates, and provide a detailed reason. Managers receive instant notifications.',
              'Status Tracking: Monitor if your request is Pending, Approved, or Rejected. You can cancel pending requests at any time.',
            ],
          ),
          _buildGuideSection(
            '5. Collaboration & Tasks',
            Icons.assignment,
            [
              'Project Dashboard: Tracks your assigned projects with dynamic progress rings based on task completion.',
              'Task Details: Interactive checklists allow you to mark sub-steps. Attachments (PDFs/Images) can be viewed directly in-app.',
              'Team Discussion: Post comments or reply to colleagues within specific tasks to keep communication centralized.',
            ],
          ),
          _buildGuideSection(
            '6. Advanced Services',
            Icons.layers,
            [
              'Gate Pass: Apply for official short-term exit permissions with time-stamped logs.',
              'Overtime: Request additional working hours for approval. Track OT history and status updates.',
              'Shift Handover: Smoothly transition responsibilities to the next colleague by accepting or initiating handovers.',
              'TADA: Submit travel and daily allowance claims with attachment uploads (Coming Soon).',
            ],
          ),
          _buildGuideSection(
            '7. Profile & Support',
            Icons.person_search,
            [
              'Profile Management: View and edit your official and bank details. Update your profile picture anytime.',
              'Support Desk: Connect with HR or IT. Open new tickets for queries and track processing status until resolution.',
            ],
          ),
          SizedBox(height: 30),
          Center(
            child: Text(
              'Version 3.1 - Master Guide Provided by Cemtac Cements',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildGuideSection(String title, IconData icon, List<String> details) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.02),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.red, size: 20),
              SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 12),
          ...details.map((text) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("• ", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                    Expanded(
                      child: Text(
                        text,
                        style: TextStyle(color: Colors.black87, fontSize: 13, height: 1.4),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildParagraph(String text, {bool isFirst = false}) {
    return Padding(
      padding: EdgeInsets.only(top: isFirst ? 0 : 20),
      child: Text(
        text,
        textAlign: TextAlign.justify,
        style: TextStyle(
          fontSize: 15,
          color: Colors.black87,
          height: 1.6,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}
