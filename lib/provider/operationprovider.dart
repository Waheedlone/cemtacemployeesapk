import 'package:cnattendance/repositories/operationrepository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class OperationUnit {
  final int id;
  final String title;

  OperationUnit(this.id, this.title);
}

class OperationProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<OperationUnit> _operations = [];
  List<OperationUnit> get operations => _operations;

  List<dynamic> _dailyEntries = [];
  List<dynamic> get dailyEntries => _dailyEntries;

  OperationRepository repository = OperationRepository();

  Future<void> fetchOperations() async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await repository.getAssignedUnits();
      _operations = data.map((item) => OperationUnit(item['id'], item['title'])).toList();
    } catch (e) {
      debugPrint("Error fetching operations: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchDailyEntries({required int month, required int year}) async {
    _isLoading = true;
    notifyListeners();

    try {
      _dailyEntries = await repository.getDailyEntries(month, year);
    } catch (e) {
      debugPrint("Error fetching daily entries: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addDailyEntry(int operationId, String date, double reading, String remarks) async {
    _isLoading = true;
    notifyListeners();
    EasyLoading.show(status: "Submitting...", maskType: EasyLoadingMaskType.black);

    try {
      await repository.postDailyEntry(operationId, date, reading, remarks);
      EasyLoading.showSuccess("Entry logged successfully");
      return true;
    } catch (e) {
      EasyLoading.showError(e.toString());
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
      EasyLoading.dismiss();
    }
  }
}
