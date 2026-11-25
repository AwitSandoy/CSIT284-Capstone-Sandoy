import 'package:flutter/material.dart';
import '../models/class_schedule.dart';
import '../models/realtime_database_service.dart';

class ClassFormScreen extends StatefulWidget {
  final ClassSchedule? existingClass;

  const ClassFormScreen({super.key, this.existingClass});

  @override
  State<ClassFormScreen> createState() => _ClassFormScreenState();
}

class _ClassFormScreenState extends State<ClassFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _databaseService = RealtimeDatabaseService();
  late final TextEditingController _codeController;
  late final TextEditingController _nameController;
  late final TextEditingController _startController;
  late final TextEditingController _endController;
  late final TextEditingController _roomController;
  late final TextEditingController _instructorController;
  String _selectedDay = 'Monday';

  final List<String> _days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];

  @override
  void initState() {
    super.initState();
    final item = widget.existingClass;
    _codeController = TextEditingController(text: item?.subjectCode ?? '');
    _nameController = TextEditingController(text: item?.subjectName ?? '');
    _startController = TextEditingController(text: item?.startTime ?? '08:00 AM');
    _endController = TextEditingController(text: item?.endTime ?? '10:00 AM');
    _roomController = TextEditingController(text: item?.room ?? '');
    _instructorController = TextEditingController(text: item?.instructor ?? '');
    if (item != null && _days.contains(item.dayOfWeek)) {
      _selectedDay = item.dayOfWeek;
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _startController.dispose();
    _endController.dispose();
    _roomController.dispose();
    _instructorController.dispose();
    super.dispose();
  }

  Future<void> _saveClass() async {
    if (!_formKey.currentState!.validate()) return;
    final schedule = ClassSchedule(
      id: widget.existingClass?.id ?? '',
      subjectCode: _codeController.text.trim(),
      subjectName: _nameController.text.trim(),
      dayOfWeek: _selectedDay,
      startTime: _startController.text.trim(),
      endTime: _endController.text.trim(),
      room: _roomController.text.trim(),
      instructor: _instructorController.text.trim(),
    );
    if (widget.existingClass == null) {
      await _databaseService.addClass(schedule);
    } else {
      await _databaseService.updateClass(schedule);
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingClass != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Class Schedule' : 'Add Class Schedule'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _codeController,
                decoration: const InputDecoration(
                  labelText: 'Subject Code (e.g., CSIT-284)',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Subject Name',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _selectedDay,
                decoration: const InputDecoration(
                  labelText: 'Day of Week',
                  border: OutlineInputBorder(),
                ),
                items: _days
                    .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedDay = val);
                },
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _startController,
                      decoration: const InputDecoration(
                        labelText: 'Start Time',
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _endController,
                      decoration: const InputDecoration(
                        labelText: 'End Time',
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _roomController,
                decoration: const InputDecoration(
                  labelText: 'Room (e.g., NGE 102)',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _instructorController,
                decoration: const InputDecoration(
                  labelText: 'Instructor',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: _saveClass,
                icon: const Icon(Icons.save),
                label: Text(isEditing ? 'Update Class' : 'Save Class'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}