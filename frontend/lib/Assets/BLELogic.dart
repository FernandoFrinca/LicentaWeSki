
import 'dart:async';

import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class BLELogic  extends GetxController{
  FlutterReactiveBle ble = FlutterReactiveBle();
  late StreamSubscription<DiscoveredDevice> searchDevices;
  final RxList<DiscoveredDevice> devices = <DiscoveredDevice>[].obs;
  StreamSubscription<ConnectionStateUpdate>? connection;
  DiscoveredDevice? currentDeviceConnected;
  final DiscoveredDevice dummyDevice = DiscoveredDevice(
    id: "",
    name: "no device connected",
    serviceUuids: const [],
    rssi: 0,
    connectable: Connectable.unavailable,
    serviceData: const {},
    manufacturerData: Uint8List(0),
  );

  final ValueNotifier<DiscoveredDevice> connectedDeviceNotifier = ValueNotifier(
      DiscoveredDevice(
        id: "",
        name: "no device connected",
        serviceUuids: const [],
        rssi: 0,
        connectable: Connectable.unavailable,
        serviceData: const {},
        manufacturerData: Uint8List(0),
      )
  );



  Future scanForDevices() async{
    if(await Permission.bluetoothScan.request().isGranted){
      if(await Permission.bluetoothConnect.request().isGranted){
        devices.clear();
        searchDevices = ble.scanForDevices(withServices: [], scanMode: ScanMode.lowLatency).listen((device){
          if (device.name != "") {
            if (!devices.any((d) => d.id == device.id)) {
              devices.add(device);
            }
          }
        });
      }
    }
  }

  Future<void> disconnectDevice(DiscoveredDevice device) async {
    if (connection != null && currentDeviceConnected?.name == device.name) {
      await connection!.cancel();
      connection = null;
      currentDeviceConnected = null;
      connectedDeviceNotifier.value = dummyDevice;
    }
  }


  Future<bool> connectTODevice(DiscoveredDevice device) async {
    if (connection != null && currentDeviceConnected?.name == device.name) {
      await disconnectDevice(device);
      return false;
    }

    if (connection != null) {
      await connection!.cancel();
      connection = null;
      currentDeviceConnected = null;
      connectedDeviceNotifier.value = dummyDevice;
    }

    final completer = Completer<bool>();

    connection = ble.connectToDevice(
      id: device.id,
      connectionTimeout: Duration(seconds: 5),
    ).listen((connectionState) {
      switch (connectionState.connectionState) {
        case DeviceConnectionState.connected:
          currentDeviceConnected = device;
          connectedDeviceNotifier.value = device;
          if (!completer.isCompleted) completer.complete(true);
          break;
        case DeviceConnectionState.disconnected:
          currentDeviceConnected = null;
          connectedDeviceNotifier.value = dummyDevice;
          if (!completer.isCompleted) completer.complete(false);
          break;

        default:
          break;
      }
    });

    return completer.future;
  }



  Future<void> sendCommandToDevice(int number) async {
    if (currentDeviceConnected == null) {
      return;
    }

    final characteristic = QualifiedCharacteristic(
      serviceId: Uuid.parse("19b10000-e8f2-537e-4f6c-d104768a1214"),
      characteristicId: Uuid.parse("19b10001-e8f2-537e-4f6c-d104768a1214"),
      deviceId: currentDeviceConnected!.id,
    );

    try {
      await ble.writeCharacteristicWithResponse(
        characteristic,
        value: Uint8List(1)..[0] = number,
      );
    } catch (e) {
      print("Eroare la trimitere: $e");
    }
  }

  Future<void> sendSOSCommandtoDevice(bool value) async {
    if (currentDeviceConnected == null) {
      return;
    }

    final characteristic = QualifiedCharacteristic(
      serviceId: Uuid.parse("19b10010-e8f2-537e-4f6c-d104768a1214"),
      characteristicId: Uuid.parse("19b10011-e8f2-537e-4f6c-d104768a1214"),
      deviceId: currentDeviceConnected!.id,
    );

    try {
      await ble.writeCharacteristicWithResponse(
        characteristic,
        value: Uint8List(1)..[0] = value ? 1 : 0,
      );
    } catch (e) {
      print("Eroare la trimitere: $e");
    }
  }

  Future<void> readLdrValue(ValueNotifier<String> valueNotif) async {
    if (currentDeviceConnected == null) {
      return;
    }

    final characteristic = QualifiedCharacteristic(
      serviceId: Uuid.parse("19b10020-e8f2-537e-4f6c-d104768a1214"),
      characteristicId: Uuid.parse("19b10021-e8f2-537e-4f6c-d104768a1214"),
      deviceId: currentDeviceConnected!.id,
    );

    try {
      final value = await ble.readCharacteristic(characteristic);
      if (value.isNotEmpty) {
        int valueLdr = value[0];
        if (value.length > 1) {
          valueLdr += value[1] << 8;
        }
        valueNotif.value = valueLdr.toString();
      }
    } catch (e) {
      print("Eroare la citire senzor: $e");
    }
  }


  Future stopScan() async {
    devices.clear();
    searchDevices.cancel();
  }

}