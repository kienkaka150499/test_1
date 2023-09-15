import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_radio_player/flutter_radio_player.dart';
import 'package:flutter_radio_player/models/frp_source_modal.dart';
import 'package:radio_browser_flutter/radio_browser_flutter.dart';
import 'package:test_1/radio_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await RadioBrowserClient.initialize("https://");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue,
        ).copyWith(
          secondary: Colors.pink,
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  FlutterRadioPlayer _frp = FlutterRadioPlayer();

  List<MediaSources> _source = [];

  List<MediaSources> get source => _source;

  late FRPSource frpSource = FRPSource(mediaSources: source);

  @override
  void initState() {
    _frp.initPlayer();
    super.initState();
  }

  Future<List<RadioModel>> fetch() async {
    try {
      var res = await Dio().postUri(
          Uri.parse(
              'https://nl1.api.radio-browser.info/json/stations/bycountryexact/vietnam'),
          data: {'limit': 100, 'offset': 0});
      if (res.data != null) {
        return res.data.map<RadioModel>((e) => RadioModel.fromMap(e)).toList();
      }
      // log('${res.data.length}');
    } catch (e, s) {
      log('$s');
      return [];
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<RadioModel>>(
        future: fetch(),
        builder: ((context, AsyncSnapshot<List<RadioModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            log('ádawfasfw');
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Text(snapshot.error?.toString() ?? "Something went wrong");
          }
          var data = snapshot.data!;
          _source = data.map<MediaSources>((e) => e.toMediaSource()).toList();
          _frp.addMediaSources(frpSource);
          return ListView.builder(
            itemBuilder: (_, index) => ListTile(
              title: Text(data[index].name),
              subtitle: Text(data[index].location),
              trailing: IconButton(
                icon: Icon(Icons.play_arrow),
                onPressed: ()=>_frp.playOrPause(),
              ),
            ),
            itemCount: data.length,
          );
        }),
      ),
    );
  }
}
