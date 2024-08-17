import 'package:future_hub/common/auth/models/user.dart';
import 'package:future_hub/common/graphql/graphql_client.dart';
import 'package:future_hub/common/graphql/schema.gql.dart';
import 'package:future_hub/common/shared/utils/fetch_exception.dart';
import 'package:future_hub/common/shared/utils/paginator_info.dart';
import 'package:future_hub/common/wallet/graphql/wallet.gql.dart';
import 'package:future_hub/common/wallet/models/transaction_model.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class WalletService {
  Future<PaginatorInfo<Transaction>> fetchWalletData({
    int page = 1,
    int? employee,
    bool cache = false,
  }) async {
    final result = await Client.current.queryWallet(
      OptionsQueryWallet(
        variables: VariablesQueryWallet(
          page: page,
          employee: employee,
        ),
        fetchPolicy: cache ? FetchPolicy.cacheFirst : null,
      ),
    );

    final data = result.parsedData?.wallets;
    final transactions = data!.data;
    final hasMorePages = data.paginatorInfo.hasMorePages;
    final total = data.paginatorInfo.total;

    if (result.hasException) {
      throw FetchException.fromOperation(result.exception!);
    }

    return PaginatorInfo(
      data: transactions
          .map(
            (transaction) => Transaction(
              id: transaction.id,
              title: transaction.title ?? "",
              type: transaction.type ?? "",
              description: transaction.description ?? "",
              wallet: Wallet(
                customer: transaction.wallet!.customer == null
                    ? null
                    : User(
                        id: transaction.wallet!.customer!.id,
                        name: transaction.wallet!.customer!.name,
                        email: transaction.wallet!.customer!.email,
                        phone: transaction.wallet!.customer!.mobile,
                        type: transaction.wallet!.customer!.type,
                        limit: transaction.wallet!.customer!.wallet_limit,
                        spentAmount: transaction.wallet!.customer!.withdrawal,
                        wallet: transaction.wallet!.customer!.wallet,
                      ),
              ),
              amount: transaction.amount ?? "",
              paymentMethod: transaction.payment_method ?? "",
              createdAt: transaction.created_at ?? "",
              attachment: transaction.attachment ?? "",
              transactionNumber: transaction.transaction_number ?? "",
            ),
          )
          .toList(),
      hasMorePages: hasMorePages,
      total: total,
    );
  }

  Future<void> addBalanceToCompany({
    required String title,
    required double amount,
    required EnumPaymentMethod paymentMethod,
    String? attachment,
  }) async {
    final result = await Client.current.mutateDepositToCompanyWallet(
      OptionsMutationDepositToCompanyWallet(
        variables: VariablesMutationDepositToCompanyWallet(
            title: title, payment_method: paymentMethod, amount: amount),
      ),
    );

    final data = result.parsedData?.createWallet;
    final status = data?.status;
    final message = data?.message!;

    if (result.hasException) {
      throw FetchException.fromOperation(result.exception!);
    }

    if (status == 'FAIL') {
      throw FetchException(message!);
    }
    // return Transaction(
    //   id: data!.wallet!.id ?? "",
    //   title: data.wallet!.title ?? "",
    //   type: data.wallet!.type! ?? "",
    //   description: data.wallet!.description! ?? "",
    //   amount: data.wallet!.amount! ?? "",
    //   paymentMethod: data.wallet!.payment_method! ?? "",
    //   createdAt: data.wallet!.created_at! ?? "",
    //   attachment: data.wallet!.attachment! ?? "",
    //   transactionNumber: data.wallet!.transaction_number! ?? "",
    // );
  }
}
