import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'yoga_pose_model.dart';
import 'add_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  List<YogaPoseModel> poses = [];
  int? _remainingTime;
  Timer? _timer;
  final AudioPlayer _audioPlayer = AudioPlayer();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  void _startPoseTimer(int duration, String difficulty) {
    setState(() {
      _remainingTime = duration;
    });
    _timer?.cancel();
    _animationController.repeat(reverse: true);
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime! > 0) {
          _remainingTime = _remainingTime! - 1;
        } else {
          timer.cancel();
          _remainingTime = null;
          _animationController.stop();
          _audioPlayer.play(AssetSource('sounds/complete.mp3'));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('ท่าสำเร็จแล้ว! / Pose completed!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      });
    });
  }

  void _playRandomPose() {
    if (poses.isNotEmpty) {
      final randomPose = poses[Random().nextInt(poses.length)];
      _startPoseTimer(randomPose.duration, randomPose.difficulty);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('ไม่มีท่าโยคะให้เล่น / No poses available'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  Color _getBackgroundColor(String? difficulty) {
    switch (difficulty) {
      case 'Beginner':
        return Colors.green.withOpacity(0.1);
      case 'Intermediate':
        return Colors.yellow.withOpacity(0.1);
      case 'Advanced':
        return Colors.red.withOpacity(0.1);
      default:
        return Colors.grey.withOpacity(0.1);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ท่าโยคะ / Yoga Pose'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.shuffle),
            onPressed: _playRandomPose,
            tooltip: 'สุ่มท่าโยคะ / Random Pose',
          ),
        ],
      ),
      body: Container(
        color: _remainingTime != null
            ? _getBackgroundColor(poses.isNotEmpty ? poses.last.difficulty : null)
            : Colors.white,
        child: poses.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.self_improvement, size: 80, color: Colors.purple),
                    SizedBox(height: 16),
                    Text(
                      'ยังไม่มีท่าโยคะ / No poses yet',
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    ),
                  ],
                ),
              )
            : Stack(
                children: [
                  ListView.builder(
                    padding: EdgeInsets.all(8),
                    itemCount: poses.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        key: Key(poses[index].name + index.toString()),
                        onDismissed: (direction) {
                          setState(() {
                            poses.removeAt(index);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('ลบท่าโยคะแล้ว / Pose removed'),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        },
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 20),
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                        child: Card(
                          elevation: 2,
                          margin: EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            leading: Icon(Icons.self_improvement, color: Colors.purple),
                            title: Text(
                              poses[index].exerciseType,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              'ระยะเวลา / Duration: ${poses[index].duration} วินาที / sec\nวันที่ / Date: ${poses[index].date.toLocal().toString().split(' ')[0]}',
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.play_arrow, color: Colors.purple),
                              onPressed: () {
                                _startPoseTimer(poses[index].duration, poses[index].difficulty);
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  if (_remainingTime != null)
                    Positioned(
                      bottom: 20,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: ScaleTransition(
                          scale: _scaleAnimation,
                          child: Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.purple.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Text(
                              'เหลือเวลา / Time left: $_remainingTime วินาที / sec',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newPose = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPage()),
          );
          if (newPose != null) {
            setState(() {
              poses.add(newPose);
            });
          }
        },
        backgroundColor: Colors.purple,
        child: Icon(Icons.add),
      ),
    );
  }
}