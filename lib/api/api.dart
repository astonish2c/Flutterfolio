import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Payload {
  Payload({
    required this.status,
    required this.data,
  });

  Status status;
  List<Datum> data;

  factory Payload.fromJson(Map<String, dynamic> json) => Payload(
        status: Status.fromJson(json["status"]),
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status.toJson(),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    required this.id,
    required this.name,
    required this.symbol,
    required this.slug,
    required this.numMarketPairs,
    required this.dateAdded,
    required this.tags,
    required this.maxSupply,
    required this.circulatingSupply,
    required this.totalSupply,
    required this.platform,
    required this.cmcRank,
    required this.lastUpdated,
    required this.quote,
  });

  int id;
  String name;
  String symbol;
  String slug;
  int numMarketPairs;
  DateTime dateAdded;
  List<Tag> tags;
  double maxSupply;
  double circulatingSupply;
  double totalSupply;
  Platform platform;
  int cmcRank;
  DateTime lastUpdated;
  Quote quote;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        symbol: json["symbol"],
        slug: json["slug"],
        numMarketPairs: json["num_market_pairs"],
        dateAdded: DateTime.parse(json["date_added"]),
        tags: List<Tag>.from(json["tags"].map((x) => tagValues.map[x])),
        maxSupply: json["max_supply"] == null ? null : json["max_supply"].toDouble(),
        circulatingSupply: json["circulating_supply"] == null ? null : json["circulating_supply"].toDouble(),
        totalSupply: json["total_supply"] == null ? null : json["total_supply"].toDouble(),
        platform: json["platform"] ?? Platform.fromJson(json["platform"]),
        cmcRank: json["cmc_rank"],
        lastUpdated: DateTime.parse(json["last_updated"]),
        quote: Quote.fromJson(json["quote"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "symbol": symbol,
        "slug": slug,
        "num_market_pairs": numMarketPairs,
        "date_added": dateAdded.toIso8601String(),
        "tags": List<dynamic>.from(tags.map((x) => tagValues.reverse[x])),
        "max_supply": maxSupply == null ? null : maxSupply,
        "circulating_supply": circulatingSupply == null ? null : circulatingSupply,
        "total_supply": totalSupply == null ? null : totalSupply,
        "platform": platform == null ? null : platform.toJson(),
        "cmc_rank": cmcRank,
        "last_updated": lastUpdated.toIso8601String(),
        "quote": quote.toJson(),
      };
}

class Platform {
  Platform({
    required this.id,
    required this.name,
    required this.symbol,
    required this.slug,
    required this.tokenAddress,
  });

  int id;
  Name name;
  Symbol symbol;
  Slug slug;
  String tokenAddress;

