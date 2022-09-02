import 'package:earthquake/models/earthquake_model.dart';
import 'package:earthquake/providers/earthquake_provider.dart';
import 'package:earthquake/utils/constants.dart';
import 'package:earthquake/utils/helper_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isFirst = true;
  late EarthquakeProvider eqProvider;
  EarthquakeModel? earthquakeModel;
  DateTime? selectedFromDate;
  DateTime? selectedToDate;
  String? fromDate, toDate;
  String msg = 'Please select date range and rector scale value from above!';

  @override
  void didChangeDependencies() {
    if (isFirst) {
      eqProvider = Provider.of<EarthquakeProvider>(context);
      isFirst = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Earthquakes'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      _selectFromDate(context);
                    },
                    child: Text(fromDate == null || fromDate!.isEmpty
                        ? 'From'
                        : fromDate!),
                  ),
                ),
                const SizedBox(
                  width: 4,
                ),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                      onPressed: () {
                        _selectToDate(context);
                      },
                      child: Text(
                          toDate == null || toDate!.isEmpty ? 'To' : toDate!)),
                ),
                const SizedBox(
                  width: 4,
                ),
                Expanded(
                  flex: 1,
                  child: DropdownButton(
                    value: eqProvider.magnitude,
                    items: magnitudeList
                        .map<DropdownMenuItem<num>>(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(e.toString()),
                          ),
                        )
                        .toList(),
                    onChanged: (num? value) => setState(
                      () {
                        eqProvider.magnitude = value!;
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  width: 4,
                ),
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                      onPressed: () async {
                        if (fromDate == null ||
                            fromDate!.isEmpty ||
                            toDate == null ||
                            toDate!.isEmpty) {
                          EasyLoading.showToast('Please select date');
                        } else {
                          setState(() {
                            msg = '';
                          });
                          EasyLoading.show(status: 'Please wait...');
                          await eqProvider.getEarthquakeReport();
                          earthquakeModel = eqProvider.earthquakeModel;
                          EasyLoading.dismiss();
                        }
                      },
                      child: const Text('Go')),
                ),
              ],
            ),
          ),
          earthquakeModel == null
              ? Expanded(
                  child: Center(
                    child: Text(
                      msg,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                      itemCount: earthquakeModel!.features!.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            title: Text(earthquakeModel!
                                        .features![index].properties!.place ==
                                    null
                                ? 'Place not marked'
                                : earthquakeModel!
                                    .features![index].properties!.place!),
                            leading: Container(
                              height: 80,
                              width: 80,
                              color: Colors.amberAccent.shade400,
                              child: Center(
                                  child: Text(earthquakeModel!
                                      .features![index].properties!.mag!
                                      .toString())),
                            ),
                            subtitle: Text(
                                'On ${getFormattedDateTimeNum(earthquakeModel!.features![index].properties!.time!, 'MMM dd, yyyy hh:mm a')}'),
                          ),
                        );
                      }),
                ),
        ],
      ),
    );
  }

  _selectFromDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1980),
      lastDate: DateTime.now(),
    );
    if (selected != null && selected != selectedFromDate) {
      setState(() {
        selectedFromDate = selected;
        fromDate = getFormattedDateTime(selectedFromDate!, 'yyyy-MM-dd');
        eqProvider.startDate = fromDate;
      });
    }
  }

  _selectToDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1980),
      lastDate: DateTime.now(),
    );
    if (selected != null && selected != selectedToDate) {
      setState(() {
        selectedToDate = selected;
        toDate = getFormattedDateTime(selectedToDate!, 'yyyy-MM-dd');
        eqProvider.endDate = toDate;
      });
    }
  }
}
