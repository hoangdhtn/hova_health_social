class SlotsAvailable {
  int index;
  String begin_at;
  String end_at;

  SlotsAvailable({this.index, this.begin_at, this.end_at});

  factory SlotsAvailable.fromJson(Map<String, dynamic> json) {
    return SlotsAvailable(
      index: json['index'],
      begin_at: json['begin_at'],
      end_at: json['end_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['index'] = this.index;
    data['begin_at'] = this.begin_at;
    data['end_at'] = this.end_at;
  }
}
