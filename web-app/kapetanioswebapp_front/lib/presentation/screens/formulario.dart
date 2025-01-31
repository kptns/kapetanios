import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kapetanioswebapp_front/domain/entities/AgentEntity.dart';
import 'package:kapetanioswebapp_front/domain/entities/ResponseEntity.dart';
import 'package:kapetanioswebapp_front/domain/use_cases/AgenteService.dart';
import 'package:kapetanioswebapp_front/presentation/screens/menu.dart';
import 'package:quickalert/quickalert.dart';

class RegistroNuevoMonitor extends StatefulWidget {
  const RegistroNuevoMonitor({super.key});

  @override
  State<RegistroNuevoMonitor> createState() => _RegistroNuevoMonitorState();
}

class _RegistroNuevoMonitorState extends State<RegistroNuevoMonitor> {
  TextStyle tituloStilo = TextStyle(
    fontSize: 25,
    fontWeight: FontWeight.w500
  );
  String selectedItem = "Operator";
  String selectedMenuItem = "";
  String instructionsInstallOperator = """
helm repo add datadog https://helm.datadoghq.com
helm install datadog-operator datadog/datadog-operator
kubectl create secret generic datadog-secret --from-literal \napi-key=5bb1b4ba6f51ba73cf9c3bede5088bc2""";
  String deployText = "kubectl apply -f datadog-agent.yaml";
  Agenteservice agenteservice = Agenteservice();
  Agente agente = Agente(clusterName: "cluster", hostRegistry: "host", hostKapetanios: "host", dateTime: DateTime.now(), pod: '1', status: 'Desplegado', ready: 1, restart: 0, cpuUsageLimit: 50, memUsageLimit: 20);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        child: Row(
          children: [
            Container( 
              height: MediaQuery.sizeOf(context).height,
              width: MediaQuery.sizeOf(context).width*.2,
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  lateralMenuButton("Kubernetes", FontAwesomeIcons.docker),
                  lateralMenuButton("PHP", FontAwesomeIcons.php),
                  lateralMenuButton("Java", FontAwesomeIcons.java),
                ],
              ),
            ),
            Container(
              width: MediaQuery.sizeOf(context).width*.8,
              child: ScrollConfiguration(
                behavior:  NoScrollBarBehavior(),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Instrucciones de instalacion", style: tituloStilo,),
                        instructionTitle("Metodo de instalacion", 1),
                        Padding(
                          padding: const EdgeInsets.only(left: 40),
                          child: Row(
                            children: [
                              methodButton("Operator"),
                              methodButton("Heml Chart"),
                            ],
                          ),
                        ),
                        instructionTitle("Instalar operador", 2),
                        grayContainerText(context, instructionsInstallOperator),
                        instructionTitle("Configurar yml", 3),
                        Padding(
                          padding: const EdgeInsets.only(left: 40),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SelectionArea(
                                child: Container(
                                  width: MediaQuery.sizeOf(context).width*.363,
                                  color: const Color(0xFF2D2D30),
                                  padding: EdgeInsets.all(14),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      lineYML("apiVersion", "datadoghq.com/v2alpha1", 0, 1),
                                      lineYML("kind", "DatadogAgent", 0, 2),
                                      lineYML("metadata", "", 0, 3),
                                      lineYML("name", "datadog", 5, 4),
                                      lineYML("namespace", "default", 5, 4),
                                      lineYML("spec", "", 0, 5),
                                      lineYML("server_host", "example.server.com", 5, 6),
                                      lineYML("datadog_host", "agent.datadog.com", 5, 6),
                                      lineYML("account_id", "1234567890", 5, 6),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Container(
                                  width: MediaQuery.sizeOf(context).width*.324,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            width: 1.0,
                                            color: Colors.grey.withAlpha(100)
                                          ),
                                        ),
                                        child: ExpansionTile(
                                          title: Text("Global Variables"),
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: TextField(
                                                onChanged: (value) {
                                                  print("3213");
                                                },
                                                decoration: InputDecoration(
                                                  hintText: "Nombre del cluster",
                                                  labelText: "Nombre del cluster",
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(8),
                                                    borderSide: BorderSide(color: Colors.black, width: 1),
                                                  ),
                                                ),
                                              ),
                                            ),Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: TextField(
                                                onChanged: (value) {
                                                  print("3213");
                                                },
                                                decoration: InputDecoration(
                                                  hintText: "Registry host",
                                                  labelText: "Registry host",
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(8),
                                                    borderSide: BorderSide(color: Colors.black, width: 1),
                                                  ),
                                                ),
                                              ),
                                            ),Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: TextField(
                                                onChanged: (value) {
                                                  print("3213");
                                                },
                                                decoration: InputDecoration(
                                                  hintText: "Kapetanios host",
                                                  labelText: "Kapetanios host",
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(8),
                                                    borderSide: BorderSide(color: Colors.black, width: 1),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        instructionTitle("Desplegar agente con la configuracion anterior", 4),
                        grayContainerText(context, deployText),
                        instructionTitle("Confirmar instalacion de agente", 5),
                        Padding(
                          padding: const EdgeInsets.only(left: 40),
                          child: Container(
                            height: MediaQuery.sizeOf(context).height*.3,
                            width: MediaQuery.sizeOf(context).width*.7,
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
                                DataColumn(label: Text("AGE")),
                                DataColumn(label: Text("READY")),
                                DataColumn(label: Text("RESTART"))
                              ], rows: const <DataRow>[
                                DataRow(
                                  cells: <DataCell>[
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
                        ),
                        Container(
                          width: MediaQuery.sizeOf(context).width*.74,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton.icon(
                                  icon: const Icon(FontAwesomeIcons.x, size: 18),
                                  label: Text('Cancelar', style: TextStyle(
                                    fontSize: 20
                                  ),),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent,
                                    foregroundColor: Colors.white,
                                    iconColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                SizedBox(width: 20,),
                                ElevatedButton.icon(
                                  icon: const Icon(FontAwesomeIcons.save, size: 18),
                                  label: Text('Guardar', style: TextStyle(
                                    fontSize: 20
                                  ),),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blueAccent,
                                    foregroundColor: Colors.white,
                                    iconColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () async {
                                     
                                    Responseentity? response = await agenteservice.saveAgent(agente);
                                    if(response!.getSuccess){
                                      await QuickAlert.show(
                                        context: context, 
                                        type: QuickAlertType.success,
                                        text: response.getData
                                      );
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const Menu()),
                                      );
                                    }else{
                                      QuickAlert.show(
                                        context: context, 
                                        type: QuickAlertType.error,
                                        text: response.getData
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      )
    );
  }

  Padding lateralMenuButton(String texto, IconData icono) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: (){
          setState(() {
            selectedMenuItem = texto;
          });
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          alignment: Alignment.center,
          height: 50,
          width: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(5.0)
            ),
            border: Border.all(
              width: 1,
              color: selectedMenuItem == texto ? Colors.white : Colors.grey.withAlpha(100)
            ),
            color: selectedMenuItem == texto ? Colors.blueAccent : Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icono,
                color: selectedMenuItem == texto ? Colors.white : Colors.black,
              ),
              SizedBox(width: 20,),
              Text(texto, style: TextStyle(
                fontSize: 18,
                color: selectedMenuItem == texto ? Colors.white : Colors.black
              ),)
            ],
          ),
        ),
      ),
    );
  }

