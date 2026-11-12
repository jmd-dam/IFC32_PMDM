# PF1 EcoRide

Práctica de Dart sobre usuarios, vehículos y cálculo de reservas.

## Ejecutar el proyecto

Hay que abrir esta carpeta en VS Code o Android Studio y usar Dart 3 o posterior.

```bash
dart pub get
dart run bin/main.dart
```

Para comprobar el código:

```bash
dart analyze
dart format --output=none --set-exit-if-changed bin lib test
dart run test/pruebas.dart
```

El archivo de pruebas se ejecuta con `dart run`, no con `dart test`.

## Archivos

- `lib/ecoride.dart`: clases `User`, `Vehicle`, `Patinet` y `Cotxe`, además del mixin `GPSLocation`.
- `bin/main.dart`: programa principal con la flota, los filtros, una reserva y la gestión del error.
- `test/pruebas.dart`: comprobaciones de los métodos.
- `PLANTILLA_ENTREGA.md`: plantilla para preparar el PDF final.

## Funcionamiento

El programa crea tres patinetes y dos coches. Después busca el vehículo con más batería mediante `reduce` y filtra los disponibles con `where`.

Para la reserva se utiliza un patinete durante 15 minutos. Se muestra el precio normal y el precio con el descuento VIP. También se cambian sus coordenadas y se obtienen con esta destructuración:

```dart
var (lat, lng) = patinet.obtenirCoordenades();
```

El estado de la batería se calcula con una Switch Expression:

```dart
String estatBateria() => switch (bateriaPercentatge) {
  >= 80 => 'Alta',
  >= 20 => 'Media',
  _ => 'Crítica (Requiere carga)',
};
```

Al final se intenta recargar `-10.0`. El método lanza un `ArgumentError` y el `try-catch` muestra el mensaje sin interrumpir el programa.

