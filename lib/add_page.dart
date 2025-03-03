import 'package:flutter/material.dart';
import 'yoga_pose_model.dart';

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String? _selectedExerciseType;
  final _durationController = TextEditingController();
  final _caloriesController = TextEditingController();
  String? _selectedDifficulty;
  DateTime? _selectedDate;
  final List<String> _exerciseTypes = ['Strength', 'Flexibility', 'Balance'];
  final List<String> _difficulties = ['Beginner', 'Intermediate', 'Advanced'];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(primary: const Color.fromARGB(255, 0, 251, 255)),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มท่าโยคะ / Add Yoga Pose'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'ชื่อท่าโยคะ / Pose Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.self_improvement),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกชื่อท่า / Please enter a name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedExerciseType,
                decoration: InputDecoration(
                  labelText: 'ประเภทการออกกำลังกาย / Exercise Type',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.directions_run),
                ),
                items: _exerciseTypes.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedExerciseType = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'กรุณาเลือกประเภท / Please select a type';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _durationController,
                decoration: InputDecoration(
                  labelText: 'ระยะเวลา (วินาที) / Duration (seconds)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.timer),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกระยะเวลา / Please enter duration';
                  }
                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
                    return 'กรุณากรอกตัวเลขที่ถูกต้อง / Enter a valid number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _caloriesController,
                decoration: InputDecoration(
                  labelText: 'แคลอรีที่เผาผลาญ / Calories Burned',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.local_fire_department),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกแคลอรี / Please enter calories';
                  }
                  if (int.tryParse(value) == null || int.parse(value) < 0) {
                    return 'กรุณากรอกตัวเลขที่ถูกต้อง / Enter a valid number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedDifficulty,
                decoration: InputDecoration(
                  labelText: 'ระดับความยาก / Difficulty',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.fitness_center),
                ),
                items: _difficulties.map((String difficulty) {
                  return DropdownMenuItem<String>(
                    value: difficulty,
                    child: Text(difficulty),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedDifficulty = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'กรุณาเลือกระดับ / Please select a difficulty';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ListTile(
                leading: Icon(Icons.calendar_today, color: Colors.purple),
                title: Text(
                  _selectedDate == null
                      ? 'เลือกวันที่ฝึก / Select Practice Date'
                      : 'วันที่ / Date: ${_selectedDate!.toLocal().toString().split(' ')[0]}',
                ),
                onTap: () => _selectDate(context),
                tileColor: Colors.grey[100],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate() && _selectedDate != null) {
                    final pose = YogaPoseModel(
                      name: _nameController.text,
                      exerciseType: _selectedExerciseType!,
                      duration: int.parse(_durationController.text),
                      calories: int.parse(_caloriesController.text),
                      difficulty: _selectedDifficulty!,
                      date: _selectedDate!,
                    );
                    Navigator.pop(context, pose);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('เพิ่มท่าโยคะสำเร็จ / Added successfully'),
                        backgroundColor: Colors.purple,
                      ),
                    );
                  } else if (_selectedDate == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('กรุณาเลือกวันที่ / Please select a date'),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  textStyle: TextStyle(fontSize: 16),
                ),
                child: Text('บันทึก / Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _durationController.dispose();
    _caloriesController.dispose();
    super.dispose();
  }
}