  Padding grayContainerText(BuildContext context, String texto) {
    return Padding(
      padding: const EdgeInsets.only(left: 40),
      child: SelectionArea(
        child: Container(
          width: MediaQuery.sizeOf(context).width*.7,
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.withAlpha(30)
          ),
          child: Text(
            texto, 
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Padding methodButton(String titulo) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: (){
          setState(() {
            selectedItem = titulo;
            if("Operator" == selectedItem){
              instructionsInstallOperator = """
helm repo add datadog https://helm.datadoghq.com
helm install datadog-operator datadog/datadog-operator
kubectl create secret generic datadog-secret --from-literal \napi-key=5bb1b4ba6f51ba73cf9c3bede5088bc2""";
            }else{
              instructionsInstallOperator = """
helm repo add datadog https://helm.datadoghq.com
helm repo update
kubectl create secret generic datadog-secret --from-literal \napi-key=5bb1b4ba6f51ba73cf9c3bede5088bc2""";
            }
          });
        },
        child: Container(
          height: 60,
          width: 200,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: titulo == selectedItem ? Colors.grey.withAlpha(60) : Colors.white,
            border: Border.all(
              width: titulo == selectedItem ? 4 : 2,
              color: titulo == selectedItem ? Colors.blueAccent : Color.fromRGBO(189, 189, 189, 1)
            ),
            borderRadius: BorderRadius.all(
                Radius.circular(5.0) //                 <--- border radius here
            ),
          ),
          child: Text(titulo, style: TextStyle(
            fontSize: 18
          ),)
        ),
      ),
    );
  }

  Container instructionTitle(String titulo, int i) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.center,
            height: 35,
            width: 35,
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.all(
                  Radius.circular(20.0)
              ),
            ),
            child: Text(i.toString(), style: TextStyle(
              fontSize: 15,
              color: Colors.white
            ),),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(titulo, style: tituloStilo,),
          )
        ],
      ),
    );
  }


  

  Widget lineYML(String clave, String valor, int tabulador, int i){
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: RichText(
        text: TextSpan(
          text: '$i${'\t'*(tabulador+1)}',
          style: TextStyle(color: Colors.grey[600],fontSize: 16),
          children: <TextSpan>[
            TextSpan(
              text: '$clave: ',
              style: TextStyle(color: Colors.blueAccent[100], fontSize: 16),
            ),
            TextSpan(
              text: valor == "" ? '' : '"$valor"',
              style: TextStyle(color: Colors.brown[300], fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

   
}

class NoScrollBarBehavior extends ScrollBehavior {
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const ClampingScrollPhysics(); // Deshabilita cualquier efecto de rebote
  }

  @override
  Widget buildScrollbar(BuildContext context, Widget child, ScrollableDetails details) {
    return child; // Elimina la barra de scroll
  }
}