import 'package:fireapp/presentation/constraint_form/base_input_field.dart';
import 'package:fireapp/presentation/constraint_form/constraint_form_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


abstract class TemporalInputField extends BaseInputField {

   const TemporalInputField(
      {super.key,
      required super.controller,
      required super.label,
      required super.icon});

   TextFormField buildContext(BuildContext context, void Function() onTap){
     return TextFormField(
         controller: controller,
         style: Theme.of(context).textTheme.labelLarge,
     // using the same text theme from login_page
     decoration: InputDecoration(
     labelText: AppLocalizations.of(context)?.enterDate,
     fillColor: Colors.white,
     filled: true,
     prefixIcon: const Icon(Icons.calendar_today),
     border: commonInputBorder,
     ),
     readOnly: true,
     validator: validator,
     onTap: onTap);
   }

   }

  // case schedulerInputType.date:
//         {
//           return TextFormField(
//             controller: controller,
//             style: Theme.of(context).textTheme.labelLarge,
//             // using the same text theme from login_page
//             decoration: InputDecoration(
//               labelText: AppLocalizations.of(context)?.enterDate,
//               fillColor: Colors.white,
//               filled: true,
//               prefixIcon: const Icon(Icons.calendar_today),
//               border: _commonInputBorder,
//             ),
//             readOnly: true,
//             validator: validator,
//             onTap: () async {
//               DateTime? selectedDate = await showDatePicker(
//                 context: context,
//                 initialDate: DateTime.now(),
//                 firstDate: DateTime(2020),
//                 lastDate: DateTime(2100),
//               );
//               if (selectedDate != null) {
//                 controller.text = DateFormat('yyyy-MM-dd').format(selectedDate);
//               }
//             },
//           );
//         }
//       case schedulerInputType.time:
//         {
//           return TextFormField(
//             controller: controller,
//             style: style ?? Theme.of(context).textTheme.labelLarge,
//             decoration: InputDecoration(
//               labelText: AppLocalizations.of(context)?.enterStartTime,
//               fillColor: Colors.white,
//               filled: true,
//               prefixIcon: Icon(icon),
//               border: _commonInputBorder,
//             ),
//             readOnly: true,
//             validator: validator,
//             onTap: () async {
//               TimeOfDay? selectedTime = await showTimePicker(
//                 context: context,
//                 initialTime: TimeOfDay.now(),
//               );
//               if (selectedTime != null) {
//                 controller.text = selectedTime.format(context);
//               }
// //             },
// //           );
// }
