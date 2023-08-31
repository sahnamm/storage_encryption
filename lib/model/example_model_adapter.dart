import 'package:hive/hive.dart';
import 'package:storage_encryption/model/example_model.dart';

class ExampleModelAdapter extends TypeAdapter<ExampleModel> {
  @override
  final int typeId = 0; // Unique type ID for your model

  @override
  ExampleModel read(BinaryReader reader) {
    // Deserialize your object here
    return ExampleModel.fromMap(reader.readMap());
  }

  @override
  void write(BinaryWriter writer, ExampleModel obj) {
    // Serialize your object here
    writer.writeMap(obj.toMap());
  }
}
