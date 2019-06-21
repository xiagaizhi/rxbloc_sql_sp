class TestData {
  String data;
  int time;
  int id;

  TestData();

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['data'] = data;
    map['time'] = time;
    map['id'] = id;
    return map;
  }

  static TestData fromMap(Map<String, dynamic> map) {
    TestData user = new TestData();
    user.data = map['data'];
    user.time = map['time'];
    user.id = map['id'];
    return user;
  }

  static List<TestData> fromMapList(dynamic mapList) {
    List<TestData> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }
  TestData.fromJson(Map<String, dynamic> json)
      : data = json['data'],
        time = json['time'],
        id = json['id'];

  Map<String, dynamic> toJson() => {
    'data': data,
    'time': time,
    'id': id,
  };
}