class AssetModel {
  final String assetNo;
  final String description;
  final String assetClass;
  final String assetClassName;
  final String? capDate;
  final String assetOwner;
  final String costCenter;
  final String costCenterName;
  final String mainLocation;
  final String lastLocationName;
  final String environment;
  final String mobility;
  final String status;
  final int currentStatus;
  final String lastImageUrl;
  final String lastCondition;
  final String? remarks;
  final DateTime? updatedAt;
  final String updatedBy;
  final List<Map<String, dynamic>> history;

  AssetModel({
    required this.assetNo,
    required this.description,
    required this.assetClass,
    required this.assetClassName,
    this.capDate,
    required this.assetOwner,
    required this.costCenter,
    required this.costCenterName,
    required this.mainLocation,
    required this.lastLocationName,
    required this.environment,
    required this.mobility,
    required this.status,
    required this.currentStatus,
    required this.lastImageUrl,
    required this.lastCondition,
    this.remarks,
    this.updatedAt,
    required this.updatedBy,
    required this.history,
  });

  /// 🪄 ถอดแบบมาจากฟังก์ชัน `normalizeAsset` ใน utils.ts
  factory AssetModel.fromFirestore(Map<String, dynamic> json, String docId) {
    // ฟังก์ชันช่วยดึงชื่อย่อ Asset Class แปลงจากอาร์เรย์ด้านล่าง
    String getShortClassName(String rawClass) {
      final classMap = {
        'A2000': 'Building', 'A2004': 'Machine', 'A2007': 'Piping',
        'A2008': 'Plant Equipment', 'A2009': 'Tools', 'A2011': 'Furniture',
        'A3001': 'Vehicle', 'A3002': 'Heavy Vehicle', 'A5004': 'ROU Vehicle',
        'A62009': 'LVA Tools', 'A62011': 'LVA Furniture', 'A63001': 'LVA Vehicle',
        'A9000': 'LVA Equipment', 'A9002': 'LVA Furniture', 'A9004': 'LVA Vehicle',
        'A9801': 'AUC Machine', 'A9802': 'AUC Other', 'A2005': 'Machine (POM)',
      };
      return classMap[rawClass] ?? rawClass;
    };

    // ตัวแปลงพวกค่าประเภท Timestamp ของ Firestore
    DateTime? parseTimestamp(dynamic v) {
      if (v == null) return null;
      if (v is DateTime) return v;
      // ถ้ามาจากเครื่องมือภายนอกหรือ Firestore Timestamp ตัว SDK ใน Dart จะส่งมาเป็น Timestamp object ตรงๆ
      if (v.runtimeType.toString() == 'Timestamp') {
        return (v as dynamic).toDate();
      }
      return DateTime.tryParse(v.toString());
    }

    return AssetModel(
      assetNo: json['assetNo']?.toString() ?? docId, // ใช้ docId ถ้า assetNo เป็นว่าง
      description: json['description']?.toString() ?? '(ไม่มีคำอธิบาย)',
      assetClass: json['assetClass']?.toString() ?? '',
      // ลอจิกพอร์ต: ถ้าไม่มี assetClassName ให้วิ่งไปดึงจาก lookup map ทันที
      assetClassName: json['assetClassName']?.toString() ?? getShortClassName(json['assetClass']?.toString() ?? ''),
      capDate: json['capDate']?.toString(),
      assetOwner: json['assetOwner']?.toString() ?? '',
      costCenter: json['costCenter']?.toString() ?? '',
      costCenterName: json['costCenterName']?.toString() ?? '',
      mainLocation: json['mainLocation']?.toString() ?? '',
      lastLocationName: json['lastLocationName']?.toString() ?? '',
      environment: json['environment']?.toString() ?? 'unknown',
      mobility: json['mobility']?.toString() ?? 'unknown',
      status: json['status']?.toString() ?? 'unknown',
      currentStatus: int.tryParse(json['currentStatus']?.toString() ?? '') ?? 0,
      lastImageUrl: json['lastImageUrl']?.toString() ?? '',
      lastCondition: json['lastCondition']?.toString() ?? '',
      remarks: json['remarks']?.toString(),
      updatedAt: parseTimestamp(json['updatedAt']),
      updatedBy: json['updatedBy']?.toString() ?? '',
      history: List<Map<String, dynamic>>.from(json['history'] ?? []),
    );
  }

  // สำหรับแปลงกลับเป็น JSON ตอนยิงเซฟลงคลัง Firestore
  Map<String, dynamic> toJson() {
    return {
      'assetNo': assetNo,
      'description': description,
      'assetClass': assetClass,
      'assetClassName': assetClassName,
      'capDate': capDate,
      'assetOwner': assetOwner,
      'costCenter': costCenter,
      'costCenterName': costCenterName,
      'mainLocation': mainLocation,
      'lastLocationName': lastLocationName,
      'environment': environment,
      'mobility': mobility,
      'status': status,
      'currentStatus': currentStatus,
      'lastImageUrl': lastImageUrl,
      'lastCondition': lastCondition,
      'remarks': remarks,
      'updatedAt': updatedAt?.toIso8601String(),
      'updatedBy': updatedBy,
            'history': history,
    };
  }

  /// 🆕 fromJson — สำหรับแปลงจาก cache/local storage
  factory AssetModel.fromJson(Map<String, dynamic> json) {
    return AssetModel.fromFirestore(json, json['assetNo']?.toString() ?? '');
  }
}