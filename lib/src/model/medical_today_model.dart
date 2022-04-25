class MedicalToday {
  String name;
  String info;
  String time;
  bool completed;

  MedicalToday({
    this.name,
    this.info,
    this.time,
    this.completed,
  });

  MedicalToday.fromMap(Map map)
      : this.name = map['name'],
        this.info = map['info'],
        this.time = map['time'],
        this.completed = map['completed'];

  Map toMap() {
    return {
      'name': this.name,
      'info': this.info,
      'time': this.time,
      'completed': this.completed,
    };
  }
}
