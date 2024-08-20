class Products {
  String? status;
  List<Data>? data;

  Products({this.status, this.data});

  Products.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? idp;
  String? name;
  String? price;
  String? image;
  String? detailsImage;
  String? catagory;
  String? trend;

  Data(
      {this.idp,
        this.name,
        this.price,
        this.image,
        this.detailsImage,
        this.catagory,
        this.trend});

  Data.fromJson(Map<String, dynamic> json) {
    idp = json['idp'];
    name = json['name'];
    price = json['price'];
    image = json['image'];
    detailsImage = json['details_image'];
    catagory = json['catagory'];
    trend = json['trend'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idp'] = this.idp;
    data['name'] = this.name;
    data['price'] = this.price;
    data['image'] = this.image;
    data['details_image'] = this.detailsImage;
    data['catagory'] = this.catagory;
    data['trend'] = this.trend;
    return data;
  }
}