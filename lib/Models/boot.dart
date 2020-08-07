
class Boot
{
  double width=0;
  double height=0;
  double size=1;
  int sizeType=0;
  String description="";
  String modelName="";
  double price=0;
  int material=0;
  Boot({this.width, this.height, this.size, this.modelName, this.material, this.sizeType, this.description, this.price});

  Map<String, dynamic> toMap() {
    return{
      "width": width,
      "height": height,
      "size": size,
      "sizeType": sizeType,
      "description": description,
      "modelName": modelName,
      "price": price,
      "material": material,
    };
  }
}