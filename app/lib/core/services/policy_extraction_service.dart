import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:intl/intl.dart';
import 'package:pdf_render_maintained/pdf_render_maintained.dart';

import '../models/insurer_catalog.dart';

/// Structured fields extracted from a policy document.
class ExtractedPolicyData {
  const ExtractedPolicyData({
    this.insurer,
    this.insurerKey,
    this.policyNumber,
    this.premiumCents,
    this.excessCents,
    this.sumInsuredCents,
    this.expiryDate,
    this.subjectName,
    required this.sourceFileName,
    this.warning,
  });

  final String? insurer;
  final String? insurerKey;
  final String? policyNumber;
  final int? premiumCents;
  final int? excessCents;
  final int? sumInsuredCents;
  final DateTime? expiryDate;
  final String? subjectName;
  final String sourceFileName;
  final String? warning;

  bool get hasAny =>
      insurer != null ||
      policyNumber != null ||
      premiumCents != null ||
      excessCents != null ||
      sumInsuredCents != null ||
      expiryDate != null ||
      subjectName != null;
}

/// Pure-Dart rules that turn OCR/extracted text into structured policy fields.
///
/// Kept separate from the OCR layer so it can be unit-tested without a device.
class PolicyDataExtractor {
  PolicyDataExtractor._();

  static const Map<String, List<String>> _insurerAliases = {
    'allianz': ['allianz'],
    'aami': ['aami'],
    'racq': ['racq'],
    'racv': ['racv'],
    'nrma': ['nrma'],
    'youi': ['youi'],
    'budget-direct': ['budget direct'],
    'gio': ['gio'],
    'qbe': ['qbe'],
    'suncorp': ['suncorp'],
    'commbank': ['commbank', 'commonwealth bank', 'cba'],
    'terri-scheer': ['terri scheer'],
    'medibank': ['medibank'],
    'bupa': ['bupa'],
    'hcf': ['hcf'],
    'nib': ['nib'],
    'rspca-pet': ['rspca'],
    'petbarn': ['petbarn'],
    'cgu': ['cgu'],
    'bingle': ['bingle'],
    'just-car': ['just car'],
    'apia': ['apia'],
    'real-insurance': ['real insurance'],
    'woolworths': ['woolworths'],
    'coles': ['coles insurance'],
    'australia-post': ['australia post'],
    'rac-wa': ['rac wa', 'rac western australia'],
    'wfi': ['wfi'],
    'bow-wow-meow': ['bow wow meow'],
    'petcover': ['petcover'],
  };

  static final RegExp _totalPremiumRe = RegExp(
    r'(?:total\s+(?:annual\s+)?(?:premium|cost)|you\s+pay|amount\s+due)[^$]{0,30}\$'
    r'\s?([\d,]+(?:\.\d{2})?)',
    caseSensitive: false,
  );

  static final RegExp _premiumAnyRe = RegExp(
    r'(?:premium|cost)[^$]{0,30}\$\s?([\d,]+(?:\.\d{2})?)',
    caseSensitive: false,
  );

  static final RegExp _excessRe = RegExp(
    r'(?:excess|excess\s+amount|basic\s+excess|policy\s+excess|your\s+excess|excess\s+applies)'
    r'[^$]{0,60}\$\s?([\d,]+(?:\.\d{2})?)',
    caseSensitive: false,
  );

  static final RegExp _sumInsuredRe = RegExp(
    r'(?:sum\s+insured|building\s+insured|contents\s+insured|total\s+sum\s+insured)[^$]{0,45}'
    r'\$\s?([\d,]+(?:\.\d{2})?)',
    caseSensitive: false,
  );

  static final RegExp _policyNumberRe = RegExp(
    r'(?:policy\s+(?:number|no\.?)\s*[:#]?\s*)([A-Z0-9][A-Z0-9\-]{4,24})',
    caseSensitive: false,
  );

  static final RegExp _expiryDateRe = RegExp(
    r'(?:renewal|renewal\s+date|expiry|expires|valid\s+until|policy\s+period)[^.\n]{0,40}?'
    r'(\d{1,2}\s+(?:jan|feb|mar|apr|may|jun|jul|aug|sep|oct|nov|dec)[a-z]*\.?\s*,?\s*\d{4}'
    r'|\d{1,2}\/\d{1,2}\/\d{2,4}'
    r'|(?:jan|feb|mar|apr|may|jun|jul|aug|sep|oct|nov|dec)[a-z]*\.?\s+\d{1,2},?\s+\d{4})',
    caseSensitive: false,
  );

