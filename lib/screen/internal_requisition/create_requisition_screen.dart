import 'package:cnattendance/provider/internal_requisition_provider.dart';
import 'package:cnattendance/model/material_item.dart';
import 'package:cnattendance/model/warehouse.dart';
import 'package:cnattendance/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class CreateRequisitionScreen extends StatefulWidget {
  static const routeName = '/create-requisition';

  @override
  _CreateRequisitionScreenState createState() => _CreateRequisitionScreenState();
}

class _CreateRequisitionScreenState extends State<CreateRequisitionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _requisitionDateController = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
  final _remarksController = TextEditingController();
  final _specialReasonController = TextEditingController();

  String _classification = 'normal';
  Warehouse? _selectedWarehouse;
  List<Map<String, dynamic>> _items = [];

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<InternalRequisitionProvider>(context, listen: false);
      provider.fetchWarehouses();
      provider.fetchMaterials();
    });
  }

  void _addItem() {
    setState(() {
      _items.add({
        'material': null,
        'quantity': TextEditingController(),
        'description': TextEditingController(),
        'unit': 'pcs',
      });
    });
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedWarehouse == null) {
      showToast("Please select a warehouse");
      return;
    }
    if (_items.isEmpty) {
      showToast("Please add at least one item");
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final List<Map<String, dynamic>> itemsData = _items.map((item) {
        final material = item['material'] as MaterialItem?;
        return {
          'material_id': material?.id,
          'quantity': double.tryParse(item['quantity'].text) ?? 0,
          'unit': material?.unit ?? item['unit'] ?? 'pcs',
          'description': material?.name ?? item['description'].text,
        };
      }).toList();

      final data = {
        'requisition_date': _requisitionDateController.text,
        'warehouse_id': _selectedWarehouse!.id,
        'classification': _classification,
        'special_request_reason': _specialReasonController.text,
        'remarks': _remarksController.text,
        'items': itemsData,
      };

      await Provider.of<InternalRequisitionProvider>(context, listen: false)
          .storeRequisition(data);

      showToast("Requisition submitted successfully");
      Navigator.pop(context);
    } catch (e) {
      showToast(e.toString());
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<InternalRequisitionProvider>(context);

    return Scaffold(
      backgroundColor: Color(0xFFF5F6F9),
      appBar: AppBar(
        title: Text('New Requisition', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: _isSubmitting 
        ? Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Basic Information'),
                  _buildCard([
                    _buildDropdown<String>(
                      label: 'Classification',
                      value: _classification,
                      items: [
                        DropdownMenuItem(child: Text('Normal (From Stock)'), value: 'normal'),
                        DropdownMenuItem(child: Text('Special (New Item/Machinery)'), value: 'special'),
                      ],
                      onChanged: (val) => setState(() => _classification = val!),
                    ),
                    SizedBox(height: 16),
                    _buildDatePicker(),
                    SizedBox(height: 16),
                    _buildDropdown<Warehouse>(
                      label: 'Target Warehouse',
                      hint: provider.warehouses.isEmpty ? 'No Warehouses Found' : 'Select Warehouse',
                      value: _selectedWarehouse,
                      items: provider.warehouses.map((w) => DropdownMenuItem(child: Text(w.name), value: w)).toList(),
                      onChanged: (val) => setState(() => _selectedWarehouse = val),
                    ),
                  ]),
                  if (_classification == 'special') ...[
                    SizedBox(height: 20),
                    _buildSectionTitle('Special Request Reason'),
                    _buildTextField(
                      controller: _specialReasonController,
                      hint: 'Why is this special request needed?',
                      maxLines: 3,
                    ),
                  ],
                  SizedBox(height: 20),
                  _buildSectionTitle('Items'),
                  ..._items.asMap().entries.map((entry) => _buildItemCard(entry.key, entry.value)).toList(),
                  SizedBox(height: 12),
                  Center(
                    child: TextButton.icon(
                      onPressed: _addItem,
                      icon: Icon(Icons.add, color: Color(0xFFED1C24)),
                      label: Text('Add Item', style: TextStyle(color: Color(0xFFED1C24), fontWeight: FontWeight.bold)),
                      style: TextButton.styleFrom(
                        backgroundColor: Color(0xFFED1C24).withOpacity(0.1),
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildSectionTitle('Additional Remarks'),
                  _buildTextField(
                    controller: _remarksController,
                    hint: 'Optional notes for storekeeper...',
                    maxLines: 2,
                  ),
                  SizedBox(height: 32),
                  _buildSubmitButton(),
                  SizedBox(height: 40),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildItemCard(int index, Map<String, dynamic> item) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(backgroundColor: Colors.grey.withOpacity(0.1), child: Text('${index + 1}', style: TextStyle(color: Colors.black, fontSize: 12))),
              SizedBox(width: 12),
              Expanded(child: Text('Item Details', style: TextStyle(fontWeight: FontWeight.bold))),
              IconButton(onPressed: () => _removeItem(index), icon: Icon(Icons.delete_outline, color: Colors.red)),
            ],
          ),
          Divider(),
          _buildMaterialDropdown(index, item),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: _buildTextField(
                  label: 'Quantity',
                  controller: item['quantity'],
                  keyboardType: TextInputType.number,
                  validator: (val) => val == null || val.isEmpty ? 'Req' : null,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.withOpacity(0.2)),
                  ),
                  child: Text(item['material']?.unit ?? item['unit'] ?? 'pcs', style: TextStyle(color: Colors.black54)),
                ),
              ),
            ],
          ),
          if (item['material'] == null) ...[
            SizedBox(height: 16),
            _buildTextField(
              label: 'Description',
              controller: item['description'],
              hint: 'Enter item name/specifications',
              validator: (val) => _classification == 'special' && (val == null || val.isEmpty) ? 'Required' : null,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMaterialDropdown(int index, Map<String, dynamic> item) {
    final provider = Provider.of<InternalRequisitionProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Select Material', style: TextStyle(fontSize: 12, color: Colors.grey)),
        SizedBox(height: 4),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<MaterialItem>(
              isExpanded: true,
              value: item['material'],
              hint: Text('Search Material...'),
              items: [
                DropdownMenuItem(child: Text('-- Manual/Special --'), value: null),
                ...provider.materials.map((m) => DropdownMenuItem(child: Text('${m.name} (${m.code})'), value: m)).toList(),
              ],
              onChanged: (val) {
                setState(() {
                  item['material'] = val;
                  if (val != null) {
                    item['unit'] = val.unit;
                  }
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown<T>({required String label, String? hint, required T? value, required List<DropdownMenuItem<T>> items, required Function(T?) onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey)),
        SizedBox(height: 4),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              isExpanded: true,
              value: value,
              hint: hint != null ? Text(hint) : null,
              items: items,
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now().subtract(Duration(days: 30)),
          lastDate: DateTime.now().add(Duration(days: 30)),
        );
        if (date != null) {
          _requisitionDateController.text = DateFormat('yyyy-MM-dd').format(date);
        }
      },
      child: _buildTextField(
        label: 'Requisition Date',
        controller: _requisitionDateController,
        enabled: false,
        suffixIcon: Icon(Icons.calendar_today),
      ),
    );
  }

  Widget _buildTextField({String? label, required TextEditingController controller, String? hint, int maxLines = 1, TextInputType? keyboardType, String? Function(String?)? validator, Widget? suffixIcon, bool enabled = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey)),
          SizedBox(height: 4),
        ],
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          enabled: enabled,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.grey.withOpacity(0.05),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.withOpacity(0.2))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.withOpacity(0.2))),
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFED1C24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
        ),
        child: Text('Submit Requisition', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }
}
