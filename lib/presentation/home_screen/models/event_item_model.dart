/// This class is used in the [event_item_widget] screen.
class EventItemModel {
  EventItemModel({
    this.name,
    this.description,
    this.location,
    this.date,
    this.image,
    this.id,
  }) {
    name = name ?? "undefined";
    description = description ?? "undefined";
    location = location ?? "undefined";
    date = date ?? "undefined";
    image = image ?? "undefined";
    id = id ?? "undefined";
  }

  String? name;

  String? description;

  String? location;

  String? date;

  String? image;

  String? id;
}
