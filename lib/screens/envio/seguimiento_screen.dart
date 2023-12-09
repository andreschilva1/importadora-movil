import 'package:flutter/material.dart';
import 'package:projectsw2_movil/helpers/alert.dart';
import 'package:projectsw2_movil/models/models.dart';
import 'package:projectsw2_movil/search_delegate/carrier_search_delegate.dart';
import 'package:projectsw2_movil/services/services.dart';
import 'package:projectsw2_movil/widgets/widgets.dart';
import 'package:provider/provider.dart';

class SeguimientoScreen extends StatelessWidget {
  final String numeroRastreo;
  const SeguimientoScreen({Key? key, required this.numeroRastreo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<TrakingService>(context, listen: false).fetchSeguimientos(numeroRastreo, context);
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Informacion de Seguimiento')),
      ),
      body: Center(
        child:
            Consumer<TrakingService>(builder: (context, trakingService, child) {
          Seguimiento? seguimiento = trakingService.seguimiento;
          if (seguimiento == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          List<Evento> eventos = seguimiento.eventos;
          return Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(255, 43, 36, 67),
                            Color.fromARGB(255, 135, 110, 202)
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      color: Colors.grey[200],
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 40,
                left: 10,
                right: 10,
                bottom: 30,
                child: Scrollbar(
                  trackVisibility: true,
                  child: SingleChildScrollView(
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.85,
                            height: 280,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.all(5),
                            child: Column(
                              children: [
                                RowCustom(
                                  icon: Icons.local_shipping,
                                  color: Colors.blue,
                                  text: 'Transportista Seleccionado',
                                  subText: seguimiento.carrierName ?? '',
                                  child: TextButton(
                                    onPressed: () async {
                                      List<Carrier>? carriers =
                                          await trakingService
                                              .getCarriers(context);
                                      if (context.mounted && carriers != null) {
                                        Carrier? carrieSeleccionado =
                                            await showSearch(
                                          context: context,
                                          delegate: CarrierSearchDelegate(
                                            carriers: carriers,
                                            carrierCodeAnterior:
                                                seguimiento.carrierCode ?? 0,
                                          ),
                                        );
                                        if (carrieSeleccionado != null &&
                                            context.mounted) {
                                          if (carrieSeleccionado.key != seguimiento.carrierCode) {
                                            bool isChangeCarrier =
                                                await trakingService
                                                    .changeCarrier(
                                              context,
                                              numeroRastreo: numeroRastreo,
                                              carrierOld:
                                                  seguimiento.carrierCode ?? 0,
                                              carrierNew:
                                                  carrieSeleccionado.key ?? 0,
                                            );

                                            if (isChangeCarrier &&
                                                context.mounted) {
                                              mostrarLoading(context,
                                                  mensaje: 'cargando eventos');
                                              await trakingService
                                                  .fetchSeguimientos(
                                                      numeroRastreo, context);
                                              if (context.mounted) {
                                                Navigator.of(context).pop();
                                              }
                                            }
                                          }
                                        }
                                      }
                                    },
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                    ),
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.blueAccent.shade700,
                                      size: 30,
                                    ),
                                  ),
                                ),
                                Divider(
                                  color: Colors.grey[300],
                                ),
                                RowCustom(
                                  icon: Icons.source_outlined,
                                  color: Colors.blue,
                                  text: 'Numero Rastreo',
                                  subText: numeroRastreo,
                                ),
                                Divider(
                                  color: Colors.grey[300],
                                ),
                                RowCustom(
                                  icon: Icons.list_alt_outlined,
                                  color: Colors.yellowAccent[400]!,
                                  text: 'Ultimo Estado',
                                  subText: seguimiento.estadoActual ?? '',
                                ),
                                Divider(
                                  color: Colors.grey[300],
                                ),
                                RowCustom(
                                  icon: Icons.hourglass_bottom,
                                  color: Colors.green[400]!,
                                  text: 'Dias en Transito',
                                  subText:
                                      seguimiento.diasEnTransito.toString(),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.70,
                            width: MediaQuery.of(context).size.width * 0.85,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.all(5),
                            child: Column(
                              children: [
                                const Center(
                                  child: Text(
                                    "Eventos",
                                    style: TextStyle(
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.60,
                                  width:
                                      MediaQuery.of(context).size.width * 0.85,
                                  child: Scrollbar(
                                    trackVisibility: true,
                                    child: (eventos.isEmpty)
                                        ? Container(
                                          margin: const EdgeInsets.all(25),
                                          child: const Text(
                                            '¡No se encontraron eventos!. intente elegir otro transportista',
                                            maxLines: 3,
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        )
                                        : ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const AlwaysScrollableScrollPhysics(),
                                            itemCount: eventos.length,
                                            itemBuilder: (context, index) {
                                              return Card(
                                                shadowColor: Colors.grey,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      eventos[index]
                                                              .description ??
                                                          '',
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(eventos[index]
                                                            .location ??
                                                        ''),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      eventos[index]
                                                          .timeUtc
                                                          .toString(),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}



