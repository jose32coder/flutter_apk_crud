import 'package:crud_flutter/personas.dart';
import 'package:hive/hive.dart';

class HiveData{
  const HiveData();

  Future<int> savePersonas(Personas persona) async{
    final Box<Personas> box = await Hive.openBox<Personas>('personas');
    return box.add(persona);
  }

  Future<List<Personas>> get personas async{
    final Box<Personas> box = await Hive.openBox<Personas>('personas');
    return box.values.toList();
  }
  Future<void> updatePersonas(int key, Personas nuevaPersona) async {
    final Box<Personas> box = await Hive.openBox<Personas>('personas');
    await box.put(key, nuevaPersona);
  }

  Future<void> deletePersonas(int key) async {
    final Box<Personas> box = await Hive.openBox<Personas>('personas');
    await box.delete(key);
  }
}