import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kapetanioswebapp_front/domain/entities/AgentEntity.dart';
import 'package:kapetanioswebapp_front/domain/entities/LogsEntity.dart';
import 'package:kapetanioswebapp_front/domain/entities/ResponseEntity.dart';
import 'package:kapetanioswebapp_front/domain/use_cases/AgenteService.dart';
import 'package:kapetanioswebapp_front/presentation/screens/menu.dart';
import 'package:quickalert/quickalert.dart';

class RegistroNuevoMonitor extends StatefulWidget {
  final Agente agente;
  const RegistroNuevoMonitor({super.key, required this.agente});

  @override
  State<RegistroNuevoMonitor> createState() => _RegistroNuevoMonitorState();
}

class _RegistroNuevoMonitorState extends State<RegistroNuevoMonitor> {
  TextStyle tituloStilo = TextStyle(
    fontSize: 25,
    fontWeight: FontWeight.w500
  );
  String selectedItem = "Heml Chart";
  String selectedMenuItem = "";
  String instructionsInstallOperator = """
helm repo add kapetanios https://kapetanios-artifactory.nyc3.digitaloceanspaces.com/helm-charts
helm repo update
helm install kapetanios-agent kapetanios/kapetanios-agent""";
  String deployText = "kubectl apply -f kapetanios-agent-config.yaml";
  Agenteservice agenteservice = Agenteservice();
  late Agente agente; //Agente(dateTime: DateTime.now());
  bool actualizar = false;

  @override
  void initState() {
    agente = widget.agente;
    actualizar = agente.id != "";
    agente.prommetheusUrl = "http://164.90.255.142:9090";
    agente.modelApiUrl = "http://localhost:8080";
    agente.kptsServerUrl = " http://127.0.0.1:8000";
    super.initState();
  }

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
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          IconButton(
                                            iconSize: 20,
                                            icon: const Icon(
                                              FontAwesomeIcons.clipboard,
                                              color: Colors.white,
                                            ),
                                            // the method which is called
                                            // when button is pressed
                                            onPressed: () async {
                                              await Clipboard.setData(ClipboardData(text: """
apiVersion: "v1"
kind: "ConfigMap"
metadata:
  name: "kapetanios-agent-config"
  namespace: "kapetanios"
data:
  PROMETHEUS_URL: ${agente.prommetheusUrl}
  MODEL_API_URL: ${agente.modelApiUrl}
  KAPETANIOS_SERVER_URL: ${agente.kptsServerUrl}
"""));
                                              
                                              // Mostrar feedback al usuario
                                              if (context.mounted) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(
                                                    content: Text('Yml copiado.'),
                                                    duration: Duration(seconds: 1),
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                      lineYML("apiVersion", "v1", 0),
                                      lineYML("kind", "ConfigMap", 0),
                                      lineYML("metadata", "", 0),
                                      lineYML("name", "kapetanios-agent-config", 1),
                                      lineYML("namespace", "kapetanios", 1),
                                      lineYML("data", "", 0),
                                      lineYML("PROMETHEUS_URL", agente.prommetheusUrl, 1),
                                      lineYML("MODEL_API_URL", agente.modelApiUrl, 1),
                                      lineYML("KAPETANIOS_SERVER_URL", agente.kptsServerUrl, 1),
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
                                              child: TextFormField(
                                                initialValue: agente.prommetheusUrl,
                                                onChanged: (value) {
                                                  setState(() {
                                                    agente.prommetheusUrl = value;
                                                  });
                                                },
                                                decoration: InputDecoration(
                                                  hintText: "Prometheus URL",
                                                  labelText: "Prometheus URL",
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(8),
                                                    borderSide: BorderSide(color: Colors.black, width: 1),
                                                  ),
                                                ),
                                              ),
                                            ),Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: TextFormField(
                                                initialValue: agente.modelApiUrl,
                                                onChanged: (value) {
                                                  setState(() {
                                                    agente.modelApiUrl = value;
                                                  });
                                                },
                                                decoration: InputDecoration(
                                                  hintText: "Model Api Url",
                                                  labelText: "Model Api Url",
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(8),
                                                    borderSide: BorderSide(color: Colors.black, width: 1),
                                                  ),
                                                ),
                                              ),
                                            ),Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: TextFormField(
                                                initialValue: agente.kptsServerUrl,
                                                onChanged: (value) {
                                                  setState(() {
                                                    agente.kptsServerUrl = value;
                                                  });
                                                },
                                                decoration: InputDecoration(
                                                  hintText: "Kapetanios Server",
                                                  labelText: "Kapetanios Server",
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
                            height: MediaQuery.sizeOf(context).height*.2,
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
                            child: StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance.collection("Logs")
                                .orderBy("timestamp", descending: true)
                                .snapshots(),
                              builder: (ctx, snapshot){
                                if(!snapshot.hasData || snapshot.data!.docs.isEmpty){
                                  return DataTable(
                                    columns: const <DataColumn>[
                                      DataColumn(label: Text("Log")),
                                      DataColumn(label: Text("Hora")),
                                      DataColumn(label: Text("Mensaje")),
                                      DataColumn(label: Text("Fuente")),
                                    ], rows: const <DataRow>[
                                      DataRow(
                                        cells: <DataCell>[
                                          DataCell(CircularProgressIndicator()),
                                          DataCell(Text("")),
                                          DataCell(Text("")),
                                          DataCell(Text("")),
                                        ]
                                      )
                                    ]
                                  );
                                }

                                final logs = snapshot.data!.docs.map((doc) {
                                  return LogEntity.fromMap(doc.data() as Map<String, dynamic>, doc.id);
                                }).toList();
                                return SingleChildScrollView(
                                  child: DataTable(
                                      columns: const <DataColumn>[
                                        DataColumn(label: Text("Log")),
                                        DataColumn(label: Text("Hora")),
                                        DataColumn(label: Text("Mensaje")),
                                        DataColumn(label: Text("Fuente")),
                                      ], rows: logs.map((log) {
                                        return DataRow(cells: [
                                          DataCell(Text(log.logLevel)),
                                          DataCell(Text(log.timestamp.toString())),
                                          DataCell(Text(log.message)),
                                          DataCell(Text(log.source)),
                                        ]);
                                      }).toList()
                                    ),
                                );
                              }
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
                                  label: Text(actualizar ? "Actualizar" : "Guardar", style: TextStyle(
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
                                     
                                    Responseentity? response;
                                    if(actualizar){
                                      response = await agenteservice.updateAgent(agente);
                                    }else{
                                      response = await agenteservice.saveAgent(agente);
                                    }
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
kubectl create secret generic datadog-secret --from-literal""";
            }else{
              instructionsInstallOperator = """
helm repo add kapetanios https://kapetanios-artifactory.nyc3.digitaloceanspaces.com/helm-charts
helm repo update
helm install kapetanios-agent kapetanios/kapetanios-agent""";
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


  

  Widget lineYML(String clave, String valor, int tabulador){
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: RichText(
        text: TextSpan(
          text: '${'\t'*(tabulador)}',
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

