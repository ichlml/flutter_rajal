import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fastmu_rajal/controllers/pemeriksaan_controller.dart';

import 'package:fastmu_rajal/config/colors.dart';

class ListBerkas extends StatelessWidget {
  ListBerkas({super.key});
  static const nameRoute = "/list_berkas";

  final PemeriksaanController pemeriksaanController = Get.put(PemeriksaanController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "List Berkas",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600
          ),
        ),
        centerTitle: true,
        backgroundColor: MyColor.primary,
        shadowColor: Colors.blueGrey[100],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: MyColor.primary,
        child: const Icon(Icons.photo_camera), 
      ),
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // info pasien
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 12.0
              ),
              child: Column(
                children: [
                  Card(
                    shadowColor: Colors.blueGrey[200],                
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 14.0
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "INFO PASIEN :",
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: MyColor.primary,
                                ),
                              ),
                              Text(
                                pemeriksaanController.selectedPasien['no_rawat'],
                                style: TextStyle(
                                  color: Colors.grey[600]
                                ),
                              )
                            ],
                          ),
                          const Divider(
                            thickness: 0.8,
                            height: 17.0,
                          ),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: pemeriksaanController.selectedPasien['no_rm'].toString().padLeft(6, "0"),
                                  style: const TextStyle(
                                    color: Colors.orange,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w600
                                  )
                                ),
                                const TextSpan(
                                  text: " - ",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w600
                                  )
                                ),
                                TextSpan(
                                  text: pemeriksaanController.selectedPasien['nama'],
                                  style: const TextStyle(                                    
                                    color: Colors.black87,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w600
                                  )
                                ),
                              ]
                            )
                          ),
                          Text(
                            pemeriksaanController.selectedPasien['klinik'],
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey[600],
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 12.0
              )
            )
          )
        ]
      ),
    );
  }
}