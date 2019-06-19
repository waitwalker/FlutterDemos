import 'package:flutter/material.dart';

class Product {
  final String title;
  final String desciption;
  final int idnex;
  Product(this.title,this.desciption,this.idnex);
}

void main() {
  runApp(MaterialApp(
    title: "导航数据传递",
    home: ProductList(
      products:List.generate(20, (i)=>Product("商品 $i","这是一个商品详情,编号为$i",i))
    ),
  ));
}

class ProductList extends StatelessWidget {
  final List<Product> products;
  ProductList({Key key, @required this.products}):super(key:key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("商品列表"),
      ),
      body: ListView.builder(
        itemCount: this.products.length,
        itemBuilder: (context, index){
          return SingleItem(product: products[index],);
        },
      ),
    );
  }
}

class SingleItem extends StatelessWidget {

  final Product product;
  SingleItem({Key key,this.product}):super(key:key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListTile(
      title: Text(this.product.title),
      subtitle: Text(this.product.desciption),
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>
          ProductDetail(product: product,)
        ));
      },
    );
  }
}

class ProductDetail extends StatelessWidget {

  final Product product;
  ProductDetail({Key key, this.product}):super(key : key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(this.product.title),
      ),
      body: Center(
        child: Text(this.product.desciption),
      ),
    );
  }
}