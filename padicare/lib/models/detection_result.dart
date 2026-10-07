enum DetectionStatus {
  initial,
  loading,
  diseaseDetected,
  healthy,
  uncertain,
  error,
}

enum DetectionErrorType {
  none,
  permissionDenied,
  imageReadFailed,
  modelLoadFailed,
  inferenceFailed,
}

class DetectionResult {
  final DetectionStatus status;
  final String? labelId; // e.g. "brown_spot", "bacterial_leaf_blight", "normal"
  final String? displayName;
  final double? confidence; // 0.0 - 1.0 (skor model)
  final String? imagePath;
  final String? description;
  final DetectionErrorType errorType;
  final String? errorMessage;
  final String? recoveryAction;
  final int inferenceTimeMs;

  const DetectionResult({
    required this.status,
    this.labelId,
    this.displayName,
    this.confidence,
    this.imagePath,
    this.description,
    this.errorType = DetectionErrorType.none,
    this.errorMessage,
    this.recoveryAction,
    this.inferenceTimeMs = 0,
  });

  factory DetectionResult.initial() => const DetectionResult(
        status: DetectionStatus.initial,
      );

  factory DetectionResult.loading({required String imagePath}) =>
      DetectionResult(
        status: DetectionStatus.loading,
        imagePath: imagePath,
      );

  factory DetectionResult.disease({
    required String labelId,
    required String displayName,
    required double confidence,
    required String imagePath,
    required String description,
    int inferenceTimeMs = 0,
  }) =>
      DetectionResult(
        status: DetectionStatus.diseaseDetected,
        labelId: labelId,
        displayName: displayName,
        confidence: confidence,
        imagePath: imagePath,
        description: description,
        inferenceTimeMs: inferenceTimeMs,
      );

  factory DetectionResult.healthy({
    required double confidence,
    required String imagePath,
    int inferenceTimeMs = 0,
  }) =>
      DetectionResult(
        status: DetectionStatus.healthy,
        labelId: 'normal',
        displayName: 'Daun Tampak Sehat',
        confidence: confidence,
        imagePath: imagePath,
        description:
            'Tidak terdeteksi pola bercak atau hawar khas pada daun padi yang diperiksa. Pertahankan sanitasi dan pengamatan berkala.',
        inferenceTimeMs: inferenceTimeMs,
      );

  factory DetectionResult.uncertain({
    required double confidence,
    required String imagePath,
    int inferenceTimeMs = 0,
  }) =>
      DetectionResult(
        status: DetectionStatus.uncertain,
        labelId: 'uncertain',
        displayName: 'Hasil Belum Meyakinkan',
        confidence: confidence,
        imagePath: imagePath,
        description:
            'Skor keyakinan model berada di bawah batas kepastian atau pola visual tidak cukup jelas. Diperlukan pengambilan foto ulang dengan pencahayaan yang lebih baik.',
        inferenceTimeMs: inferenceTimeMs,
      );

  factory DetectionResult.error({
    required DetectionErrorType errorType,
    required String message,
    String? recoveryAction,
    String? imagePath,
  }) =>
      DetectionResult(
        status: DetectionStatus.error,
        errorType: errorType,
        errorMessage: message,
        recoveryAction: recoveryAction,
        imagePath: imagePath,
      );
}
