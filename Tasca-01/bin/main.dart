import 'package:ecoride_pf1/ecoride.dart';

void main() {
  final usuario = User.nou(
    id: 'U001',
    nom: 'Ana López',
    correu: 'ana@example.com',
  );
  usuario.esVIP = true;
  usuario.recarregarSaldo(20.0);

  print('Usuario: ${usuario.nomComplet}');
  print('Saldo: ${usuario.saldo.toStringAsFixed(2)} €');

  final flota = <Vehicle>[
    Patinet(
      id: 'P001',
      bateriaPercentatge: 85,
      preuPerMinut: 0.20,
      velocitatMaxima: 25,
    )..actualitzarUbicacio(39.5696, 2.6502),
    Patinet(
      id: 'P002',
      bateriaPercentatge: 50,
      preuPerMinut: 0.18,
      velocitatMaxima: 25,
    )
      ..actualitzarUbicacio(39.5700, 2.6510)
      ..enUs = true,
    Patinet(
      id: 'P003',
      bateriaPercentatge: 15,
      preuPerMinut: 0.15,
      velocitatMaxima: 20,
    )..actualitzarUbicacio(39.5710, 2.6520),
    Cotxe(
      id: 'C001',
      bateriaPercentatge: 95,
      preuPerMinut: 0.50,
      places: 5,
      requereixLlicencia: true,
    )..actualitzarUbicacio(39.5720, 2.6530),
    Cotxe(
      id: 'C002',
      bateriaPercentatge: 20,
      preuPerMinut: 0.45,
      places: 4,
      requereixLlicencia: true,
    )..actualitzarUbicacio(39.5730, 2.6540),
  ];

  print('\nFlota:');
  for (final vehicle in flota) {
    print('${vehicle.id}: ${vehicle.bateriaPercentatge}% '
        '(${vehicle.estatBateria()}), en uso: ${vehicle.enUs}');
  }

  final mayorBateria = flota.reduce(
    (a, b) => a.bateriaPercentatge > b.bateriaPercentatge ? a : b,
  );
  print('\nMayor batería: ${mayorBateria.id}, '
      '${mayorBateria.bateriaPercentatge}%');

  final disponibles =
      flota.where((v) => v.bateriaPercentatge > 20 && !v.enUs).toList();
  print('Disponibles: ${disponibles.map((v) => v.id).join(', ')}');

  final patinet = disponibles.whereType<Patinet>().first;
  const minuts = 15;
  patinet.enUs = true;

  final costeNormal = patinet.calcularCostReserva(minuts);
  final costeVIP = patinet.calcularCostReserva(minuts, usuari: usuario);
  print('\nReserva de ${patinet.id} durante $minuts minutos');
  print('Coste normal: ${costeNormal.toStringAsFixed(2)} €');
  print('Coste VIP: ${costeVIP.toStringAsFixed(2)} €');

  patinet.actualitzarUbicacio(39.5800, 2.6600);
  var (lat, lng) = patinet.obtenirCoordenades();
  print('Nueva posición: $lat, $lng');
  patinet.enUs = false;

  print('\nPrueba de recarga negativa:');
  try {
    usuario.recarregarSaldo(-10.0);
  } on ArgumentError catch (e) {
    print('Error: ${e.message}');
  }

  print('Saldo actual: ${usuario.saldo.toStringAsFixed(2)} €');
  print('Fin del programa');
}
