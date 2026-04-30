import 'package:cnattendance/provider/profileprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BankDetailsScreen extends StatelessWidget {
  static const routeName = '/bank-details';

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<ProfileProvider>(context).profile;
    final bankName = profile.bankName.isNotEmpty ? profile.bankName : "Not Set";
    final accountNumber = profile.bankNumber.isNotEmpty ? profile.bankNumber : "XXXX XXXX XXXX";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Bank Details", style: TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Provider.of<ProfileProvider>(context, listen: false).getProfile();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle("Bank Account"),
              const SizedBox(height: 20),
              _buildBankCard(bankName, accountNumber),
              const SizedBox(height: 30),
              _buildSectionTitle("Bank Information"),
              const SizedBox(height: 20),
              _buildInfoCard([
                _buildDetailRow(Icons.account_balance_outlined, "Bank Name", bankName),
                _buildDetailRow(Icons.numbers_outlined, "Account Number", accountNumber),
              ]),
            ],
          ),
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

  Widget _buildBankCard(String bankName, String accountNumber) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFED1C24), Color(0xFFB71C1C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFED1C24).withOpacity(0.3),
            offset: const Offset(0, 6),
            blurRadius: 18,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Icon(Icons.account_balance, color: Colors.white, size: 30),
              Text(
                "PRIMARY",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Text(
            accountNumber,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            "ACCOUNT NUMBER",
            style: TextStyle(
              color: Colors.white60,
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            bankName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
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
                  child: Divider(color: Colors.red.withOpacity(0.1), thickness: 1),
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
                style: const TextStyle(color: Colors.black54, fontSize: 12),
              ),
              const SizedBox(height: 2),
              Text(
                value,
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
