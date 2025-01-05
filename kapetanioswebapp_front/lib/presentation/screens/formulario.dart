import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

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
  String instructionsInstallOperator = """
helm repo add datadog https://helm.datadoghq.com
helm install datadog-operator datadog/datadog-operator
kubectl create secret generic datadog-secret --from-literal \napi-key=5bb1b4ba6f51ba73cf9c3bede5088bc2
  """;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        child: SingleChildScrollView(
          child: Row(
            children: [
              Container( 
                height: MediaQuery.sizeOf(context).height,
                width: MediaQuery.sizeOf(context).width*.2,
                color: Colors.red,
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    InkWell(
                      onTap: (){},
                      child: Container(
                        child: Row(
                          children: [
                            Icon(FontAwesomeIcons.docker)
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
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
                    Padding(
                      padding: const EdgeInsets.only(left: 40),
                      child: SelectionArea(
                        child: Container(
                          width: MediaQuery.sizeOf(context).width*.7,
                          height: 110,
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey.withAlpha(80)
                          ),
                          child: Text(
                            instructionsInstallOperator, 
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    instructionTitle("Configurar yml", 3),
                    instructionTitle("Desplegar agente con la configuracion anterior", 4),
                    instructionTitle("Confirmar instalacion de agente", 5),
                  ],
                ),
              )
            ],
          ),
        ),
      )
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
kubectl create secret generic datadog-secret --from-literal \napi-key=5bb1b4ba6f51ba73cf9c3bede5088bc2
              """;
            }else{
              instructionsInstallOperator = """
helm repo add datadog https://helm.datadoghq.com
helm repo update
kubectl create secret generic datadog-secret --from-literal \napi-key=5bb1b4ba6f51ba73cf9c3bede5088bc2
              """;
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
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.all(
                  Radius.circular(15.0) //                 <--- border radius here
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


  // Container(
  //             height: MediaQuery.sizeOf(context).height,
  //             width: MediaQuery.sizeOf(context).width * .4,
  //             color: const Color(0xFF2D2D30),
  //             padding: EdgeInsets.all(14),
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.start,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text("Configuracion de agente", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),),
  //                 SizedBox(height: 20,),
  //                 lineYML("apiVersion", "datadoghq.com/v2alpha1", 0, 1),
  //                 lineYML("kind", "DatadogAgent", 0, 2),
  //                 lineYML("metadata", "", 0, 3),
  //                 lineYML("name", "datadog", 5, 4),
  //                 lineYML("spec", "", 0, 5),
  //                 lineYML("global", "", 5, 6),
  //                 lineYML("credentials", "", 10, 7),
  //                 lineYML("apiSecret", "", 15, 8),
  //                 lineYML("secretName", "datadog-secret", 20, 9),
  //                 lineYML("keyName", "keyname", 20, 10)
  //               ],
  //             ),
  //           )

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
