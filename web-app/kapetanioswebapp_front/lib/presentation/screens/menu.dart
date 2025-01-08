import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:google_fonts/google_fonts.dart';
import 'package:kapetanioswebapp_front/presentation/screens/formulario.dart';
import 'package:kapetanioswebapp_front/presentation/screens/monitor.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:Container(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.black.withAlpha(50),
                    width: 1
                  )
                )
              ),
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Text("Kubernetes", style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w500
                      )
                    ),),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blueAccent,
                      minimumSize: Size(88, 36),
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegistroNuevoMonitor()),
                      );
                    },
                    icon: Icon(FontAwesomeIcons.plus, size: 20, color: Colors.white,),
                    label: Text('Agregar'),
                  )
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.black.withAlpha(50),
                    width: 1
                  )
                )
              ),
              child: Row(
                children: [
                  topMenu("Descripcion", false),
                  topMenu("Explorar", true),
                  topMenu("Mapear", false)
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: 120,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8), 
                        topLeft: Radius.circular(8)
                      )
                    ),
                    child: Text("Filtrar por: ", style: TextStyle(
                      fontSize: 20
                    ),),
                  ),
                  Container(
                    width: 500,
                    height: 40,
                    child: TextField(
                      style: TextStyle(fontSize: 20.0),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: "Filtrar por titulo",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Color.fromRGBO(189, 189, 189, 1)),
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(8), 
                            topRight: Radius.circular(8)
                          )
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color.fromRGBO(189, 189, 189, 1)),
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(8), 
                            topRight: Radius.circular(8)
                          )
                        ),
                      )
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: MediaQuery.sizeOf(context).height*.75,
                width: MediaQuery.sizeOf(context).width,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: Color.fromRGBO(189, 189, 189, 1)
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(8)
                  )
                ),
                child: DataTable(
                  columns: const <DataColumn>[
                    DataColumn(label: Text("POD")),
                    DataColumn(label: Text("STATUS")),
                    DataColumn(label: Text("CLUSTER")),
                    DataColumn(label: Text("NAMESPACE")),
                    DataColumn(label: Text("AGE")),
                    DataColumn(label: Text("READY")),
                    DataColumn(label: Text("RESTART")),
                    DataColumn(label: Text("CPI USAGE/LIMITS")),
                    DataColumn(label: Text("MEM USAGE/LIMITS"))
                  ], rows: const <DataRow>[
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text("1")),
                        DataCell(Text("1")),
                        DataCell(Text("1")),
                        DataCell(Text("1")),
                        DataCell(Text("1")),
                        DataCell(Text("1")),
                        DataCell(Text("1")),
                        DataCell(Text("1")),
                        DataCell(Text("1")),
                      ]
                    )
                  ]
                ),
              ),
            )
          ],
          
        ),
      )
    );
  }

  Container topMenu(String titulo, bool activo) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: activo ? Colors.blueAccent : Colors.transparent,
            width: 3
          )
        )
      ),
      padding: EdgeInsets.all(10),
      child: Text(titulo, style: TextStyle(
          fontSize: 20,
          color: Colors.grey[600]
        ),
      )
    );
  }
}
