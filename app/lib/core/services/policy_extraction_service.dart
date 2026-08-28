import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:intl/intl.dart';
import 'package:pdf_text/pdf_text.dart';

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
  final String sourceFileName;
  final String? warning;

  bool get hasAny =>
      insurer != null ||
      policyNumber != null ||
      premiumCents != null ||
      excessCents != null ||
      sumInsuredCents != null ||
      expiryDate != null;
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
  };

  static final RegExp _premiumRe = RegExp(
    r'(?:annual\s+)?(?:total\s+)?(?:premium|you\s+pay|amount\s+due)[^$\n]{0,40}\$\s?([\d,]+(?:\.\d{2})?)',
    caseSensitive: false,
  );

  static final RegExp _excessRe = RegExp(
    r'(?:excess|excess\s+amount)[^$\n]{0,40}\$\s?([\d,]+(?:\.\d{2})?)',
    caseSensitive: false,
  );

  static final RegExp _sumInsuredRe = RegExp(
    r'(?:sum\s+insured|insured\s+(?:amount|value)|building\s+insured|contents\s+insured)[^$\n]{0,40}\$\s?([\d,]+(?:\.\d{2})?)',
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

  static ExtractedPolicyData fromText(String text, {required String sourceFileName}) {
    final insurerKey = _findInsurerKey(text);
    final entry = InsurerCatalog.byKey(insurerKey);
    return ExtractedPolicyData(
      insurer: entry?.name,
      insurerKey: insurerKey,
      policyNumber: _firstMatch(_policyNumberRe, text),
      premiumCents: _money(_premiumRe, text),
      excessCents: _money(_excessRe, text),
      sumInsuredCents: _money(_sumInsuredRe, text),
      expiryDate: _date(_expiryDateRe, text),
      sourceFileName: sourceFileName,
    );
  }

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
    final cleaned = raw.replaceAll(',', '').trim();
    final value = double.tryParse(cleaned);
    return value == null ? null : (value * 100).round();
  }

  static DateTime? _date(RegExp re, String text) {
    final raw = _firstMatch(re, text);
    if (raw == null) return null;
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

/// Extraction pipeline: text-based PDFs first, image OCR as fallback.
///
/// Everything runs on the device — no network, no cost, no cloud upload.
/// Scanned (image-only) PDFs are not yet supported and return a warning.
class LocalPolicyExtractionService {
  Future<ExtractedPolicyData> extract({
    required String filePath,
    required String fileName,
  }) async {
    final extension = fileName.split('.').last.toLowerCase();
    try {
      if (extension == 'pdf') {
        final doc = await PDFDoc.fromPath(filePath);
        final text = await doc.text;
        if (text.trim().isEmpty) {
          return ExtractedPolicyData(
            sourceFileName: fileName,
            warning: '这是扫描版 PDF，暂时无法自动识别，请手动填写。',
          );
        }
        return PolicyDataExtractor.fromText(text, sourceFileName: fileName);
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
        warning: '识别失败（$e）。请手动填写，或改用清晰的照片/PDF。',
      );
    }
  }
}
