import 'package:connectivity/connectivity.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:covid19_tracker/app/services/api.dart';
import 'package:covid19_tracker/app/services/api_services.dart';
import 'package:covid19_tracker/app/services/connectivity.dart';
import 'package:covid19_tracker/widgets/count_cards.dart';
import 'package:covid19_tracker/widgets/dialog_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tabbar/tabbar.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = PageController();
  bool isLoading = false;
  Map _source = {ConnectivityResult.none: false};
  MyConnectivity _connectivity = MyConnectivity.instance;
  int _affectedCount,
      _deathCount,
      _recoveredCount,
      _activeCount,
      _seriousCount = 0;
  int _globeAffectedCount = 0,
      _globeDeathCount = 0,
      _globeRecoveredCount = 0,
      _globeActiveCount = 0,
      _globeSeriousCount = 0;

  void getCountryData(String countryName) async {
    setState(() {
      isLoading = true;
    });
    final apiService = APIService(API.sanbox());
    final accessToken = await apiService.getAccessToken();
    final affectedCount = await apiService.getEndpointData(
        accessToken: accessToken,
        endpoint: Endpoint.cases,
        country: countryName);
    final recoveredCount = await apiService.getEndpointData(
        accessToken: accessToken,
        endpoint: Endpoint.recovered,
        country: countryName);
    final deathCount = await apiService.getEndpointData(
        accessToken: accessToken,
        endpoint: Endpoint.deaths,
        country: countryName);
    final seriousCount = await apiService.getEndpointData(
        accessToken: accessToken,
        endpoint: Endpoint.critical,
        country: countryName);
    final activeCount = await apiService.getEndpointData(
        accessToken: accessToken,
        endpoint: Endpoint.active,
        country: countryName);
    setState(() {
      _affectedCount = affectedCount;
      _recoveredCount = recoveredCount;
      _deathCount = deathCount;
      _seriousCount = seriousCount;
      _activeCount = activeCount;
    });
    setState(() {
      isLoading = false;
    });
  }

  void getData() async {
    try {
      setState(() {
        isLoading = true;
      });
      final apiService = APIService(API.sanbox());
      final accessToken = await apiService.getAccessToken();
      final globeAffectedCount = await apiService.getEndpointData(
          accessToken: accessToken, endpoint: Endpoint.cases, country: "");
      final globeRecoveredCount = await apiService.getEndpointData(
          accessToken: accessToken, endpoint: Endpoint.recovered, country: "");
      final globeDeathCount = await apiService.getEndpointData(
          accessToken: accessToken, endpoint: Endpoint.deaths, country: "");
      final globeSeriousCount = await apiService.getEndpointData(
          accessToken: accessToken, endpoint: Endpoint.critical, country: "");
      final globeActiveCount = await apiService.getEndpointData(
          accessToken: accessToken, endpoint: Endpoint.active, country: "");

      setState(() {
        _globeAffectedCount = globeAffectedCount;
        _globeRecoveredCount = globeRecoveredCount;
        _globeDeathCount = globeDeathCount;
        _globeSeriousCount = globeSeriousCount;
        _globeActiveCount = globeActiveCount;
      });
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void checkContectivity() {
    _connectivity.initialise();
    _connectivity.myStream.listen((source) {
      setState(() => _source = source);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    getCountryData("india");
    checkContectivity();
  }

  @override
  Widget build(BuildContext context) {
    String string;
    switch (_source.keys.toList()[0]) {
      case ConnectivityResult.none:
        string = "Offline";
        break;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Stack(
              children: [
                Column(
                  children: [
                    buildHeaderContainer(),
                    buildStatisticsContainer(),
                    PreventionContainer()
                  ],
                ),
                string == 'Offline' ? DialogBox() : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container buildHeaderContainer() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
          color: Colors.deepPurple,
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(20),
              bottomLeft: Radius.circular(20))),
      child: Column(
        children: [
          Container(
            alignment: Alignment.bottomRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.dashboard,
                  color: Colors.white60,
                ),
                Icon(
                  Icons.notifications_outlined,
                  color: Colors.white60,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Covid-19",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 28)),
                CountryListPick(
                  isShowFlag: true,
                  isShowTitle: true,
                  isShowCode: false,
                  isDownIcon: true,
                  showEnglishName: true,
                  buttonColor: Colors.white,
                  initialSelection: '+91',
                  onChanged: (CountryCode code) {
                    getCountryData(code.name.toLowerCase());
                  },
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 20),
            alignment: Alignment.centerLeft,
            child: Text(
              "Are you feeling sick?",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 10),
            alignment: Alignment.centerLeft,
            child: Text(
              "If you feel sick with any covid-19 symptoms. Please call or SMS us immediately for help.",
              style: TextStyle(color: Colors.white60, fontSize: 14),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    onPressed: () {},
                    color: Colors.redAccent,
                    child: Row(
                      children: [
                        Icon(
                          Icons.call,
                          color: Colors.white,
                          size: 16,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Call Now",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        )
                      ],
                    )),
                FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    onPressed: () {},
                    color: Colors.blueAccent,
                    child: Row(
                      children: [
                        Icon(
                          Icons.sms,
                          color: Colors.white,
                          size: 16,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Send SMS",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        )
                      ],
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }

  Container buildStatisticsContainer() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "Statistics",
              style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w700,
                  fontSize: 20),
            ),
          ),
          PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: TabbarHeader(
              controller: controller,
              indicatorColor: Colors.deepOrangeAccent[100],
              backgroundColor: Colors.white,
              foregroundColor: Colors.deepPurpleAccent,
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.flag),
                      SizedBox(
                        width: 10,
                      ),
                      Text("My Country")
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(FontAwesome.globe),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Global")
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Container(
            height: 200,
            child: TabbarContent(
              controller: controller,
              children: <Widget>[
                Container(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CountCards(
                              text: "Affected",
                              width: 140,
                              height: 80,
                              border_radius: 10,
                              color: Colors.yellow[700],
                              count: _affectedCount,
                              isLoading: isLoading),
                          CountCards(
                              text: "Death",
                              width: 140,
                              height: 80,
                              border_radius: 10,
                              color: Colors.redAccent,
                              count: _deathCount,
                              isLoading: isLoading),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CountCards(
                            text: "Recovered",
                            width: 120,
                            height: 80,
                            border_radius: 10,
                            color: Colors.green[400],
                            count: _recoveredCount,
                            isLoading: isLoading,
                          ),
                          CountCards(
                              text: "Active",
                              width: 100,
                              height: 80,
                              border_radius: 10,
                              color: Colors.blue[400],
                              count: _activeCount,
                              isLoading: isLoading),
                          CountCards(
                              text: "Serious",
                              width: 100,
                              height: 80,
                              border_radius: 10,
                              color: Colors.deepOrange[400],
                              count: _seriousCount,
                              isLoading: isLoading),
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CountCards(
                            text: "Affected",
                            width: 140,
                            height: 80,
                            border_radius: 10,
                            color: Colors.yellow[700],
                            count: _globeAffectedCount,
                            isLoading: isLoading,
                          ),
                          CountCards(
                            text: "Death",
                            width: 140,
                            height: 80,
                            border_radius: 10,
                            color: Colors.redAccent,
                            count: _globeDeathCount,
                            isLoading: isLoading,
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CountCards(
                            text: "Recovered",
                            width: 100,
                            height: 80,
                            border_radius: 10,
                            color: Colors.green[400],
                            count: _globeRecoveredCount,
                            isLoading: isLoading,
                          ),
                          CountCards(
                            text: "Active",
                            width: 100,
                            height: 80,
                            border_radius: 10,
                            color: Colors.blue[400],
                            count: _globeActiveCount,
                            isLoading: isLoading,
                          ),
                          CountCards(
                            text: "Serious",
                            width: 100,
                            height: 80,
                            border_radius: 10,
                            color: Colors.deepOrange[400],
                            count: _globeSeriousCount,
                            isLoading: isLoading,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PreventionContainer extends StatelessWidget {
  const PreventionContainer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Colors.deepPurpleAccent,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      child: Column(
        children: [
          Text(
            "Prevention",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 20,
                letterSpacing: 2),
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  SvgPicture.asset(
                    'assets/svg/2.svg',
                    width: 150,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Social Distancing",
                    style: TextStyle(
                        color: Colors.white, fontSize: 16, letterSpacing: 1),
                  )
                ],
              ),
              Column(
                children: [
                  SvgPicture.asset(
                    'assets/svg/3.svg',
                    width: 150,
                    height: 130,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Wash your hands",
                    style: TextStyle(
                        color: Colors.white, fontSize: 16, letterSpacing: 1),
                  )
                ],
              )
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Stack(
            alignment: Alignment.centerLeft,
            children: [
              Container(
                width: MediaQuery.of(context).size.width - 20,
                height: 130,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Text(""),
              ),
              SvgPicture.asset(
                'assets/svg/1.svg',
                width: 200,
              ),
              Positioned(
                  left: 150,
                  top: 60,
                  child: Container(
                    width: 150,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Do Your Own Test!",
                          style: TextStyle(
                              color: Colors.grey[900],
                              fontWeight: FontWeight.w300,
                              letterSpacing: 1),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Follow the instruction to do your own test.",
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w100,
                          ),
                        ),
                      ],
                    ),
                  ))
            ],
          )
        ],
      ),
    );
  }
}
