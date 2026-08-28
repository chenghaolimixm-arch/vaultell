import 'insurance_type.dart';

/// A curated catalog of Australian insurers with their claim-page links.
///
/// URLs were verified in August 2026 from official insurer websites. They are
/// demo/bootstrapping data: users can also enter a custom insurer, and the
/// catalog can be extended over time.
class InsurerEntry {
  const InsurerEntry({
    required this.key,
    required this.name,
    required this.defaultClaimUrl,
    this.typeClaimUrls = const {},
  });

  final String key;
  final String name;
  final String defaultClaimUrl;
  final Map<InsuranceType, String> typeClaimUrls;

  String? claimUrlFor(InsuranceType type) => typeClaimUrls[type] ?? defaultClaimUrl;
}

class InsurerCatalog {
  static const List<InsurerEntry> all = [
    // ---- Car / Home / Landlord ------------------------------------------
    InsurerEntry(
      key: 'allianz',
      name: 'Allianz',
      defaultClaimUrl: 'https://www.allianz.com.au/my-allianz.html',
      typeClaimUrls: {
        InsuranceType.home: 'https://www.allianzsecure.com.au/origin/claims.html',
        InsuranceType.landlord: 'https://www.allianzsecure.com.au/origin/claims.html',
      },
    ),
    InsurerEntry(
      key: 'aami',
      name: 'AAMI',
      defaultClaimUrl: 'https://www.aami.com.au/claim',
      typeClaimUrls: {
        InsuranceType.home: 'https://www.aami.com.au/claim/home-landlord.html',
        InsuranceType.landlord: 'https://www.aami.com.au/claim/home-landlord.html',
      },
    ),
    InsurerEntry(
      key: 'racq',
      name: 'RACQ',
      defaultClaimUrl: 'https://www.racq.com.au/insurance/claims',
      typeClaimUrls: {
        InsuranceType.car: 'https://www.racq.com.au/car/car-insurance/make-a-claim',
      },
    ),
    InsurerEntry(
      key: 'racv',
      name: 'RACV',
      defaultClaimUrl: 'https://www.racv.com.au/insurance/claims.html',
    ),
    InsurerEntry(
      key: 'nrma',
      name: 'NRMA Insurance',
      defaultClaimUrl: 'https://www.nrma.com.au/claims',
    ),
    InsurerEntry(
      key: 'youi',
      name: 'Youi',
      defaultClaimUrl: 'https://www.youi.com.au/claiming',
    ),
    InsurerEntry(
      key: 'budget-direct',
      name: 'Budget Direct',
      defaultClaimUrl: 'https://www.budgetdirect.com.au/existing-customers/policy-manager.html',
      typeClaimUrls: {
        InsuranceType.car: 'https://www.budgetdirect.com.au/car-insurance/claims/make-a-claim.html',
      },
    ),
    InsurerEntry(
      key: 'gio',
      name: 'GIO',
      defaultClaimUrl: 'https://www.gio.com.au/claims.html',
    ),
    InsurerEntry(
      key: 'qbe',
      name: 'QBE',
      defaultClaimUrl: 'https://www.qbe.com/au/online-claims',
    ),
    InsurerEntry(
      key: 'suncorp',
      name: 'Suncorp Insurance',
      defaultClaimUrl: 'https://www.suncorp.com.au/insurance/car/comprehensive/claims.html',
      typeClaimUrls: {
        InsuranceType.home: 'https://www.suncorp.com.au/learn-about/maintaining-a-home/home-insurance-claim-tips.html',
      },
    ),
    InsurerEntry(
      key: 'commbank',
      name: 'CommBank (CBA)',
      defaultClaimUrl: 'https://www.commbank.com.au/insurance/home-insurance/how-to-make-a-claim.html',
      typeClaimUrls: {
        InsuranceType.car: 'https://www.commbank.com.au/insurance/car-insurance/how-to-make-a-claim.html',
      },
    ),
    InsurerEntry(
      key: 'terri-scheer',
      name: 'Terri Scheer',
      defaultClaimUrl: 'https://www.terrischeer.com.au/landlord-insurance',
    ),
    // ---- Health ----------------------------------------------------------
    InsurerEntry(
      key: 'medibank',
      name: 'Medibank',
      defaultClaimUrl: 'https://www.medibank.com.au/health-insurance/using-your-cover/claim/',
    ),
    InsurerEntry(
      key: 'bupa',
      name: 'Bupa',
      defaultClaimUrl: 'https://www.bupa.com.au/health-insurance/why-choose-bupa/easy-ways-to-claim',
    ),
    InsurerEntry(
      key: 'hcf',
      name: 'HCF',
      defaultClaimUrl: 'https://www.hcf.com.au/insurance/health/how-to-make-a-claim',
    ),
    InsurerEntry(
      key: 'nib',
      name: 'nib',
      defaultClaimUrl: 'https://www.nib.com.au/help/health/how-to-claim',
    ),
    // ---- Pet --------------------------------------------------------------
    InsurerEntry(
      key: 'rspca-pet',
      name: 'RSPCA Pet Insurance',
      defaultClaimUrl: 'https://rspcapetinsurance.org.au/claims/',
    ),
    InsurerEntry(
      key: 'petbarn',
      name: 'Petbarn Pet Insurance',
      defaultClaimUrl: 'https://www.petbarn.com.au/insurance',
    ),
  ];

  static const String customOptionKey = '__custom__';

  static InsurerEntry? byKey(String? key) {
    if (key == null) return null;
    for (final entry in all) {
      if (entry.key == key) return entry;
    }
    return null;
  }

  static InsurerEntry? byName(String? name) {
    if (name == null) return null;
    final normalized = name.trim().toLowerCase();
    for (final entry in all) {
      if (entry.name.toLowerCase() == normalized) return entry;
    }
    return null;
  }
}
