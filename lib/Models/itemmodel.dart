class itemmodel {
  String? idp;
  String? name;
  String? price;
  String? image;
  String? detailsImage;
  String? catagory;

  itemmodel(
      {this.idp,
        this.name,
        this.price,
        this.image,
        this.detailsImage,
        this.catagory});

  itemmodel.fromJson(Map<String, dynamic> json) {
    idp = json['idp'];
    name = json['name'];
    price = json['price'];
    image = json['image'];
    detailsImage = json['details_image'];
    catagory = json['catagory'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idp'] = idp;
    data['name'] = name;
    data['price'] = price;
    data['image'] = image;
    data['details_image'] = detailsImage;
    data['catagory'] = catagory;
    return data;
  }
}