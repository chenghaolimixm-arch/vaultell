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

  DateTime? _expiryDate;
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
    _expiryDate = p?.endDate;
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
      initialDate: _expiryDate ?? DateTime.now().add(const Duration(days: 90)),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 3)),
    );
    if (picked != null) setState(() => _expiryDate = picked);
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
        if (data.expiryDate != null) _expiryDate = data.expiryDate;
      });

      final fields = [
        if (data.insurer != null) 'insurer',
        if (data.policyNumber != null) 'policy number',
        if (data.premiumCents != null) 'annual premium',
        if (data.excessCents != null) 'excess',
        if (data.sumInsuredCents != null) 'sum insured',
        if (data.expiryDate != null) 'expiry date',
      ];
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Recognition result'),
          content: Text(
            fields.isEmpty
                ? 'No fields were recognised. Please fill them in manually.'
                : 'Auto-filled: ${fields.join(', ')}.\nPlease review before saving.'
                    '${data.warning != null ? '\n\n${data.warning}' : ''}',
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
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
          endDate: _expiryDate,
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
          endDate: _expiryDate,
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
      appBar: AppBar(title: Text(widget.policy == null ? 'Add ${widget.type.label}' : 'Edit policy')),
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
              label: Text(_importing ? 'Recognising…' : 'Import from policy file (on-device)'),
            ),
            const SizedBox(height: 16),
            if (!isHealth)
              TextFormField(
                controller: _assetName,
                decoration: InputDecoration(
                  labelText: 'Linked ${widget.type.subjectType == 'car' ? 'vehicle' : widget.type.subjectType == 'pet' ? 'pet' : 'property'} (e.g. 2019 Mazda 3)',
                  hintText: 'Optional',
                ),
              ),
            DropdownButtonFormField<String>(
              initialValue: _insurerKey,
              decoration: const InputDecoration(labelText: 'Select insurer *'),
              hint: const Text('Pick from the list, or choose Other'),
              items: [
                for (final entry in InsurerCatalog.all)
                  DropdownMenuItem(value: entry.key, child: Text(entry.name)),
                const DropdownMenuItem(
                  value: InsurerCatalog.customOptionKey,
                  child: Text('Other / Custom…'),
                ),
              ],
              onChanged: (v) => setState(() => _insurerKey = v),
              validator: (v) {
                if (v == null) return 'Please select an insurer';
                if (v == InsurerCatalog.customOptionKey && _customInsurer.text.trim().isEmpty) {
                  return 'Please enter the insurer name';
                }
                return null;
              },
            ),
            if (_insurerKey == InsurerCatalog.customOptionKey)
              TextFormField(
                controller: _customInsurer,
                decoration: const InputDecoration(labelText: 'Custom insurer name *'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Please enter the insurer name' : null,
              ),
            TextFormField(
              controller: _policyNumber,
              decoration: const InputDecoration(labelText: 'Policy number'),
            ),
            TextFormField(
              controller: _policyType,
              decoration: const InputDecoration(labelText: 'Cover type (e.g. Comprehensive)'),
            ),
            TextFormField(
              controller: _premium,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Annual premium (AUD)'),
            ),
            TextFormField(
              controller: _excess,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Excess（AUD）'),
            ),
            TextFormField(
              controller: _sumInsured,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Sum insured (AUD)'),
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Policy Expiry Date'),
              subtitle: Text(formatDate(_expiryDate)),
              trailing: const Icon(Icons.calendar_month),
              onTap: _pickDate,
            ),
            DropdownButtonFormField<String>(
              initialValue: _status,
              decoration: const InputDecoration(labelText: 'Status'),
              items: const [
                DropdownMenuItem(value: 'active', child: Text('Active')),
                DropdownMenuItem(value: 'cancelled', child: Text('Cancelled')),
                DropdownMenuItem(value: 'expired', child: Text('Expired')),
              ],
              onChanged: (v) => setState(() => _status = v ?? 'active'),
            ),
            TextFormField(
              controller: _notes,
              decoration: const InputDecoration(labelText: 'Notes'),
              maxLines: 2,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: Text(_saving ? 'Saving…' : 'Save'),
            ),
          ],
        ),
      ),
    );
  }
}
