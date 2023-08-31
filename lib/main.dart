import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:storage_encryption/model/example_model.dart';
import 'package:storage_encryption/model/example_model_adapter.dart';
import 'package:storage_encryption/services/encrypt_service.dart';
import 'package:storage_encryption/services/hive_service.dart';
import 'package:storage_encryption/services/secure_shared_preference_service.dart';
import 'package:storage_encryption/services/secure_storage_service.dart';
import 'package:storage_encryption/services/shared_preference_service.dart';
import 'package:storage_encryption/services/timer_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //reset all saved storage in Current Data Storage
  SharedPreferencesService().clear();

  //init encyrpter
  EncryptService().init();

  //init secure storage
  SecureStorageService().init();

  //init hive
  await Hive.initFlutter();
  Hive.registerAdapter(ExampleModelAdapter()); // Register your adapter
  final encryptionKey = Hive.generateSecureKey();
  HiveService().initCipher(chiper: HiveAesCipher(encryptionKey));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Storage Encryption',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Storage Encryption'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _textEditingController = TextEditingController();
  List<String> options = [
    'String',
    'Boolean',
    'Integer',
    'List<String>',
    'Object',
  ];

  Map<String, String> savedStorage = {};
  Duration normalTimeElapse = const Duration(milliseconds: 0);
  Duration option1TimeElapse = const Duration(milliseconds: 0);
  Duration option2TimeElapse = const Duration(milliseconds: 0);
  Duration option3TimeElapse = const Duration(milliseconds: 0);
  Duration option4TimeElapse = const Duration(milliseconds: 0);

  String? selectedValue;

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                title: Text(widget.title),
                centerTitle: true,
                floating: true,
              )
            ];
          },
          body: Stack(
            children: [
              Positioned.fill(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: FractionallySizedBox(
                    widthFactor: 0.9,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: _buildInput(),
                        ),
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: _buildData(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _buildTimerBoard(),
              )
            ],
          )),
    );
  }

  _buildInput() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextField(
          controller: _textEditingController,
          decoration: InputDecoration(
            hintText: 'Enter your text here',
            labelText: 'Text to save',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(width: 2.0),
            ),
          ),
          maxLines: null,
        ),
        const SizedBox(height: 10),
        DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.deepPurple.shade100,
            borderRadius: BorderRadius.circular(50),
          ),
          child: DropdownButton<String>(
            value: selectedValue,
            onChanged: (value) => setState(() {
              selectedValue = value;
            }),
            isExpanded: true,
            underline: Container(),
            alignment: Alignment.center,
            hint: const Text('Choose type data to save'),
            items: options.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                alignment: Alignment.center,
                child: Text("Save as $value"),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 5),
        SizedBox(
          width: double.maxFinite,
          child: ElevatedButton(onPressed: _onSave, child: const Text("Save")),
        ),
        const SizedBox(height: 5),
        SizedBox(
          width: double.maxFinite,
          child:
              OutlinedButton(onPressed: _onClear, child: const Text('Clear')),
        ),
      ],
    );
  }

  _buildData() {
    return Card(
      child: SizedBox(
        width: double.maxFinite,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('Current Data Storage',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  IconButton(
                    onPressed: _onDeleteAll,
                    icon: const Icon(Icons.delete, color: Colors.red),
                  )
                ],
              ),
              Column(children: _buildSaveStorage(savedStorage)),
            ],
          ),
        ),
      ),
    );
  }

  _buildSaveStorage(Map<String, String> data) {
    List<Widget> widgets = [];

    savedStorage.forEach((key, value) {
      widgets.add(_buildContent(key, value));
    });

    return widgets;
  }

  _buildContent(String key, String value) {
    return Center(
      child: Card(
        color: Colors.deepPurple,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Key: $key",
                        style: const TextStyle(color: Colors.white)),
                    Text(
                      "Value: $value ",
                      overflow: TextOverflow.visible,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => _onDelete(key),
                icon: const Icon(Icons.delete, color: Colors.red),
              )
            ],
          ),
        ),
      ),
    );
  }

  _buildTimerBoard() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      color: Colors.deepPurple.shade200,
      child: Column(
        children: [
          const Text(
            "Write Time Elapse",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          _buildTimeRow("Normal", "${normalTimeElapse.inMicroseconds} us"),
          _buildTimeRow("Option 1", "${option1TimeElapse.inMicroseconds} us"),
          _buildTimeRow("Option 2", "${option2TimeElapse.inMicroseconds} us"),
          _buildTimeRow("Option 3", "${option3TimeElapse.inMicroseconds} us"),
          _buildTimeRow("Option 4", "${option4TimeElapse.inMicroseconds} us"),
        ],
      ),
    );
  }

  _buildTimeRow(String title, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(time),
        ],
      ),
    );
  }

  _displayPopUp(String text) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Warning'),
            content: Text(text),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
            ],
          );
        });
  }

  _onSave() {
    if (_textEditingController.text.isEmpty) {
      _displayPopUp("Please enter data to save");
      return;
    }
    if (selectedValue == null) {
      _displayPopUp("Please choose type data to save");
      return;
    }

    debugPrint("Selected Value: $selectedValue");
    debugPrint("Text to save: ${_textEditingController.text}");

    String key = DateTime.now().millisecondsSinceEpoch.toString();

    switch (selectedValue) {
      case 'String':
        _saveAsString(key, _textEditingController.text);
        break;
      case 'Boolean':
        _saveAsBool(key, _textEditingController.text);
        break;
      case 'Integer':
        _saveAsInt(key, _textEditingController.text);
        break;
      case 'List<String>':
        _saveAsStringList(key, _textEditingController.text);
        break;
      case 'Object':
        _saveAsObject(key, _textEditingController.text);
        break;
    }
  }

  _onClear() {
    selectedValue = null;
    _textEditingController.clear();
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {});
  }

  _onDeleteAll() {
    SharedPreferencesService().clear();
    SecureSharedPreferenceService().clearAll();
    SecureStorageService().deleteAll();
    savedStorage.clear();
    setState(() {});
  }

  _onDelete(String key) {
    SharedPreferencesService().remove(key);
    SecureStorageService().delete(key);
    HiveService().delete(key);
    savedStorage.remove(key);
    setState(() {});
  }

  _saveAsString(String key, String text) async {
    TimerService().captureNormal(
      () async {
        await SharedPreferencesService().saveString(key, text);
      },
    );
    normalTimeElapse = TimerService().option0;
    savedStorage[key] = text;

    //option 1
    TimerService().captureOption1(
      () async {
        final encryptedData = await EncryptService().encrypt(text);
        await SharedPreferencesService()
            .saveString("encrypt_$key", encryptedData);
      },
    );
    option1TimeElapse = TimerService().option1;

    //option 2
    SecureSharedPreferenceService().saveString(key, text);
    option2TimeElapse = TimerService().option2;

    //option 3
    SecureStorageService().write(key, text);
    option3TimeElapse = TimerService().option3;

    //option 4
    HiveService().write(key, text);
    option4TimeElapse = TimerService().option4;

    setState(() {});
  }

  _saveAsBool(String key, String text) async {
    bool? data;

    if (text.toLowerCase().trim() == "false") {
      data = false;
    } else if (text.toLowerCase().trim() == "true") {
      data = true;
    } else {
      _displayPopUp("Only accept false or true!");
      return;
    }

    TimerService().captureNormal(
      () async {
        await SharedPreferencesService().saveBool(key, data!);
      },
    );
    normalTimeElapse = TimerService().option0;
    savedStorage[key] = text;

    //option 1
    TimerService().captureOption1(
      () async {
        final encryptedData = await EncryptService().encrypt(text);
        await SharedPreferencesService()
            .saveString("encrypt_$key", encryptedData);
      },
    );
    option1TimeElapse = TimerService().option1;

    //option 2
    SecureSharedPreferenceService().saveBool(key, data);
    option2TimeElapse = TimerService().option2;

    //option 3
    SecureStorageService().write(key, text);
    option3TimeElapse = TimerService().option3;

    //option 4
    HiveService().write(key, data);
    option4TimeElapse = TimerService().option4;

    setState(() {});
  }

  _saveAsInt(String key, String text) async {
    int? data = int.tryParse(text);
    if (data == null) {
      _displayPopUp("Not integer!");
      return;
    }

    TimerService().captureNormal(
      () async {
        await SharedPreferencesService().saveInt(key, data);
      },
    );
    normalTimeElapse = TimerService().option0;
    savedStorage[key] = text;

    //option 1
    TimerService().captureOption1(
      () async {
        final encryptedData = await EncryptService().encrypt(text);
        await SharedPreferencesService()
            .saveString("encrypt_$key", encryptedData);
      },
    );
    option1TimeElapse = TimerService().option1;

    //option 2
    SecureSharedPreferenceService().saveInt(key, data);
    option2TimeElapse = TimerService().option2;

    //option 3
    SecureStorageService().write(key, text);
    option3TimeElapse = TimerService().option3;

    //option 4
    HiveService().write(key, data);
    option4TimeElapse = TimerService().option4;

    setState(() {});
  }

  _saveAsStringList(String key, String text) async {
    text.replaceAll("[", "").replaceAll("]", "");
    List<String> data = text.split(",");

    if (data.isEmpty) {
      _displayPopUp(
          "Accept only string and separated by commas, eg. [\"apple\",\"mango\",\"orange\"]");
      return;
    }
    TimerService().captureNormal(
      () async {
        await SharedPreferencesService().saveStringList(key, data);
      },
    );
    normalTimeElapse = TimerService().option0;
    savedStorage[key] = text;

    //option 1
    TimerService().captureOption1(
      () async {
        final encryptedData = await EncryptService().encrypt(data.join(","));
        await SharedPreferencesService()
            .saveString("encrypt_$key", encryptedData);
      },
    );
    option1TimeElapse = TimerService().option1;

    //option 2
    SecureSharedPreferenceService().saveStringList(key, data);
    option2TimeElapse = TimerService().option2;

    //option 3
    SecureStorageService().write(key, data.join(","));
    option3TimeElapse = TimerService().option3;

    //option 4
    HiveService().write(key, data);
    option4TimeElapse = TimerService().option4;

    setState(() {});
  }

  _saveAsObject(String key, String text) async {
    try {
      ExampleModel model = exampleModelFromJson(text);
      TimerService().captureNormal(
        () async {
          await SharedPreferencesService()
              .saveString(key, exampleModelToJson(model));
        },
      );
      normalTimeElapse = TimerService().option0;
      savedStorage[key] = text;

      //option 1
      TimerService().captureOption1(
        () async {
          final encryptedData =
              await EncryptService().encrypt(exampleModelToJson(model));
          await SharedPreferencesService()
              .saveString("encrypt_$key", encryptedData);
        },
      );
      option1TimeElapse = TimerService().option1;

      //option 2
      SecureSharedPreferenceService().saveObject(key, model);
      option2TimeElapse = TimerService().option2;

      //option 3
      SecureStorageService().write(key, exampleModelToJson(model));
      option3TimeElapse = TimerService().option3;

      //option 4
      HiveService().write(key, model);
      option4TimeElapse = TimerService().option4;

      setState(() {});
    } catch (e) {
      _displayPopUp(e.toString());
    }
  }
}
