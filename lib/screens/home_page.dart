import 'package:e_commerce_app/controllers/product_controlers.dart';
import 'package:e_commerce_app/globals/all_products.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import '../helpers/db_helpers.dart';
import '../models/product_models.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isDark = false;

  ProductController productController = Get.put(ProductController());

  Future? getData;

  @override
  void initState() {
    getData = DBHelper.dbHelper.fetchAllRecode();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading:  IconButton(
          onPressed: () {
            Get.changeTheme(
                Get.isDarkMode ? ThemeData.light() : ThemeData.dark());
            setState(() {});
          },
          icon: (Get.isDarkMode)
              ? const Icon(Icons.dark_mode)
              : const Icon(Icons.light_mode_outlined),
        ),
        title: Text(
          "Surat, GJ",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed("/CartPage");
            },
            icon: const Icon(Icons.shopping_cart_outlined),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

              ],
            ),
            SizedBox(height: h * 0.02),
            const Text("Hi Zeel",
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.green,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: h * 0.016),
            Text(
              "Find Your Food",
              style: TextStyle(
                fontSize:32,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: h * 0.02),
            Container(
              height: h * 0.065,
              decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  SizedBox(width: w * 0.01),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: const Icon(Icons.search, color: Colors.green),
                  ),
                  const Text(
                    " Search Food",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: h * 0.02),
            FutureBuilder(
              future: getData,
              builder: (BuildContext context, AsyncSnapshot snapShot) {
                if (snapShot.hasError) {
                  return Center(
                    child: Text(
                      "Error : ${snapShot.error}",
                    ),
                  );
                } else if (snapShot.hasData) {
                  List<ProductDB> data = snapShot.data;

                  return Expanded(
                    child: GridView.builder(
                      itemCount: Global.food.length,
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent:
                            MediaQuery.of(context).size.width / 2,
                        mainAxisExtent: 300,
                      ),
                      itemBuilder: (context, i) => Padding(
                        padding: const EdgeInsets.all(5),
                        child: Card(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(25),
                            ),
                          ),
                          elevation: 5,
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                height: h * 0.6,
                                child: Column(
                                  children: [
                                    const SizedBox(height: 10),
                                    Container(
                                      height: 180,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            const BorderRadius.vertical(
                                          top: Radius.circular(25),
                                        ),
                                        image: DecorationImage(
                                          image: AssetImage(
                                              "${Global.food[i].image}"),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          "RS: ${Global.food[i].price}",
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const Text(
                                          "30min",
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "${Global.food[i].name}",
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        const Spacer(),
                                        InkWell(
                                          onTap: () {
                                            productController.addProduct(
                                                product: Global.food[i]);
                                          },
                                          child: Container(
                                            height: 50,
                                            width: 50,
                                            decoration: const BoxDecoration(
                                              color: Colors.green,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(25),
                                                bottomRight:
                                                    Radius.circular(25),
                                              ),
                                            ),
                                            child: const Icon(
                                              Icons.add,
                                              color: Colors.white,
                                              size: 30,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Column(
// mainAxisAlignment: MainAxisAlignment.center,
// children: [

// ],
// ),
