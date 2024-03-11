import 'package:crud_flutter/hive_data.dart';
import 'package:crud_flutter/personas.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:filter_list/filter_list.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(PersonasAdapter());
  runApp(const MyApp());
}





class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  
  final TextEditingController controllerNombre = TextEditingController();
  final TextEditingController controllerApellido = TextEditingController();
  final TextEditingController controllerBusqueda = TextEditingController();

  final HiveData hiveData = const HiveData();

  List<Personas> personas = [];
  List<Personas> personasOriginales = [];

  Personas? personaSeleccionada;

  bool hayPersonaSelecionada = false;


  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void dispose() {
    controllerNombre.dispose();
    controllerApellido.dispose();
    controllerBusqueda.dispose();
    super.dispose();
  }


  void editarPersona(Personas persona){
    setState(() {
      personaSeleccionada = persona;
      controllerApellido.text = persona.apellido;
      controllerNombre.text = persona.nombre;
      hayPersonaSelecionada = true;
    });
  }
  


  void actualizarPersona() async {
    if (personaSeleccionada != null) {
      personaSeleccionada!.nombre = controllerNombre.text;
      personaSeleccionada!.apellido = controllerApellido.text;
      await hiveData.updatePersonas(personaSeleccionada!.key, personaSeleccionada!);
      setState(() {
        personaSeleccionada = null;
        hayPersonaSelecionada = false;
      });
    }
  }


  
 void filterSearch(String query){
  if (query.isEmpty) {
    setState(() {
      personas = List.from(personasOriginales);
    });
  }
  else{
    List<Personas> filteredList = personasOriginales.where((person) {
      String fullName = '${person.nombre} ${person.apellido}';
      return fullName.toLowerCase().contains(query.toLowerCase());
    }).toList();
    setState(() {
      personas = filteredList;
    });
  }
 }

  Future<void> getData() async {

  personasOriginales = await hiveData.personas;
  
  filterSearch(controllerBusqueda.text);
}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(useMaterial3: true),
      debugShowCheckedModeBanner: false,
      title: 'CRUD Demo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Crud Basico en Flutter'),
          centerTitle: true,
        ),
        body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 12.0),
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Ingresa tu nombre'
                ),
                controller: controllerNombre,
              ),
              const SizedBox(
                height: 25,
              ),
              TextFormField(
                 decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Ingresa tu apellido'
                ),
                controller: controllerApellido,
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
              SizedBox(
                width: 128,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                  ),
                  onPressed: hayPersonaSelecionada ? null : () async {
          
                    if (controllerNombre.text.isEmpty ||
                        controllerApellido.text.isEmpty){
                          return;
                    } else {
          
                      await hiveData.savePersonas(
                        Personas(
                          nombre: controllerNombre.text,
                          apellido: controllerApellido.text,
                        ),
                      );
                      await getData();
          
                      controllerNombre.clear();
                      controllerApellido.clear();
                    }
                  },
                  child: const Row(
                    children: [
                      Text('Agregar ', style: TextStyle(color: Colors.white)),
                      Icon(Icons.add, color: Colors.white)
                    ],
                  ),
                ),
              ),
                  SizedBox(
                    width: 127,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.black),
                      ),
                      onPressed:() async {
                            
                        if (controllerNombre.text.isEmpty ||
                            controllerApellido.text.isEmpty){
                              return;
                        } else {
                            
                          actualizarPersona();

                          controllerNombre.clear();
                          controllerApellido.clear();
                        }
                      },
                      child: const Row(
                        children: [
                          Text('Guardar ', style: TextStyle(color: Colors.white)),
                          Icon(Icons.update, color: Colors.white)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
              child: TextField(
                controller: controllerBusqueda,
                onChanged: (query) => filterSearch(query),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xfff1f1f1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  
                  hintText: "Buscar Usuarios",        
                ),
              ),
            ),
              const SizedBox(
                height: 40,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: personas.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Container(
                        decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(),
                          left: BorderSide(),
                          right: BorderSide(),
                          bottom: BorderSide(),
                        ),
                      ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Usuario: '),
                                  Row(
                                    children: [
                                      Text(personas[index].nombre),
                                      const Text(' '),
                                      Text(personas[index].apellido),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.update_sharp),
                                    onPressed: () async {
                                      editarPersona(personas[index]);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () async {
                                      await hiveData.deletePersonas(personas[index].key);
                                      
                                      await getData();
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}
