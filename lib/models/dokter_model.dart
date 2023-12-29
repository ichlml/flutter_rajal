class DokterModel {
  
  final String kode, nama, poli;

  const DokterModel({
    required this.kode,
    required this.nama,
    required this.poli
  });

  factory DokterModel.fromJadwal(Map<String, dynamic?> json) {
    return DokterModel(
      kode: json['kd_dokter'] ?? "",
      nama: json['nm_dokter'] ?? "",
      poli: json['poli'] ?? ""
    );
  }
}