  factory Platform.fromJson(Map<String, dynamic> json) => Platform(
        id: json["id"],
        name: nameValues.map[json["name"]]!,
        symbol: symbolValues.map[json["symbol"]]!,
        slug: slugValues.map[json["slug"]]!,
        tokenAddress: json["token_address"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": nameValues.reverse[name],
        "symbol": symbolValues.reverse[symbol],
        "slug": slugValues.reverse[slug],
        "token_address": tokenAddress,
      };
}

enum Name { ETHEREUM, TRON, OMNI, RSK_SMART_BITCOIN, BINANCE_COIN, STELLAR, NEO, V_SYSTEMS, ARDOR, QTUM, XRP, WAVES, ONTOLOGY, EOS, NEBULAS, NEM, BIT_SHARES, BITCOIN_CASH, INT_CHAIN, COSMOS, UBIQ, VE_CHAIN, NU_BITS, PIVX, COUNTERPARTY, KOMODO, ICON, GX_CHAIN, VITE, WANCHAIN, IOST, TRUE_CHAIN, ETHEREUM_CLASSIC }

final nameValues = EnumValues({"Ardor": Name.ARDOR, "Binance Coin": Name.BINANCE_COIN, "Bitcoin Cash": Name.BITCOIN_CASH, "BitShares": Name.BIT_SHARES, "Cosmos": Name.COSMOS, "Counterparty": Name.COUNTERPARTY, "EOS": Name.EOS, "Ethereum": Name.ETHEREUM, "Ethereum Classic": Name.ETHEREUM_CLASSIC, "GXChain": Name.GX_CHAIN, "ICON": Name.ICON, "INT Chain": Name.INT_CHAIN, "IOST": Name.IOST, "Komodo": Name.KOMODO, "Nebulas": Name.NEBULAS, "NEM": Name.NEM, "Neo": Name.NEO, "NuBits": Name.NU_BITS, "Omni": Name.OMNI, "Ontology": Name.ONTOLOGY, "PIVX": Name.PIVX, "Qtum": Name.QTUM, "RSK Smart Bitcoin": Name.RSK_SMART_BITCOIN, "Stellar": Name.STELLAR, "TRON": Name.TRON, "TrueChain": Name.TRUE_CHAIN, "Ubiq": Name.UBIQ, "VeChain": Name.VE_CHAIN, "VITE": Name.VITE, "v.systems": Name.V_SYSTEMS, "Wanchain": Name.WANCHAIN, "Waves": Name.WAVES, "XRP": Name.XRP});

enum Slug { ETHEREUM, TRON, OMNI, RSK_SMART_BITCOIN, BINANCE_COIN, STELLAR, NEO, V_SYSTEMS, ARDOR, QTUM, XRP, WAVES, ONTOLOGY, EOS, NEBULAS_TOKEN, NEM, BITSHARES, BITCOIN_CASH, INT_CHAIN, COSMOS, UBIQ, VECHAIN, NUBITS, PIVX, COUNTERPARTY, KOMODO, ICON, GXCHAIN, VITE, WANCHAIN, IOSTOKEN, TRUECHAIN, ETHEREUM_CLASSIC }

final slugValues = EnumValues({"ardor": Slug.ARDOR, "binance-coin": Slug.BINANCE_COIN, "bitcoin-cash": Slug.BITCOIN_CASH, "bitshares": Slug.BITSHARES, "cosmos": Slug.COSMOS, "counterparty": Slug.COUNTERPARTY, "eos": Slug.EOS, "ethereum": Slug.ETHEREUM, "ethereum-classic": Slug.ETHEREUM_CLASSIC, "gxchain": Slug.GXCHAIN, "icon": Slug.ICON, "int-chain": Slug.INT_CHAIN, "iostoken": Slug.IOSTOKEN, "komodo": Slug.KOMODO, "nebulas-token": Slug.NEBULAS_TOKEN, "nem": Slug.NEM, "neo": Slug.NEO, "nubits": Slug.NUBITS, "omni": Slug.OMNI, "ontology": Slug.ONTOLOGY, "pivx": Slug.PIVX, "qtum": Slug.QTUM, "rsk-smart-bitcoin": Slug.RSK_SMART_BITCOIN, "stellar": Slug.STELLAR, "tron": Slug.TRON, "truechain": Slug.TRUECHAIN, "ubiq": Slug.UBIQ, "vechain": Slug.VECHAIN, "vite": Slug.VITE, "v-systems": Slug.V_SYSTEMS, "wanchain": Slug.WANCHAIN, "waves": Slug.WAVES, "xrp": Slug.XRP});

enum Symbol { ETH, TRX, OMNI, RBTC, BNB, XLM, NEO, VSYS, ARDR, QTUM, XRP, WAVES, ONT, EOS, NAS, XEM, BTS, BCH, INT, ATOM, UBQ, VET, USNBT, PIVX, XCP, KMD, ICX, GXC, VITE, WAN, IOST, TRUE, ETC }

final symbolValues = EnumValues({"ARDR": Symbol.ARDR, "ATOM": Symbol.ATOM, "BCH": Symbol.BCH, "BNB": Symbol.BNB, "BTS": Symbol.BTS, "EOS": Symbol.EOS, "ETC": Symbol.ETC, "ETH": Symbol.ETH, "GXC": Symbol.GXC, "ICX": Symbol.ICX, "INT": Symbol.INT, "IOST": Symbol.IOST, "KMD": Symbol.KMD, "NAS": Symbol.NAS, "NEO": Symbol.NEO, "OMNI": Symbol.OMNI, "ONT": Symbol.ONT, "PIVX": Symbol.PIVX, "QTUM": Symbol.QTUM, "RBTC": Symbol.RBTC, "TRUE": Symbol.TRUE, "TRX": Symbol.TRX, "UBQ": Symbol.UBQ, "USNBT": Symbol.USNBT, "VET": Symbol.VET, "VITE": Symbol.VITE, "VSYS": Symbol.VSYS, "WAN": Symbol.WAN, "WAVES": Symbol.WAVES, "XCP": Symbol.XCP, "XEM": Symbol.XEM, "XLM": Symbol.XLM, "XRP": Symbol.XRP});

class Quote {
  Quote({
    required this.usd,
  });