  static final RegExp _policyPeriodRe = RegExp(
    r'(?:period\s+of\s+(?:insurance|cover)|policy\s+period|contract\s+period|cover\s+(?:period|from)|cover\s+period|valid\s+(?:from|until))'
    r'[\s\S]{0,140}?'
    r'(\d{1,2}\s+(?:jan|feb|mar|apr|may|jun|jul|aug|sep|oct|nov|dec)[a-z]*\.?\s*,?\s*\d{4}|\d{1,2}\/\d{1,2}\/\d{2,4}|\d{4}-\d{2}-\d{2}|\d{1,2}\s+(?:jan|feb|mar|apr|may|jun|jul|aug|sep|oct|nov|dec)[a-z]*\.?,?\s+\d{4})'
    r'[\s\S]{0,90}?\s*(?:to\s*\:?|until|–|—|-)\s*'
    r'(\d{1,2}\s+(?:jan|feb|mar|apr|may|jun|jul|aug|sep|oct|nov|dec)[a-z]*\.?\s*,?\s*\d{4}|\d{1,2}\/\d{1,2}\/\d{2,4}|\d{4}-\d{2}-\d{2}|\d{1,2}\s+(?:jan|feb|mar|apr|may|jun|jul|aug|sep|oct|nov|dec)[a-z]*\.?,?\s+\d{4})',
    caseSensitive: false,
  );

  static final RegExp _dateRangeRe = RegExp(
    r'(\d{1,2}\s+(?:jan|feb|mar|apr|may|jun|jul|aug|sep|oct|nov|dec)[a-z]*\.?\s*,?\s*\d{4}|\d{1,2}\/\d{1,2}\/\d{2,4}|\d{4}-\d{2}-\d{2}|\d{1,2}\s+(?:jan|feb|mar|apr|may|jun|jul|aug|sep|oct|nov|dec)[a-z]*\.?,?\s+\d{4})'
    r'[\s\S]{0,120}?\s*(?:to\s*\:?|until|–|—|-)\s*'
    r'(\d{1,2}\s+(?:jan|feb|mar|apr|may|jun|jul|aug|sep|oct|nov|dec)[a-z]*\.?\s*,?\s*\d{4}|\d{1,2}\/\d{1,2}\/\d{2,4}|\d{4}-\d{2}-\d{2}|\d{1,2}\s+(?:jan|feb|mar|apr|may|jun|jul|aug|sep|oct|nov|dec)[a-z]*\.?,?\s+\d{4})',
    caseSensitive: false,
  );

  static final RegExp _vehicleRe = RegExp(
    r'(?:\bvehicle\b|\bcar\b|make\s*\/?\s*model|registered\s+vehicle|vehicle\s+details)'
    r'[^.\n]{0,50}?(\b(?:19|20)\d{2}\s+[A-Za-z][A-Za-z0-9 .\-]{2,50})',
    caseSensitive: false,
  );

  static final RegExp _addressRe = RegExp(
    r'(?:property\s+address|insured\s+address|premises\s+address|the\s+property)[^.\n]{0,40}?'
    r'([0-9]+[A-Za-z]?\s+[A-Za-z][A-Za-z0-9 .,\-\#]{4,60})',
    caseSensitive: false,
  );

  static ExtractedPolicyData fromText(String text, {required String sourceFileName}) {
    final insurerKey = _findInsurerKey(text);
    final entry = InsurerCatalog.byKey(insurerKey);
    return ExtractedPolicyData(
      insurer: entry?.name,
      insurerKey: insurerKey,
      policyNumber: _firstMatch(_policyNumberRe, text),
      premiumCents: _premium(text),
      excessCents: _money(_excessRe, text),
      sumInsuredCents: _money(_sumInsuredRe, text),
      expiryDate: _expiryDate(text),
      subjectName: _subjectName(text),
      sourceFileName: sourceFileName,
    );
  }

  static DateTime? _expiryDate(String text) {
    // Prefer a policy period "from ... to ...": the second date is the expiry.
    final period = _policyPeriodRe.firstMatch(text);
    if (period != null && period.group(2) != null) {
      final to = _dateResult(period.group(2)!);
      if (to != null) return to;
    }
    // Some schedules print the date range before the label; detect "date – date".
    final range = _dateRangeRe.firstMatch(text);
    if (range != null && range.group(2) != null) {
      final to = _dateResult(range.group(2)!);
      if (to != null) return to;
    }
    return _date(_expiryDateRe, text);
  }

  static String? _subjectName(String text) {
    final addr = _firstMatch(_addressRe, text);
    if (addr != null) return addr.replaceAll(RegExp(r'[,\s]+$'), '').trim();
    return _firstMatch(_vehicleRe, text)?.trim();
  }

  static int? _premium(String text) {
    final total = _firstMatch(_totalPremiumRe, text);
    if (total != null) return _moneyValue(total);
    int? best;
    for (final m in _premiumAnyRe.allMatches(text)) {
      final v = _moneyValue(m.group(1)!);
      if (v != null && (best == null || v > best)) best = v;
    }
    return best;
  }

