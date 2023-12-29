class PoliklinikModel {
  
  final String kode, nama;

  const PoliklinikModel({
    required this.kode,
    required this.nama
  });

  factory PoliklinikModel.fromJson(Map<String, dynamic?> json) {
    return PoliklinikModel(
      kode: json['kd_poli'],
      nama: json['nm_poli']
    );
  }
}