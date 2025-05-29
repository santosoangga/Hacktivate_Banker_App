/// Model to parse data from/to NFC tag.
class Assignment {
  final String staffId;
  final String taskDate;
  final String taskStartTime;
  final String taskEndTime;

  Assignment({
    required this.staffId,
    required this.taskDate,
    required this.taskStartTime,
    required this.taskEndTime,
  });

  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      staffId: json['staff_id'],
      taskDate: json['task_date'],
      taskStartTime: json['task_start_time'],
      taskEndTime: json['task_end_time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'staff_id': staffId,
      'task_date': taskDate,
      'task_start_time': taskStartTime,
      'task_end_time': taskEndTime,
    };
  }
}
