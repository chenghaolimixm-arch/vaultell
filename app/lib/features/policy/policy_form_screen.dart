import 'package:flutter/material.dart';

import '../../core/db/app_database.dart';
import '../../core/models/insurance_type.dart';
import '../../core/utils/formatters.dart';

class PolicyFormScreen extends StatefulWidget {
  const PolicyFormScreen({super.key, required this.type, required this.database, this.policy});

  final InsuranceType type;
  final AppDatabase database;
  final Policy? policy;

  @override
  State<PolicyFormScreen> createState() => _PolicyFormScreenState();
}

class _PolicyFormScreenState extends State<PolicyFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _insurer;
  late final TextEditingController _policyNumber;
  late final TextEditingController _policyType;
  late final TextEditingController _premium;
  late final TextEditingController _excess;
  late final TextEditingController _sumInsured;
  late final TextEditingController _notes;
  late final TextEditingController _assetName;

  DateTime? _renewalDate;
  String _status = 'active';
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final p = widget.policy;
    _insurer = TextEditingController(text: p?.insurer ?? '');
    _policyNumber = TextEditingController(text: p?.policyNumber ?? '');
    _policyType = TextEditingController(text: p?.policyType ?? '');
    _premium = TextEditingController(text: p == null ? '' : (p.premiumCents / 100).toStringAsFixed(2));
    _excess = TextEditingController(text: p == null ? '' : (p.excessCents / 100).toStringAsFixed(2));
    _sumInsured = TextEditingController(text: p == null ? '' : (p.sumInsuredCents / 100).toStringAsFixed(2));
    _notes = TextEditingController(text: p?.notes ?? '');
    _assetName = TextEditingController();
    _renewalDate = p?.renewalDate;
    _status = p?.status ?? 'active';
  }

  @override
  void dispose() {
    _insurer.dispose();
    _policyNumber.dispose();
    _policyType.dispose();
    _premium.dispose();
    _excess.dispose();
    _sumInsured.dispose();
    _notes.dispose();
    _assetName.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _renewalDate ?? DateTime.now().add(const Duration(days: 90)),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 3)),
    );
    if (picked != null) setState(() => _renewalDate = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      if (widget.policy == null) {
        await widget.database.policyDao.insertPolicy(
          type: widget.type,
          insurer: _insurer.text.trim(),
          policyNumber: _policyNumber.text.trim(),
          policyType: _policyType.text.trim(),
          premiumCents: parseDollarsToCents(_premium.text),
          excessCents: parseDollarsToCents(_excess.text),
          sumInsuredCents: parseDollarsToCents(_sumInsured.text),
          renewalDate: _renewalDate,
          status: _status,
          notes: _notes.text.trim(),
          assetName: widget.type.subjectType == null ? null : _assetName.text,
        );
      } else {
        await widget.database.policyDao.updatePolicy(
          widget.policy!.id,
          insurer: _insurer.text.trim(),
          policyNumber: _policyNumber.text.trim(),
          policyType: _policyType.text.trim(),
          premiumCents: parseDollarsToCents(_premium.text),
          excessCents: parseDollarsToCents(_excess.text),
          sumInsuredCents: parseDollarsToCents(_sumInsured.text),
          renewalDate: _renewalDate,
          status: _status,
          notes: _notes.text.trim(),
        );
      }
      if (mounted) Navigator.of(context).pop();
    } on StateError catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isHealth = widget.type == InsuranceType.health;
    return Scaffold(
      appBar: AppBar(title: Text(widget.policy == null ? '添加${widget.type.label}' : '编辑保单')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (!isHealth)
              TextFormField(
                controller: _assetName,
                decoration: InputDecoration(
                  labelText: '关联${widget.type.subjectType == 'car' ? '车辆' : widget.type.subjectType == 'pet' ? '宠物' : '房产'}（如：2019 Mazda 3）',
                  hintText: '可选',
                ),
              ),
            TextFormField(
              controller: _insurer,
              decoration: const InputDecoration(labelText: '保险公司 *'),
              validator: (v) => (v == null || v.trim().isEmpty) ? '请填写保险公司' : null,
            ),
            TextFormField(
              controller: _policyNumber,
              decoration: const InputDecoration(labelText: '保单号'),
            ),
            TextFormField(
              controller: _policyType,
              decoration: const InputDecoration(labelText: '保障类型（如 Comprehensive）'),
            ),
            TextFormField(
              controller: _premium,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: '年保费（AUD）'),
            ),
            TextFormField(
              controller: _excess,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Excess（AUD）'),
            ),
            TextFormField(
              controller: _sumInsured,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: '保额（AUD）'),
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('续保日期'),
              subtitle: Text(formatDate(_renewalDate)),
              trailing: const Icon(Icons.calendar_month),
              onTap: _pickDate,
            ),
            DropdownButtonFormField<String>(
              initialValue: _status,
              decoration: const InputDecoration(labelText: '状态'),
              items: const [
                DropdownMenuItem(value: 'active', child: Text('有效')),
                DropdownMenuItem(value: 'cancelled', child: Text('已取消')),
                DropdownMenuItem(value: 'expired', child: Text('已过期')),
              ],
              onChanged: (v) => setState(() => _status = v ?? 'active'),
            ),
            TextFormField(
              controller: _notes,
              decoration: const InputDecoration(labelText: '备注'),
              maxLines: 2,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: Text(_saving ? '保存中…' : '保存'),
            ),
          ],
        ),
      ),
    );
  }
}
