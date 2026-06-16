class VoiceClone {
  final String voiceid;
  final String voiceName;
  final String? description;
  final String language;
  final String? photoPath;

  VoiceClone({
    required this.voiceid,
    required this.voiceName,
    this.description,
    required this.language,
    this.photoPath,
  });

  factory VoiceClone.fromMap(Map<String, dynamic> map) {
    return VoiceClone(
      voiceid: map['voiceid']?.toString() ?? '',
      voiceName: map['voice_name']?.toString() ?? '',
      description: map['description']?.toString(),
      language: map['language']?.toString() ?? 'en',
      photoPath: map['photo_path']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'voiceid': voiceid,
      'voice_name': voiceName,
      'description': description,
      'language': language,
      'photo_path': photoPath,
    };
  }
}
