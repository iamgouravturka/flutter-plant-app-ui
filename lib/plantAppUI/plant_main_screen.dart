import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plant_app_ui/plantAppUI/plant_screen.dart';

import 'models/plant_model.dart';

class PlantMainScreen extends StatefulWidget {
  @override
  _PlantMainScreenState createState() => _PlantMainScreenState();
}

class _PlantMainScreenState extends State<PlantMainScreen>
    with SingleTickerProviderStateMixin {
  //* --------------------Tab And PageView Components------------------
  TabController _tabController;
  PageController _pageController;
  int _selectedPage = 0;

//*---------------------------Selected Page----------------------------
  _pageSelector(int index) {
    final plantsData = plants[index];

//*---------------------------Animation Stuff---------------------------
    return AnimatedBuilder(
      animation: _pageController,
      builder: (BuildContext context, Widget widget) {
        double value = 1;
        if (_pageController.position.haveDimensions) {
          value = _pageController.page - index;
          value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);
        }

        return Center(
          child: SizedBox(
            height: Curves.easeInOut.transform(value) * 500.0,
            width: Curves.easeInOut.transform(value) * 400.0,
            child: widget,
          ),
        );
      },

      //*-------------------Click Handle on page view image------------------------
      child: GestureDetector(
        onTap: () => Navigator.push(
            context,

            //*-------------------Navigate to next page----------------------------
            MaterialPageRoute(
                builder: (_) => PlantScreen(
                      plant: plantsData,
                    ))),

        //*----------------------Plant image view----------------------------------
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color: Color(0xFF32A060),
                  borderRadius: BorderRadius.circular(20.0)),
              margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 30.0),
              child: Stack(
                children: <Widget>[
                  Center(
                    child: Hero(
                      tag: plants[index].imageUrl,
                      child: Image(
                          height: 280.0,
                          width: 280.0,

                          //*---------------------------Plant image----------------
                          image: AssetImage('assets/images/plant$index.png'),
                          fit: BoxFit.cover),
                    ),
                  ),
                  Positioned(
                    top: 30.0,
                    right: 30.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'FROM',
                          style: TextStyle(color: Colors.white, fontSize: 15.0),
                        ),

                        //*---------------------------Plant Price-------------------
                        Text(
                          '\$${plantsData.price}',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25.0,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 30.0,
                    bottom: 40.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          plantsData.category.toUpperCase(),
                          style: TextStyle(color: Colors.white, fontSize: 15.0),
                        ),
                        SizedBox(height: 5.0),

                        //*---------------------------Plant Name--------------------
                        Text(
                          plantsData.name,
                          style: TextStyle(color: Colors.white, fontSize: 15.0),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),

            //*---------------------------Shppping Cart--------------------------------
            Positioned(
              bottom: 5.0,
              child: RawMaterialButton(
                padding: EdgeInsets.all(15.0),
                shape: CircleBorder(),
                elevation: 2.0,
                fillColor: Colors.black,
                child: Icon(
                  Icons.add_shopping_cart,
                  color: Colors.white,
                  size: 30.0,
                ),
                onPressed: () => 'Add To Cart',
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _tabController = TabController(initialIndex: 0, length: 5, vsync: this);
    _pageController = PageController(initialPage: 0, viewportFraction: 0.8);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 60.0),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0),

              //*------------------Top Bar Menu And Shopping Icon-------------------
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Icon(
                    Icons.menu,
                    size: 30.0,
                    color: Colors.grey,
                  ),
                  Icon(
                    Icons.shopping_cart,
                    size: 30.0,
                    color: Colors.black,
                  )
                ],
              ),
            ),
            SizedBox(height: 20.0),

            //*------------------Top Pics Text----------------------------------
            Padding(
              padding: EdgeInsets.only(left: 30.0),
              child: Text(
                'Top Picks',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(height: 20.0),

            //*-------------------------Tab Bar Setup---------------------------
            TabBar(
              controller: _tabController,
              indicatorColor: Colors.transparent,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey.withOpacity(0.6),
              labelPadding: EdgeInsets.symmetric(horizontal: 35.0),
              isScrollable: true,
              tabs: <Widget>[
                Tab(
                  child: Text(
                    'Top',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Tab(
                  child: Text(
                    'Outdoor',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Tab(
                  child: Text(
                    'Indoor',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Tab(
                  child: Text(
                    'New Arrival',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Tab(
                  child: Text(
                    'Limited Edition',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
            SizedBox(height: 20.0),

            //*-----------------------Main Page View Setup-----------------------------
            Container(
              height: 500.0,
              width: double.infinity,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (int index) {
                  setState(() {
                    _selectedPage = index;
                  });
                },
                itemCount: plants.length,
                itemBuilder: (context, index) {
                  return _pageSelector(index);
                },
              ),
            ),

            //*-----------------------Description Text-----------------------------
            Padding(
              padding: EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Description',
                    style:
                        TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    plants[_selectedPage].description,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black87,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
