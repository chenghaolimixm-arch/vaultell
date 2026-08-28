import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../core/db/app_database.dart';
import '../../core/models/insurance_type.dart';
import '../../core/models/insurer_catalog.dart';
import '../../core/services/document_storage_service.dart';
import '../../core/services/policy_extraction_service.dart';
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

  late final TextEditingController _policyNumber;
  late final TextEditingController _policyType;
  late final TextEditingController _premium;
  late final TextEditingController _excess;
  late final TextEditingController _sumInsured;
  late final TextEditingController _notes;
  late final TextEditingController _assetName;
  late final TextEditingController _customInsurer;

  DateTime? _renewalDate;
  String _status = 'active';
  String? _insurerKey;
  bool _saving = false;
  bool _importing = false;
  String? _pendingDocPath;
  String? _pendingDocName;

  @override
  void initState() {
    super.initState();
    final p = widget.policy;
    _policyNumber = TextEditingController(text: p?.policyNumber ?? '');
    _policyType = TextEditingController(text: p?.policyType ?? '');
    _premium = TextEditingController(text: p == null ? '' : (p.premiumCents / 100).toStringAsFixed(2));
    _excess = TextEditingController(text: p == null ? '' : (p.excessCents / 100).toStringAsFixed(2));
    _sumInsured = TextEditingController(text: p == null ? '' : (p.sumInsuredCents / 100).toStringAsFixed(2));
    _notes = TextEditingController(text: p?.notes ?? '');
    _assetName = TextEditingController();
    _customInsurer = TextEditingController();
    _renewalDate = p?.renewalDate;
    _status = p?.status ?? 'active';
    if (p != null) {
      final entry = InsurerCatalog.byKey(p.insurerKey) ?? InsurerCatalog.byName(p.insurer);
      _insurerKey = entry?.key;
      if (entry == null && p.insurer.isNotEmpty) {
        _customInsurer.text = p.insurer;
      }
    }
  }

  @override
  void dispose() {
    _policyNumber.dispose();
    _policyType.dispose();
    _premium.dispose();
    _excess.dispose();
    _sumInsured.dispose();
    _notes.dispose();
    _assetName.dispose();
    _customInsurer.dispose();
    super.dispose();
  }

  String get _resolvedInsurerName {
    if (_insurerKey == InsurerCatalog.customOptionKey) {
      return _customInsurer.text.trim();
    }
    final entry = InsurerCatalog.byKey(_insurerKey);
    return entry?.name ?? _customInsurer.text.trim();
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

  Future<void> _importFromFile() async {
    final picked = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );
    if (picked == null || picked.path == null || !mounted) return;

    setState(() => _importing = true);
    try {
      final savedPath = await DocumentStorageService().savePickedFile(
        sourcePath: picked.path!,
        fileName: picked.name,
      );
      final data = await LocalPolicyExtractionService().extract(
        filePath: savedPath,
        fileName: picked.name,
      );
      if (!mounted) return;

      setState(() {
        _pendingDocPath = savedPath;
        _pendingDocName = picked.name;
        if (data.insurerKey != null) {
          _insurerKey = InsurerCatalog.byKey(data.insurerKey) != null ? data.insurerKey : null;
        } else if (data.insurer != null) {
          _insurerKey = InsurerCatalog.customOptionKey;
          _customInsurer.text = data.insurer!;
        }
        if (data.policyNumber != null) _policyNumber.text = data.policyNumber!;
        if (data.premiumCents != null) {
          _premium.text = (data.premiumCents! / 100).toStringAsFixed(2);
        }
        if (data.excessCents != null) {
          _excess.text = (data.excessCents! / 100).toStringAsFixed(2);
        }
        if (data.sumInsuredCents != null) {
          _sumInsured.text = (data.sumInsuredCents! / 100).toStringAsFixed(2);
        }
        if (data.renewalDate != null) _renewalDate = data.renewalDate;
      });

      final fields = [
        if (data.insurer != null) '保险公司',
        if (data.policyNumber != null) '保单号',
        if (data.premiumCents != null) '年保费',
        if (data.excessCents != null) 'Excess',
        if (data.sumInsuredCents != null) '保额',
        if (data.renewalDate != null) '续保日期',
      ];
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('识别结果'),
          content: Text(
            fields.isEmpty
                ? '没有识别到可用字段，请手动填写。'
                : '已自动填入：${fields.join('、')}。\n请核对后保存。'
                    '${data.warning != null ? '\n\n${data.warning}' : ''}',
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('好的')),
          ],
        ),
      );
    } finally {
      if (mounted) setState(() => _importing = false);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      if (widget.policy == null) {
        final created = await widget.database.policyDao.insertPolicy(
          type: widget.type,
          insurer: _resolvedInsurerName,
          insurerKey:
              _insurerKey == InsurerCatalog.customOptionKey ? null : _insurerKey,
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
        await _savePendingDocument(created.id);
      } else {
        await widget.database.policyDao.updatePolicy(
          widget.policy!.id,
          insurer: _resolvedInsurerName,
          insurerKey:
              _insurerKey == InsurerCatalog.customOptionKey ? null : _insurerKey,
          policyNumber: _policyNumber.text.trim(),
          policyType: _policyType.text.trim(),
          premiumCents: parseDollarsToCents(_premium.text),
          excessCents: parseDollarsToCents(_excess.text),
          sumInsuredCents: parseDollarsToCents(_sumInsured.text),
          renewalDate: _renewalDate,
          status: _status,
          notes: _notes.text.trim(),
        );
        await _savePendingDocument(widget.policy!.id);
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

  Future<void> _savePendingDocument(int policyId) async {
    final path = _pendingDocPath;
    final name = _pendingDocName;
    if (path == null || name == null) return;
    await widget.database.policyDao.addDocument(
      policyId: policyId,
      kind: 'renewal',
      fileName: name,
      localPath: path,
    );
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
            OutlinedButton.icon(
              onPressed: _importing ? null : _importFromFile,
              icon: _importing
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.upload_file),
              label: Text(_importing ? '识别中…' : '从保单文件自动填写（本机识别）'),
            ),
            const SizedBox(height: 16),
            if (!isHealth)
              TextFormField(
                controller: _assetName,
                decoration: InputDecoration(
                  labelText: '关联${widget.type.subjectType == 'car' ? '车辆' : widget.type.subjectType == 'pet' ? '宠物' : '房产'}（如：2019 Mazda 3）',
                  hintText: '可选',
                ),
              ),
            DropdownButtonFormField<String>(
              initialValue: _insurerKey,
              decoration: const InputDecoration(labelText: '选择保险公司 *'),
              hint: const Text('从列表选择，或选「其他」'),
              items: [
                for (final entry in InsurerCatalog.all)
                  DropdownMenuItem(value: entry.key, child: Text(entry.name)),
                const DropdownMenuItem(
                  value: InsurerCatalog.customOptionKey,
                  child: Text('其他 / 自定义…'),
                ),
              ],
              onChanged: (v) => setState(() => _insurerKey = v),
              validator: (v) {
                if (v == null) return '请选择保险公司';
                if (v == InsurerCatalog.customOptionKey && _customInsurer.text.trim().isEmpty) {
                  return '请输入保险公司名称';
                }
                return null;
              },
            ),
            if (_insurerKey == InsurerCatalog.customOptionKey)
              TextFormField(
                controller: _customInsurer,
                decoration: const InputDecoration(labelText: '自定义保险公司名称 *'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? '请填写保险公司名称' : null,
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
