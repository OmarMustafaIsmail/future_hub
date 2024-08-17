import 'package:future_hub/common/auth/models/user.dart';
import 'package:future_hub/common/shared/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class EmployeeDetails extends StatelessWidget {
  final User employee;

  const EmployeeDetails({
    super.key,
    required this.employee,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Row(
      children: [
        CircleAvatar(
          radius: 25.0,
          backgroundImage: employee.imageURL != null
              ? NetworkImage(employee.imageURL!)
              : null,
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                employee.name!,
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 8.0),
              Text(
                employee.type!,
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
        if (employee.createdAt != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                t.date_added,
                style: theme.textTheme.labelMedium!.copyWith(
                  color: Palette.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                DateFormat('E yyyy/mm/dd', t.localeName)
                    .format(employee.createdAt!),
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
      ],
    );
  }
}
