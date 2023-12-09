import 'package:flutter/material.dart';
import 'package:projectsw2_movil/models/carrier.dart';

class CarrierSearchDelegate extends SearchDelegate<Carrier> {
  final List<Carrier> carriers;
  final int carrierCodeAnterior;
  CarrierSearchDelegate(
      {required this.carrierCodeAnterior, required this.carriers});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(
          context,
          Carrier(name: '', key: carrierCodeAnterior, url: ''),
        );
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    final results = carriers
        .where((carrier) =>
            carrier.name!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final carrier = results[index];
        return ListTile(
          title: Text(carrier.name ?? ''),
          onTap: () {
            close(context, carrier);
          },
        );
      },
    );
  }
}
