Map map2DB(Map data) {
  data.forEach((key, value) {
    if(value is DateTime) {
      data[key] = value.toIso8601String();
      return;
    }
  });
  return data;
}