import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;

import 'package:fastmu_rajal/models/pemeriksaan_model.dart';
import 'package:fastmu_rajal/models/polikllinik_model.dart';
import 'package:fastmu_rajal/models/dokter_model.dart';

import 'package:fastmu_rajal/config/constant.dart';

class PemeriksaanController extends GetxController {

  late SharedPreferences prefs; 
  final Dio dio = Dio();
  
  // list pemeriksaan
  late Response dataOfPemeriksaan;
  final isLoading = true.obs;
  final page = 1.obs;
  final perPage = 300.obs;
  final keyword = "".obs;
  final listDataPemeriksaan = [].obs;
  final selectedKlinik = <String, dynamic>{ 
    "value": "all",
    "label": "Semua Klinik"
  }.obs;
  final selectedDokter = <String, dynamic>{ 
    "value": "all",
    "label": "Semua Dokter"
  }.obs;
  final selectedPasien = <String, dynamic>{
    "id": 0,
    "nama": "",
    "no_rawat": "",
    "no_rm": "",
    "klinik": "",
  }.obs;  

  // list klinik
  late Response dataOfPoliklinik;
  final listDataPoli = [].obs;
  // list klinik
  late Response dataOfDokter;
  final listDataDokter = [].obs;

  @override
  void onInit() {
    super.onInit();
    _getDataPemeriksaan();
    _getDataPoliklinik();

    ever(selectedKlinik, (value) {
      _getDataPemeriksaan();
      _getDataDokter();
    });

    ever(keyword, (value) {
      _getDataPemeriksaan();
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  // get list data pemeriksaan pasien
  Future<void> _getDataPemeriksaan() async {
    prefs = await SharedPreferences.getInstance();
    
    isLoading(true);
    try {
      dataOfPemeriksaan = await dio.get(
        '$API_URL/rajal/antrian',
        options: Options(
          headers: { 'Authorization': prefs.getString('token') },
        ),
        queryParameters: {
          'page': page,
          'perPage': perPage,
          'poli': selectedKlinik['value'],
          'dokter': selectedDokter['value'],
          'cari': keyword
        } 
      );

      if (dataOfPemeriksaan.statusCode == 200 && dataOfPemeriksaan.data != null) {
        final list = dataOfPemeriksaan.data['data'].map<PemeriksaanModel>((list) => PemeriksaanModel.fromJson(list)).toList();

        listDataPemeriksaan(list);
        isLoading(false);
      }
    } 
    on DioError catch(err) {
      isLoading(false);
      throw Exception(err.message);
    }
  }

  // get list data poliklinik
  Future<void> _getDataPoliklinik() async {
    prefs = await SharedPreferences.getInstance();
    
    try {
      dataOfPoliklinik = await dio.get(
        '$API_URL/klinik',
        options: Options(
          headers: { 'Authorization': prefs.getString('token') },
        ),
      );
    
      final list = await dataOfPoliklinik.data['data'].map<PoliklinikModel>((list) => PoliklinikModel.fromJson(list)).toList();
      list.insert(0,
        PoliklinikModel(
          kode: "all",
          nama: "Semua Poliklinik"
        )
      );

      listDataPoli(list);      
    } 
    on DioError catch(err) {
      isLoading(false);
      throw Exception(err.message);
    }
  }

  // get list data dokter
  Future<void> _getDataDokter() async{
    prefs = await SharedPreferences.getInstance();
    
    try {
      dataOfDokter = await dio.get(
        '$API_URL/dokter/perhari',
        options: Options(
          headers: { 'Authorization': prefs.getString('token') },
        ),
      );
    
      final list = await dataOfDokter.data['data']
        .map<DokterModel>((list) => DokterModel.fromJadwal(list)).toList()
        .where((list) => list.poli == selectedKlinik['value']).toList();
      listDataDokter(list);      
    } 
    on DioError catch(err) {
      isLoading(false);
      throw Exception(err.message);
    }
  }

  Future<void> uploadPhoto(photo, caption) async{
    prefs = await SharedPreferences.getInstance();
    FormData formData = FormData.fromMap({
      "no_rawat": selectedPasien['no_rawat'],
      "caption": caption,
      "gambar": await MultipartFile.fromFile(photo.path, filename: photo.name)
    });

    try {
      final Response response = await dio.post(
        '$API_URL/rajal/perawat/berkas',
        data: formData,
        options: Options(
          headers: { 'Authorization': prefs.getString('token') },
        )
      );
      print(response);
    }
    on DioError catch(err) {
      throw Exception(err.message);
    }
  }

  void changePoli(poli) {
    Map<String, dynamic> parseMap = {
      "value": poli.kode,
      "label": poli.nama,
    };
    selectedKlinik(parseMap);
  }

  void changePasien(pasien) {
    Map<String, dynamic> parseMap = {
      "id": pasien.id,
      "nama": pasien.nama,
      "no_rawat": pasien.no_rawat,
      "no_rm": pasien.no_rm,
      "klinik": pasien.klinik
    };
    selectedPasien(parseMap);
  }

  void handleSearch([String text = ""]) {
    keyword(text);
    _getDataPemeriksaan();
  }

  Future<bool> handleLogout() async{
    prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    return true;
  }

}