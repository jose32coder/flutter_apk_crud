import 'package:hive/hive.dart';

part 'personas.g.dart';

@HiveType(typeId: 0)
class Personas extends HiveObject{
  Personas({required this.nombre, required this.apellido});

  @HiveField(0)
  String nombre;

  @HiveField(1)
  String apellido;

  toLowerCase() {}

}