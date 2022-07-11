// ignore_for_file: prefer_typing_uninitialized_variables

class WallpapersModel {
  late var id;
  late var image;

  WallpapersModel(this.id, this.image);

  WallpapersModel.fromJson(Map json) {
    id = json['id'];
    image = json['image'];
  }

  Map toJson() {
    return {'id': id, 'image': image};
  }
}
