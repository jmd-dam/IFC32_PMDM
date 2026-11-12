class User {
  final String _id;
  final String _nomComplet;
  double _saldo;
  String correu;
  bool esVIP;

  User({
    required String id,
    required String nom,
    required double saldo,
    required this.correu,
    this.esVIP = false,
  })  : _id = id,
        _nomComplet = nom,
        _saldo = saldo;

  User.nou({required String id, required String nom, required String correu})
      : this(id: id, nom: nom, saldo: 0.0, correu: correu);

  String get id => _id;
  double get saldo => _saldo;
  String get nomComplet => _nomComplet;

  void recarregarSaldo(double quantitat) {
    if (quantitat <= 0) {
      throw ArgumentError('La cantidad debe ser mayor que cero.');
    }
    _saldo += quantitat;
  }
}

mixin GPSLocation {
  double latitud = 0.0;
  double longitud = 0.0;

  void actualitzarUbicacio(double lat, double lng) {
    latitud = lat;
    longitud = lng;
  }

  (double lat, double lng) obtenirCoordenades() => (latitud, longitud);
}

abstract class Vehicle with GPSLocation {
  final String id;
  int _bateriaPercentatge;
  bool enUs = false;
  final double preuPerMinut;

  Vehicle({
    required this.id,
    required int bateriaPercentatge,
    required this.preuPerMinut,
  }) : _bateriaPercentatge = bateriaPercentatge {
    if (bateriaPercentatge < 0 || bateriaPercentatge > 100) {
      throw ArgumentError('La batería debe estar entre 0 y 100.');
    }
  }

  int get bateriaPercentatge => _bateriaPercentatge;

  set bateriaPercentatge(int valor) {
    if (valor < 0 || valor > 100) {
      throw ArgumentError('La batería debe estar entre 0 y 100.');
    }
    _bateriaPercentatge = valor;
  }

  String estatBateria() => switch (bateriaPercentatge) {
        >= 80 => 'Alta',
        >= 20 => 'Media',
        _ => 'Crítica (Requiere carga)',
      };

  double calcularCostReserva(int minuts, {User? usuari});
}

class Patinet extends Vehicle {
  final int velocitatMaxima;

  Patinet({
    required super.id,
    required super.bateriaPercentatge,
    required super.preuPerMinut,
    required this.velocitatMaxima,
  });

  @override
  double calcularCostReserva(int minuts, {User? usuari}) {
    double coste = minuts * preuPerMinut;

    if (usuari != null && usuari.esVIP) {
      coste *= 0.90;
    }

    return coste;
  }
}

class Cotxe extends Vehicle {
  final int places;
  final bool requereixLlicencia;
  static const double suplementFiltreEcologic = 2.0;

  Cotxe({
    required super.id,
    required super.bateriaPercentatge,
    required super.preuPerMinut,
    required this.places,
    required this.requereixLlicencia,
  });

  @override
  double calcularCostReserva(int minuts, {User? usuari}) {
    return minuts * preuPerMinut + suplementFiltreEcologic;
  }
}
