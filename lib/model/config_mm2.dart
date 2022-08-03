// To parse this JSON data, do
//
//     final configMm2 = configMm2FromJson(jsonString);

import 'dart:convert';

import 'coin_init.dart';

ConfigMm2 configMm2FromJson(String str) => ConfigMm2.fromJson(json.decode(str));

String configMm2ToJson(ConfigMm2 data) => json.encode(data.toJson());

class ConfigMm2 {
  ConfigMm2({
    this.gui,
    this.netid,
    this.client,
    this.userhome,
    this.passphrase,
    this.rpcPassword,
    this.coins,
    this.dbdir,
    this.allowWeakPassword = false,
    this.rpcPort,
  });

  factory ConfigMm2.fromJson(Map<String, dynamic> json) => ConfigMm2(
        gui: json['gui'],
        netid: json['netid'],
        client: json['client'],
        userhome: json['userhome'],
        passphrase: json['passphrase'],
        rpcPassword: json['rpc_password'],
        coins: List<CoinInit>.from(json['coins']
                .map<dynamic>((dynamic x) => CoinInit.fromJson(x))) ??
            <CoinInit>[],
        dbdir: json['dbdir'],
        allowWeakPassword: json['allow_weak_password'] ?? false,
        rpcPort: json['rpcport'],
      );

  String gui;
  int netid;
  int client;
  String userhome;
  String passphrase;
  String rpcPassword;
  List<CoinInit> coins;
  String dbdir;
  bool allowWeakPassword;
  int rpcPort;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'gui': gui,
        'netid': netid,
        'client': client,
        'userhome': userhome,
        'passphrase': passphrase,
        'rpc_password': rpcPassword,
        'coins':
            List<dynamic>.from(coins.map<dynamic>((dynamic x) => x.toJson())) ??
                <CoinInit>[],
        'dbdir': dbdir,
        'allow_weak_password': allowWeakPassword,
        if (rpcPort != null) 'rpcport': rpcPort,
      };
}
