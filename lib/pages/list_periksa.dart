import 'package:fastmu_rajal/controllers/pemeriksaan_controller.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:get/get.dart';

import 'package:fastmu_rajal/pages/upload_photo.dart';
import 'package:fastmu_rajal/pages/login_view.dart';
import 'package:fastmu_rajal/pages/list_berkas.dart';

import 'package:fastmu_rajal/config/colors.dart';

class ListPeriksa extends StatefulWidget {
  ListPeriksa({super.key});
  static const nameRoute = '/list';

  @override
  State<ListPeriksa> createState() => _ListPeriksaState();
}

class _ListPeriksaState extends State<ListPeriksa> {
  final searchController = TextEditingController();
  late FocusNode searchFocus = FocusNode();
  final PemeriksaanController pemeriksaanController = Get.put(PemeriksaanController());

  @override
  void initState() {
    searchFocus.unfocus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        centerTitle: true,
        shadowColor: Colors.blueGrey[100],
        title: const Text(
          'Pasien Periksa',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600
          ),
        ),
        backgroundColor: MyColor.primary,
        actions: [
          IconButton(
            onPressed: (){
              showDialog(
                context: context,
                builder:(context) {
                  return AlertDialog(
                    title: Text('CONFIRM'),
                    content: const Text(
                      "Keluar dari aplikasi ?",
                    ),
                    actions: [
                      OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'Tidak',
                          style: TextStyle(
                            color: Colors.blueGrey
                          ),
                        ),
                      ),
                      OutlinedButton(
                        onPressed: (){
                          pemeriksaanController.handleLogout().then((value) => Navigator.pushNamedAndRemoveUntil(
                            context, 
                            LoginApp.nameRoute,
                            ModalRoute.withName(LoginApp.nameRoute)
                          ));
                        },
                        child: const Text(
                          'Ya',
                          style: TextStyle(
                            color: Colors.blueGrey
                          ),
                        )
                      ),
                    ],
                  );
                } 
              );
            },
            icon: const Icon(
              Icons.logout
            )
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 12.0
            ),
            child: Column(
              children: [
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 6,
                          right: 10,
                          bottom: 6,
                          left: 5 
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(35.0),
                            ),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Colors.grey.withOpacity(0.25),
                                  offset: const Offset(0, 2),
                                  blurRadius: 4.0
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18.0,
                              // vertical: 2.0
                            ),
                            child: TextField(
                              controller: searchController,
                              focusNode: searchFocus,
                              onTapOutside: (event) => searchFocus.unfocus(),
                              onEditingComplete: () {
                                pemeriksaanController.handleSearch(searchController.text);
                                searchFocus.unfocus();
                              },
                              style: const TextStyle(
                                fontSize: 15.5,
                              ),
                              cursorColor: Colors.indigo,
                              textInputAction: TextInputAction.search,
                              decoration: InputDecoration(
                                hintStyle: TextStyle(
                                  color: Colors.grey[500]
                                ),
                                border: InputBorder.none,
                                hintText: 'Cari pasien ...',
                              ),
                            ),
                          ),
                        ),
                      )
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: MyColor.primary,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(35.0),
                        ),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.25),
                            offset: const Offset(0, 2),
                            blurRadius: 4.0),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(32.0),
                          ),
                          onTap: () {
                            pemeriksaanController.handleSearch(searchController.text);
                            searchFocus.unfocus();
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(13.0),
                            child: Icon(Icons.search,
                                size: 23,
                                color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(
                    top: 10.0,
                  ),
                  child: IntrinsicHeight(
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Material(
                            child: InkWell(
                              onTap: () => showModalBottomSheet(
                                  barrierColor: Colors.black26,
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return OptionOfPoliklinik();
                                  },
                              ),
                              borderRadius: BorderRadius.circular(4.0),
                              radius: 5.0,
                              splashColor: Colors.white70,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 3.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget> [
                                    Text(
                                      'Poliklinik',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: 13.5,
                                        color: Colors.blueGrey[300],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 6.0,
                                        horizontal: 4.0
                                      ),
                                      child: Obx(() => Text(
                                        pemeriksaanController.selectedKlinik['label'].toString(),
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.indigo[800],
                                          fontWeight: FontWeight.w600
                                        )),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ),
                        VerticalDivider(
                          color: Colors.grey[400],
                          thickness: 0.8,
                        ),
                        Expanded(
                          flex: 1,
                          child: Material(
                            child: InkWell(
                              onTap: () => showModalBottomSheet(
                                  barrierColor: Colors.black26,
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return OptionOfDokter();
                                  } 
                              ),
                              borderRadius: BorderRadius.circular(4.0),
                              radius: 5.0,
                              splashColor: Colors.white70,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 3.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget> [
                                    Text(
                                      'Dokter',
                                      style: TextStyle(
                                        fontSize: 13.5,
                                        color: Colors.blueGrey[300],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 6.0,
                                        horizontal: 4.0
                                      ),
                                      child: Obx(() => Text(
                                        pemeriksaanController.selectedDokter['label'].toString(),
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.indigo[800],
                                          fontWeight: FontWeight.w600
                                        )),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 6.0,
                    offset: Offset(0, 5)
                  )
                ]
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18.0,
                      vertical: 12.0
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.withOpacity(0.15),
                        )
                      )
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget> [
                        Obx(() => Text(
                          "${pemeriksaanController.isLoading == true || pemeriksaanController.listDataPemeriksaan.length == 0 ? '0' : pemeriksaanController.listDataPemeriksaan.length.toString()} Data ditemukan",
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        )),
                        Material(
                          color: Colors.white70,
                          child: InkWell(
                            onTap: () {},
                            radius: 1.0,
                            splashColor: Colors.white70,
                            child: const Icon(
                              Icons.sort,
                            )
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(            
                    child: Obx((){
                    return pemeriksaanController.isLoading.value
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      :
                      pemeriksaanController.listDataPemeriksaan.length == 0 
                      ? Center(
                          child: Text("Data tidak ditemukan"),
                        ) 
                      : ListView.builder(
                        itemCount: pemeriksaanController.listDataPemeriksaan.length,
                        itemBuilder: ((context, index) {
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              vertical: 3.0,
                              horizontal: 6.0
                            ),
                            child: Material(
                              color: Colors.white70,
                              animationDuration: const Duration(
                                milliseconds: 300
                              ),
                              child: InkWell(
                                onTap: () async {
                                  pemeriksaanController.changePasien(
                                    pemeriksaanController.listDataPemeriksaan[index]
                                  );
                                  Navigator.pushNamed(context, ListBerkas.nameRoute);
                                },
                                splashColor: Colors.white70,
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 3.0,
                                    horizontal: 15.0
                                  ),
                                  leading: CircleAvatar(
                                    radius: 22.0,
                                    backgroundColor: Colors.cyan,
                                    child: Text(
                                      pemeriksaanController.listDataPemeriksaan[index].antrian.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700
                                      ),
                                    ),
                                  ),
                                  title: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: pemeriksaanController.listDataPemeriksaan[index].no_rm.toString().padLeft(6, '0'),
                                          style: const TextStyle(
                                            color: Colors.orange,
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w600
                                          ),
                                        ),
                                        const TextSpan(
                                          text: " - ",
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 15.0,
                                          ),
                                        ),
                                        TextSpan(
                                          text: pemeriksaanController.listDataPemeriksaan[index].nama,
                                          style: const TextStyle(
                                            color: Colors.black87,
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w600
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 4.0
                                        ),
                                        child: Text(
                                          pemeriksaanController.listDataPemeriksaan[index].dokter,
                                          style: TextStyle(
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.w500,
                                            color: MyColor.primary,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "${pemeriksaanController.listDataPemeriksaan[index].klinik} | ${pemeriksaanController.listDataPemeriksaan[index].mulai.substring(0, 5)} - ${pemeriksaanController.listDataPemeriksaan[index].selesai.substring(0, 5)}",
                                        style: const TextStyle(
                                          fontSize: 13.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                  trailing: Material(
                                    color: Colors.white,
                                    child: InkWell(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(10.0)
                                      ),
                                      onTap: () async {
                                        pemeriksaanController.changePasien(pemeriksaanController.listDataPemeriksaan[index]);
                                        await availableCameras().then((cameras) => Navigator.push(context,
                                          MaterialPageRoute(
                                            builder: (_) => TakePictureScreen(
                                              camera: cameras
                                            ) 
                                          )
                                        ));
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: Icon(
                                          Icons.photo_camera,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        })
                      );
                    })
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
        );
  }
}

class OptionOfPoliklinik extends StatefulWidget {
  OptionOfPoliklinik({super.key});

  @override
  State<OptionOfPoliklinik> createState() => _OptionOfPoliklinikState();
}

class _OptionOfPoliklinikState extends State<OptionOfPoliklinik> {
  final PemeriksaanController pemeriksaanController = Get.put(PemeriksaanController());

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0)
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 15.0
            ),
            child: Text(
              'Pilih Dokter',
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 15.0,
                fontWeight: FontWeight.w600
              ),
            )
          ),
          Divider(
            height: 0,
            color: Colors.grey[300],
            thickness: 0.8,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 5.0,
                vertical: 10.0
              ),
              child: Obx(() {
                return pemeriksaanController.listDataPoli.length == 0
                ? Center(
                    child: CircularProgressIndicator()
                  )
                : ListView.builder(
                  itemCount: pemeriksaanController.listDataPoli.length,
                  itemBuilder: (context, index) {
                    return Material(
                      color: Colors.white70,
                      child: InkWell(
                        onTap: () {
                          pemeriksaanController.changePoli(
                            pemeriksaanController.listDataPoli[index]
                          );
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10.0
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                pemeriksaanController.listDataPoli[index].nama,
                                style: const TextStyle(
                                  fontSize: 14.0
                                ),
                              ),
                              Radio(
                                activeColor: MyColor.primary,
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                value: pemeriksaanController.listDataPoli[index].kode,
                                groupValue: pemeriksaanController.selectedKlinik['value'],
                                onChanged: (value) {
                                  pemeriksaanController.changePoli(
                                    pemeriksaanController.listDataPoli[index]
                                  );
                                  Navigator.pop(context);
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }) 
            ) 
          )
        ],
      ),
    );
  }
}

///option list dokter
class OptionOfDokter extends StatefulWidget {
  const OptionOfDokter({super.key});

  @override
  State<OptionOfDokter> createState() => _OptionOfDokterState();
}

class _OptionOfDokterState extends State<OptionOfDokter> {
  final PemeriksaanController pemeriksaanController = Get.put(PemeriksaanController());

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0)
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 15.0
            ),
            child: Text(
              'Pilih Dokter',
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 15.0,
                fontWeight: FontWeight.w600
              ),
            )
          ),
          Divider(
            height: 0,
            color: Colors.grey[300],
            thickness: 0.8,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 5.0,
                vertical: 10.0
              ),
              child: Obx(() {
                return pemeriksaanController.listDataDokter.length == 0
                ? Center(
                    child: Text("Tidak ada jadwal dokter")
                  )
                :
                ListView.builder(
                  itemCount: pemeriksaanController.listDataDokter.length,
                  itemBuilder: (context, index) {
                    return Material(
                      color: Colors.white,
                      child: InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10.0
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                pemeriksaanController.listDataDokter[index].nama,
                                style: const TextStyle(
                                  fontSize: 14.0
                                ),
                              ),
                              Radio(
                                activeColor: MyColor.primary,
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                value: pemeriksaanController.listDataDokter[index].kode,
                                groupValue: pemeriksaanController.selectedDokter['value'],
                                onChanged: (value) {
                                  pemeriksaanController.changePoli(
                                    pemeriksaanController.listDataPoli[index]
                                  );
                                  Navigator.pop(context);
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ) 
          )
        ],
      ),
    );
  }
}