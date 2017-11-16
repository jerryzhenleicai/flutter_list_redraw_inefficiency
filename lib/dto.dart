

class AssetSummary {

  final String city;
  final int price;
  final int id;

  const AssetSummary({ this.city, this.price, this.id });

  AssetSummary.fromJson(json) :
    city = json['city'],
    price = json['list_price'],
    id = json['id'];
}

