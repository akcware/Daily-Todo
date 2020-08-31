class Todo {
  int _id;
  String _todo;
  String _date;

  Todo(this._todo, this._date);
  Todo.withId(this._id, this._todo, this._date);

  int get id => _id;
  String get todo => _todo;
  String get date => _date;

  set todo(String newTodo) => this._todo = newTodo;
  set date(String newDate) => this._date = newDate;

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();

    if (id != null) map["id"] = _id;

    map["todo"] = _todo;
    map["date"] = _date;
  
    return map;
  }

  Todo.fromMap(Map<String, dynamic> map) {
    this._id = map["id"];
    this._todo = map["todo"];
    this._date = map["date"];
  }
}
