class PemeriksaanModel {
  final int id, antrian, no_rm;
  final String no_rawat, nama, dokter, klinik, mulai, selesai;

  const PemeriksaanModel({
    required this.id,
    required this.no_rm,
    required this.no_rawat,
    required this.antrian,
    required this.nama,
    required this.dokter,
    required this.klinik,
    required this.mulai,
    required this.selesai,
  });

  factory PemeriksaanModel.fromJson(Map<String, dynamic> json) {
    return PemeriksaanModel(
      id: json['id'] ?? 0,
      no_rm: json['no_rm'] ?? 0,
      no_rawat: json['no_rawat'] ?? "",
      antrian: json['nomer'] ?? 0,
      nama: json['nm_pasien'] ?? "-",
      dokter: json['nama'] ?? "-",
      klinik: json['nm_poli'] ?? "-",
      mulai: json['mulai'] ?? "00.00",
      selesai: json['selesai'] ?? "00.00",
    );
  }

}