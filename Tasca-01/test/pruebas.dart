import 'package:ecoride_pf1/ecoride.dart';

int total = 0;

void comprobar(String nombre, bool Function() prueba) {
  if (!prueba()) throw StateError('FALLO: $nombre');
  total++;
  print('OK: $nombre');
}

bool rechaza(void Function() accion) {
  try {
    accion();
    return false;
  } on ArgumentError {
    return true;
  }
}

void main() {
  final usuario =
      User.nou(id: 'U1', nom: 'Ana López', correu: 'ana@example.com');
  final vip = User(
    id: 'U2',
    nom: 'Luis Pérez',
    saldo: 10,
    correu: 'luis@example.com',
    esVIP: true,
  );

  comprobar('Usuario nuevo: saldo cero y no VIP',
      () => usuario.saldo == 0 && !usuario.esVIP && usuario.id == 'U1');
  comprobar('Constructor completo', () => vip.saldo == 10 && vip.esVIP);

  usuario.recarregarSaldo(20);
  comprobar('Recarga positiva', () => usuario.saldo == 20);
  for (final cantidad in [-10.0, 0.0]) {
    comprobar('Rechaza recarga $cantidad',
        () => rechaza(() => usuario.recarregarSaldo(cantidad)));
  }
  comprobar('Recarga fallida no altera saldo', () => usuario.saldo == 20);

  final patinet = Patinet(
    id: 'P1',
    bateriaPercentatge: 80,
    preuPerMinut: 0.20,
    velocitatMaxima: 25,
  );
  comprobar('Vehículo inicialmente libre', () => !patinet.enUs);

  for (final caso in [
    (0, 'Crítica (Requiere carga)'),
    (19, 'Crítica (Requiere carga)'),
    (20, 'Media'),
    (79, 'Media'),
    (80, 'Alta'),
    (100, 'Alta')
  ]) {
    patinet.bateriaPercentatge = caso.$1;
    comprobar('Batería ${caso.$1}: ${caso.$2}',
        () => patinet.estatBateria() == caso.$2);
  }

  for (final bateria in [-1, 101]) {
    comprobar('Rechaza batería $bateria',
        () => rechaza(() => patinet.bateriaPercentatge = bateria));
    comprobar(
      'Constructor rechaza batería $bateria',
      () => rechaza(() => Patinet(
            id: 'X',
            bateriaPercentatge: bateria,
            preuPerMinut: 0.2,
            velocitatMaxima: 25,
          )),
    );
  }

  comprobar(
    'Patinete normal: 3 EUR',
    () => (patinet.calcularCostReserva(15, usuari: usuario) - 3).abs() < 1e-9,
  );
  comprobar(
    'Patinete VIP: 2,70 EUR',
    () => (patinet.calcularCostReserva(15, usuari: vip) - 2.7).abs() < 1e-9,
  );
  comprobar('Firma de un argumento válida',
      () => patinet.calcularCostReserva(15) == 3);
  comprobar(
      'Patinete: cero minutos', () => patinet.calcularCostReserva(0) == 0);

  final cotxe = Cotxe(
    id: 'C1',
    bateriaPercentatge: 90,
    preuPerMinut: 0.5,
    places: 5,
    requereixLlicencia: true,
  );
  comprobar('Coche: tarifa más suplemento de 2 EUR',
      () => cotxe.calcularCostReserva(15) == 9.5);
  comprobar('Coche no aplica VIP del patinete',
      () => cotxe.calcularCostReserva(15, usuari: vip) == 9.5);
  comprobar('Coche: fórmula con cero minutos',
      () => cotxe.calcularCostReserva(0) == 2);

  patinet.actualitzarUbicacio(39.6, 2.7);
  final (lat, lng) = patinet.obtenirCoordenades();
  comprobar(
      'Actualización y destructuración GPS', () => lat == 39.6 && lng == 2.7);

  final flota = <Vehicle>[
    Patinet(
      id: 'F1',
      bateriaPercentatge: 20,
      preuPerMinut: 0.2,
      velocitatMaxima: 25,
    ),
    Patinet(
      id: 'F2',
      bateriaPercentatge: 21,
      preuPerMinut: 0.2,
      velocitatMaxima: 25,
    ),
    cotxe..enUs = true,
  ];
  final disponibles =
      flota.where((v) => v.bateriaPercentatge > 20 && !v.enUs).toList();
  comprobar('Filtro estricto >20 y libre',
      () => disponibles.length == 1 && disponibles.single.id == 'F2');

  final mayor = flota
      .reduce((a, b) => a.bateriaPercentatge >= b.bateriaPercentatge ? a : b);
  comprobar('Máximo por reduce', () => mayor.id == 'C1');

  print('\nRESULTADO: $total pruebas superadas.');
}