  static DateTime? _dateResult(String raw) => _dateValue(raw);

  static String? _findInsurerKey(String text) {
    final lower = text.toLowerCase();
    for (final entry in _insurerAliases.entries) {
      for (final alias in entry.value) {
        if (RegExp('\\b${RegExp.escape(alias)}\\b', caseSensitive: false).hasMatch(lower)) {
          return entry.key;
        }
      }
    }
    return null;
  }

  static String? _firstMatch(RegExp re, String text) {
    final match = re.firstMatch(text);
    return match?.group(1);
  }

  static int? _money(RegExp re, String text) {
    final raw = _firstMatch(re, text);
    if (raw == null) return null;
    return _moneyValue(raw);
  }

  static int? _moneyValue(String raw) {
    final cleaned = raw.replaceAll(',', '').trim();
    final value = double.tryParse(cleaned);
    return value == null ? null : (value * 100).round();
  }

  static DateTime? _date(RegExp re, String text) {
    final raw = _firstMatch(re, text);
    if (raw == null) return null;
    return _dateValue(raw);
  }

  static DateTime? _dateValue(String raw) {
    final normalized = raw.replaceAll(',', '').trim();
    for (final format in [
      'd MMMM yyyy',
      'd MMM yyyy',
      'MMMM d yyyy',
      'MMM d yyyy',
      'd/MM/yyyy',
      'dd/MM/yyyy',
      'd/MM/yy',
      'yyyy-MM-dd',
    ]) {
      try {
        return DateFormat(format).parse(normalized);
      } catch (_) {
        // try the next format
      }
    }
    return null;
  }
}

/// Extraction pipeline: PDFs are rendered to images and read with on-device
/// OCR (ML Kit). Photos are OCR'd directly.
///
/// Everything runs on the device — no network, no cost, no cloud upload.
/// Supports both text-based and scanned (image-only) PDFs.
class LocalPolicyExtractionService {
  Future<ExtractedPolicyData> extract({
    required String filePath,
    required String fileName,
  }) async {
    final extension = fileName.split('.').last.toLowerCase();
    try {
      if (extension == 'pdf') {
        return await _extractPdf(filePath, fileName);
      }
      final recognizer = TextRecognizer(script: TextRecognitionScript.latin);
      try {
        final result = await recognizer.processImage(InputImage.fromFilePath(filePath));
        return PolicyDataExtractor.fromText(result.text, sourceFileName: fileName);
      } finally {
        recognizer.close();
      }
    } catch (e) {
      return ExtractedPolicyData(
        sourceFileName: fileName,
        warning: 'Recognition failed ($e). Please enter the details manually or use a clearer photo/PDF.',
      );
    }
  }

  Future<ExtractedPolicyData> _extractPdf(String filePath, String fileName) async {
    final doc = await PdfDocument.openFile(filePath);
    final buffer = StringBuffer();
    final recognizer = TextRecognizer(script: TextRecognitionScript.latin);
    try {
      // Cap the number of pages we OCR to keep memory and latency bounded.
      final maxPages = doc.pageCount < 8 ? doc.pageCount : 8;
      for (var pageNumber = 1; pageNumber <= maxPages; pageNumber++) {
        final page = await doc.getPage(pageNumber);
        // Render at ~2x the 72dpi page size for readable OCR text.
        final image = await page.render(
          fullWidth: page.width * 2,
          fullHeight: page.height * 2,
        );
        try {
          final input = _toInputImage(image);
          final result = await recognizer.processImage(input);
          if (buffer.isNotEmpty) buffer.write('\n');
          buffer.write(result.text);
        } finally {
          image.dispose();
        }
      }
    } finally {
      recognizer.close();
      await doc.dispose();
    }

    final text = buffer.toString();
    if (text.trim().isEmpty) {
      return ExtractedPolicyData(
        sourceFileName: fileName,
        warning: 'Could not read any text from this PDF. Please enter the details manually or use a clearer document.',
      );
    }
    return PolicyDataExtractor.fromText(text, sourceFileName: fileName);
  }

  /// ML Kit needs BGRA; pdf_render gives RGBA, so swap the red and blue bytes.
  InputImage _toInputImage(PdfPageImage image) {
    final rgba = image.pixels;
    final bgra = Uint8List.fromList(rgba);
    for (var i = 0; i + 3 < bgra.length; i += 4) {
      final r = bgra[i];
      bgra[i] = bgra[i + 2];
      bgra[i + 2] = r;
    }
    return InputImage.fromBytes(
      bytes: bgra,
      metadata: InputImageMetadata(
        size: ui.Size(image.width.toDouble(), image.height.toDouble()),
        rotation: InputImageRotation.rotation0deg,
        bytesPerRow: image.width * 4,
        format: InputImageFormat.bgra8888,
      ),
    );
  }
}
