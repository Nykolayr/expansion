/// Класс для хранения данных о пользователе в игре.
/// Содержит информацию об ID, имени, аватаре, очках и прогрессе по картам.
/// Также флаги для отслеживания статуса вступления и регистрации.
class UserGame {
  int id; // id игрока
  String name; // имя игрока
  String photoURL; // ссылка на аватар
  int scoreClassic; // общее количество очков в компании классика
  int scoreRandom; // общее количество очков  в компании рандом
  int scoreTower; // общее количество очков в компании башни
  int mapClassic; // номер карты в компании классика
  int mapRandom; // номер карты в компании рандом
  int mapTower; // номер карты в компании башни
  bool isBegin = true; // было ли вступление
  bool isRegistration = false; // была ли регистрация
  String uid; // uid игрока в гугл
  String email; // email игрока
  String phone; // телефон игрока
  String pass; // пароль игрока

  UserGame({
    this.id = 0,
    this.name = 'Гость',
    this.photoURL = 'assets/avatar_icon.png',
    this.scoreClassic = 0,
    this.scoreRandom = 0,
    this.scoreTower = 0,
    this.mapClassic = 1,
    this.mapRandom = 1,
    this.mapTower = 1,
    this.isBegin = true,
    this.isRegistration = false,
    this.uid = '',
    this.email = '',
    this.phone = '',
    this.pass = '',
  });

  factory UserGame.fromJson(Map<String, dynamic> json) {
    return UserGame(
      id: json['id'] as int,
      name: json['name'] as String,
      photoURL: json['photoURL'] as String,
      scoreClassic: json['score_classic'] as int,
      scoreRandom: json['score_random'] as int,
      scoreTower: json['score_tower'] as int,
      mapClassic: json['map_classic'] as int,
      mapRandom: json['map_random'] as int,
      mapTower: json['map_tower'] as int,
      isBegin: json['is_begin'] as bool,
      isRegistration: json['is_registration'] as bool,
      uid: json['uid'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      pass: json['pass'] as String,
    );
  }
  UserGame copyWith({
    int? id,
    String? name,
    String? photoURL,
    int? scoreClassic,
    int? scoreRandom,
    int? scoreTower,
    int? mapClassic,
    int? mapRandom,
    int? mapTower,
    bool? isBegin,
    bool? isRegistration,
    String? uid,
    String? email,
    String? phone,
    String? pass,
  }) {
    return UserGame(
      id: id ?? this.id,
      name: name ?? this.name,
      photoURL: photoURL ?? this.photoURL,
      scoreClassic: scoreClassic ?? this.scoreClassic,
      scoreRandom: scoreRandom ?? this.scoreRandom,
      scoreTower: scoreTower ?? this.scoreTower,
      mapClassic: mapClassic ?? this.mapClassic,
      mapRandom: mapRandom ?? this.mapRandom,
      mapTower: mapTower ?? this.mapTower,
      isBegin: isBegin ?? this.isBegin,
      isRegistration: isRegistration ?? this.isRegistration,
      uid: uid ?? this.uid,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      pass: pass ?? this.pass,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'photoURL': photoURL,
        'score_classic': scoreClassic,
        'score_random': scoreRandom,
        'score_tower': scoreTower,
        'map_classic': mapClassic,
        'map_random': mapRandom,
        'map_tower': mapTower,
        'is_begin': isBegin,
        'is_registration': isRegistration,
        'uid': uid,
        'email': email,
        'phone': phone,
        'pass': pass,
      };
}
