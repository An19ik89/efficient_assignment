import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart' as recordPackage;

class FeedBackPage extends StatefulWidget {
  @override
  _FeedBackPageState createState() => _FeedBackPageState();
}

class _FeedBackPageState extends State<FeedBackPage> {
  File? _image;
  late AudioPlayer _audioPlayer;
  bool _isRecording = false;
  bool _isPlaying = false;
  String _audioFilePath = '';
  final record = recordPackage.AudioRecorder();


  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _startRecording() async {
    // if (await PermissionsPlugin.requestPermissions([
    //   Permission.RECORD_AUDIO,
    //   Permission.WRITE_EXTERNAL_STORAGE,
    // ])) {
      String path = await getTemporaryDirectory().then((dir) => '${dir.path}/recording.wav');
      await record.start(const recordPackage.RecordConfig(),path: path.toString());
      setState(() {
        _isRecording = true;
        _audioFilePath = path;
      });
   // }
  }

  Future<void> _stopRecording() async {
    await record.stop();
    setState(() {
      _isRecording = false;
    });
  }

  Future<void> _playRecording() async {
    if (!_isPlaying) {
      await _audioPlayer.play(_audioFilePath, isLocal: true);
      setState(() {
        _isPlaying = true;
      });
    } else {
      await _audioPlayer.stop();
      setState(() {
        _isPlaying = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Enter Text'),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text('Pick Photo'),
                ),
                SizedBox(width: 16),
                _image != null
                    ? Image.file(
                  _image!,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                )
                    : Container(),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                _isRecording
                    ? IconButton(
                  icon: Icon(Icons.stop),
                  onPressed: _stopRecording,
                )
                    : IconButton(
                  icon: Icon(Icons.mic),
                  onPressed: _startRecording,
                ),
                SizedBox(width: 16),
                _audioFilePath.isNotEmpty
                    ? ElevatedButton(
                  onPressed: _playRecording,
                  child: Text(_isPlaying ? 'Stop Playing' : 'Play Recording'),
                )
                    : Container(),
                SizedBox(width: 16),
                _audioFilePath.isNotEmpty
                    ? Text('Recorded File: ${_audioFilePath.split('/').last}')
                    : Container(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}