  Usd usd;

  factory Quote.fromJson(Map<String, dynamic> json) => Quote(
        usd: Usd.fromJson(json["USD"]),
      );

  Map<String, dynamic> toJson() => {
        "USD": usd.toJson(),
      };
}

class Usd {
  Usd({
    required this.price,
    required this.volume24H,
    required this.percentChange1H,
    required this.percentChange24H,
    required this.percentChange7D,
    required this.marketCap,
    required this.lastUpdated,
  });

  double price;
  double volume24H;
  double percentChange1H;
  double percentChange24H;
  double percentChange7D;
  double marketCap;
  DateTime lastUpdated;

  factory Usd.fromJson(Map<String, dynamic> json) => Usd(
        price: json["price"] == null ? null : json["price"].toDouble(),
        volume24H: json["volume_24h"] == null ? null : json["volume_24h"].toDouble(),
        percentChange1H: json["percent_change_1h"] == null ? null : json["percent_change_1h"].toDouble(),
        percentChange24H: json["percent_change_24h"] == null ? null : json["percent_change_24h"].toDouble(),
        percentChange7D: json["percent_change_7d"] == null ? null : json["percent_change_7d"].toDouble(),
        marketCap: json["market_cap"] == null ? null : json["market_cap"].toDouble(),
        lastUpdated: DateTime.parse(json["last_updated"]),
      );

  Map<String, dynamic> toJson() => {
        "price": price == null ? null : price,
        "volume_24h": volume24H == null ? null : volume24H,
        "percent_change_1h": percentChange1H == null ? null : percentChange1H,
        "percent_change_24h": percentChange24H == null ? null : percentChange24H,
        "percent_change_7d": percentChange7D == null ? null : percentChange7D,
        "market_cap": marketCap == null ? null : marketCap,
        "last_updated": lastUpdated.toIso8601String(),
      };
}

enum Tag { MINEABLE }

final tagValues = EnumValues({"mineable": Tag.MINEABLE});

class Status {
  Status({
    required this.timestamp,
    required this.errorCode,
    required this.errorMessage,
    required this.elapsed,
    required this.creditCount,
    required this.notice,
  });

  DateTime timestamp;
  int errorCode;
  dynamic errorMessage;
  int elapsed;
  int creditCount;
  dynamic notice;

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        timestamp: DateTime.parse(json["timestamp"]),
        errorCode: json["error_code"],
        errorMessage: json["error_message"],
        elapsed: json["elapsed"],
        creditCount: json["credit_count"],
        notice: json["notice"],
      );

  Map<String, dynamic> toJson() => {
        "timestamp": timestamp.toIso8601String(),
        "error_code": errorCode,
        "error_message": errorMessage,
        "elapsed": elapsed,
        "credit_count": creditCount,
        "notice": notice,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => MapEntry(v, k));
    }
    return reverseMap!;
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  late Future<Payload> _future;

  Future<Payload> getCryptoPrices() async {
    final Uri url = Uri.parse("https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest?start=1&limit=5000&convert=USD");

    var response = await http.get(url, headers: {
      'X-CMC_PRO_API_KEY': '305395ba-0b09-471c-856c-c899694160f1',
      "Accept": "application/json",
    });

    return Payload.fromJson(json.decode(response.body));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _future = getCryptoPrices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: FutureBuilder(
            future: _future,
            builder: (context, AsyncSnapshot<Payload> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Text('none');
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
                case ConnectionState.active:
                  return Text('');
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    return Text(
                      '${snapshot.error}',
                      style: TextStyle(color: Colors.red),
                    );
                  } else {
                    return ListView.builder(
                        itemCount: snapshot.data!.data.length,
                        itemBuilder: (context, index) {
                          return Card(
                              elevation: 6.0,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 6.0, bottom: 6.0, left: 8.0, right: 8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(snapshot.data!.data[index].name),
                                    Spacer(),
                                    Text(snapshot.data!.data[index].lastUpdated.toIso8601String()),
                                    Spacer(),
                                    Text(
                                      snapshot.data!.data[index].quote.usd.price.toString(),
                                    ),
                                  ],
                                ),
                              ));
                        });
                  }
              }
            }));
  }
}
