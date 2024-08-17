import 'package:future_hub/common/graphql/graphql_client.dart';
import 'package:future_hub/common/shared/utils/paginator_info.dart';
import 'package:future_hub/employee/orders/graphql/punchers.gql.dart';
import 'package:future_hub/employee/orders/models/puncher.dart';
import 'package:future_hub/employee/orders/models/puncher_branch.dart';

import '../../../common/shared/utils/fetch_exception.dart';

class PunchersServices {
  Future<PaginatorInfo<PuncherBranch>> fetchBranches(
    int page, {
    String longitude = '',
    String latitude = '',
  }) async {
    final result = await Client.current.queryPunchers(
      OptionsQueryPunchers(
        variables: VariablesQueryPunchers(
          page: page,
          //  TODO: pass lat & long
        ),
      ),
    );

    final data = result.parsedData?.punchers;
    final branches = data!.data;
    final hasMorePages = data.paginatorInfo.hasMorePages;
    final total = data.paginatorInfo.total;

    if (result.hasException) {
      throw FetchException.fromOperation(result.exception!);
    }

    return PaginatorInfo(
      data: branches
          .map(
            (branch) => PuncherBranch(
              id: branch.id!,
              title: branch.title,
              address: branch.address,
              longitude: branch.longitude,
              latitude: branch.latitude,
              city: branch.city != null
                  ? City(
                      id: branch.city!.id,
                      title: branch.city!.title,
                      active: branch.city!.active,
                      position: branch.city!.position,
                    )
                  : null,
              puncher: Puncher(
                id: int.parse(branch.puncher!.id),
                name: branch.puncher!.name,
                imageUrl: branch.puncher!.imageUrl,
              ),
            ),
          )
          .toList(),
      hasMorePages: hasMorePages,
      total: total,
    );
  }
}
