import 'package:covid19_tracker/app/services/api_keys.dart';
import 'package:flutter/cupertino.dart';

enum Endpoint {
  cases,
  todayCases,
  active,
  deaths,
  todayDeaths,
  recovered,
  critical,
  totalTests
}

class API {
  API({@required this.apiKey});
  final String apiKey;

  factory API.sanbox() => API(apiKey: APIKeys.covSanboxKey);

  static final String host = "apigw.nubentos.com";
  static final int port = 443;
  static final String basePath = 't/nubentos.com/ncovapi/2.0.0';

  Uri endpointUri(Endpoint endpoint, String country) => Uri(
        scheme: 'https',
        host: host,
        port: port,
        path: '$basePath/${_paths[endpoint]}',
        queryParameters: {'country': country},
      );

  Uri tokenUri() => Uri(
      scheme: 'https',
      host: host,
      port: port,
      path: 'token',
      queryParameters: {'grant_type': 'client_credentials'});

  static Map<Endpoint, String> _paths = {
    Endpoint.cases: 'cases',
    Endpoint.todayCases: 'todayCases',
    Endpoint.active: 'active',
    Endpoint.deaths: 'deaths',
    Endpoint.todayDeaths: 'todayDeaths',
    Endpoint.recovered: 'recovered',
    Endpoint.critical: 'critical',
    Endpoint.totalTests: 'totalTests'
  };
}
