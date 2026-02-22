import 'package:cnattendance/provider/profileprovider.dart';
import 'package:cnattendance/widget/radialDecoration.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OfficialDetailsScreen extends StatelessWidget {
  static const routeName = '/official-details';

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final userProfile = profileProvider.profile;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Official Details", style: TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Employment Information"),
            const SizedBox(height: 20),
            _buildInfoCard([
              _buildDetailRow(Icons.work_outline, "Designation", userProfile.post),
              _buildDetailRow(Icons.business_outlined, "Department", "IT Department"), // Placeholder if not in profile model
              _buildDetailRow(Icons.location_on_outlined, "Branch", "Main Office"), // Placeholder
              _buildDetailRow(Icons.badge_outlined, "Employee ID", "#${userProfile.id}"),
              _buildDetailRow(Icons.calendar_month_outlined, "Joined Date", userProfile.joinedDate),
            ]),
            const SizedBox(height: 30),
            _buildSectionTitle("Schedule & Role"),
            const SizedBox(height: 20),
            _buildInfoCard([
              _buildDetailRow(Icons.timer_outlined, "Office Time", "09:00 AM - 06:00 PM"), // Placeholder
              _buildDetailRow(Icons.assignment_ind_outlined, "Employment Type", "Full Time"), // Placeholder
              _buildDetailRow(Icons.security_outlined, "Role", "Employee"),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: children.asMap().entries.map((entry) {
          int idx = entry.key;
          Widget child = entry.value;
          return Column(
            children: [
              child,
              if (idx < children.length - 1)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Divider(color: Colors.red.withOpacity(0.05), thickness: 1),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.redAccent, size: 22),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value != '' ? value : "N/A",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
