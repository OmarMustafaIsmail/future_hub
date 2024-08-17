import 'package:future_hub/common/wallet/models/transaction_model.dart';

abstract class WalletStates {}

class WalletInitState extends WalletStates {}

class WalletLoadedState extends WalletStates {
  final bool canLoadMore;
  final List<Transaction> transactions;
  WalletLoadedState(this.transactions, this.canLoadMore);
}

class WalletLoadingState extends WalletStates {
  final List<Transaction> oldTransactions;
  final bool isFirstFetch;

  WalletLoadingState(this.oldTransactions, {this.isFirstFetch = false});
}
