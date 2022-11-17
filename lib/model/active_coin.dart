import 'package:komodo_dex/model/coin_type.dart';

import 'coin.dart';

class ActiveCoin {
  ActiveCoin.fromJson(Map<String, dynamic> json, Coin activeCoin) {
    if (activeCoin.type == CoinType.slp) {
      if (json['result']['bch_addresses_infos'] != null) {
        address = json['result']['bch_addresses_infos'].keys.first;
        balance = json['result']['bch_addresses_infos'].values.first['balances']
            ['spendable'];
        lockedBySwaps = json['result']['bch_addresses_infos']
            .values
            .first['balances']['unspendable'];
      } else {
        address = json['result']['balances'].keys.first;
        balance =
            json['result']['balances'].values.first['spendable'].toString();
        lockedBySwaps =
            json['result']['balances'].values.first['unspendable'].toString();
      }
      result = 'success';
      coin = activeCoin.abbr ?? '';
      requiredConfirmations = activeCoin.requiredConfirmations;
      matureConfirmations = activeCoin.matureConfirmations;
      requiresNotarization = activeCoin.requiresNotarization;
    } else if ((activeCoin.type == CoinType.iris ||
            activeCoin.type == CoinType.cosmos) &&
        activeCoin.protocol.protocolData.platform != null) {
      json = json['result']['balances'];
      address = json.keys.first ?? '';
      balance = json.values.first['spendable'] ?? '';
      lockedBySwaps = json.values.first['unspendable'] ?? '';
      result = 'success' ?? '';
      coin = activeCoin.abbr ?? '';
      requiredConfirmations = activeCoin.requiredConfirmations;
      matureConfirmations = activeCoin.matureConfirmations;
      requiresNotarization = activeCoin.requiresNotarization;
    } else if ((activeCoin.type == CoinType.iris ||
            activeCoin.type == CoinType.cosmos) &&
        activeCoin.protocol.protocolData.platform == null) {
      json = json['result'];
      coin = json['ticker'] ?? '';
      address = json['address'] ?? '';
      balance = json['balance']['spendable'] ?? '';
      lockedBySwaps = json['balance']['unspendable'] ?? '';
      result = 'success' ?? '';
      requiredConfirmations = activeCoin.requiredConfirmations;
      matureConfirmations = activeCoin.matureConfirmations;
      requiresNotarization = activeCoin.requiresNotarization;
    } else {
      coin = json['coin'] ?? '';
      address = json['address'] ?? '';
      balance = json['balance'] ?? '';
      lockedBySwaps = json['locked_by_swaps'] ?? '';
      result = json['result'] ?? '';
      requiredConfirmations = json['required_confirmations'];
      matureConfirmations = json['mature_confirmations'];
      requiresNotarization = json['requires_notarization'];
    }
  }

  String coin;
  String address;
  String balance;
  String lockedBySwaps;
  String result;
  int requiredConfirmations;
  int matureConfirmations;
  bool requiresNotarization;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'coin': coin ?? '',
        'address': address ?? '',
        'balance': balance ?? '',
        'locked_by_swaps': lockedBySwaps ?? '',
        'result': result ?? ''
      };
}
