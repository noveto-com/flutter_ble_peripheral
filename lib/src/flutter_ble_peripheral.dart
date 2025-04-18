/*
 * Copyright (c) 2020. Julian Steenbakker.
 * All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */

import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';

import 'advertise_data.dart';
import 'utils.dart';

class FlutterBlePeripheral {
  /// Singleton instance
  static final FlutterBlePeripheral _instance =
      FlutterBlePeripheral._internal();

  /// Singleton factory
  factory FlutterBlePeripheral() {
    return _instance;
  }

  /// Singleton constructor
  FlutterBlePeripheral._internal();

  /// Method Channel used to communicate state with
  final MethodChannel _methodChannel =
      const MethodChannel('dev.steenbakker.flutter_ble_peripheral/ble_state');

  /// Event Channel for MTU state
  final EventChannel _mtuChangedEventChannel = const EventChannel(
      'dev.steenbakker.flutter_ble_peripheral/ble_mtu_changed');

  /// Event Channel used to changed state
  final EventChannel _stateChangedEventChannel = const EventChannel(
      'dev.steenbakker.flutter_ble_peripheral/ble_state_changed');

  // Event Channel used to received data
  final EventChannel _dataReceivedEventChannel = const EventChannel(
      'dev.steenbakker.flutter_ble_peripheral/ble_data_received');

  /// Start advertising. Takes [AdvertiseData] as an input.
  Future<void> start(AdvertiseData data) async {
    if (data.uuid == null) {
      throw IllegalArgumentException(
          'Illegal arguments! UUID must not be null or empty');
    }

    Map params = <String, dynamic>{
      'uuid': data.uuid,
      'manufacturerId': data.manufacturerId,
      'manufacturerData': data.manufacturerData,
      'serviceDataUuid': data.serviceDataUuid,
      'serviceData': data.serviceData,
      'includeDeviceName': data.includeDeviceName,
      'localName': data.localName,
      'transmissionPowerIncluded': data.transmissionPowerIncluded,
      'advertiseMode': data.advertiseMode.index,
      'connectable': data.connectable,
      'timeout': data.timeout,
      'txPowerLevel': data.txPowerLevel.index
    };

    await _methodChannel.invokeMethod('start', params);
  }

  /// Stop advertising
  Future<void> stop() async {
    await _methodChannel.invokeMethod('stop');
  }

  /// Returns `true` if advertising or false if not advertising
  Future<bool> isAdvertising() async {
    return await _methodChannel.invokeMethod('isAdvertising');
  }

  /// Returns `true` if advertising over BLE is supported
  Future<bool> isSupported() async {
    return await _methodChannel.invokeMethod('isSupported');
  }

  /// Returns `true` if advertising over BLE is supported
  Future<bool> isConnected() async {
    return await _methodChannel.invokeMethod('isConnected');
  }

  /// Start advertising. Takes [AdvertiseData] as an input.
  Future<void> sendData(Uint8List data) async {
    await _methodChannel.invokeMethod('sendData', data);
  }

  /// Returns Stream of MTU updates.
  Stream<int> getMtuChanged() {
    return _mtuChangedEventChannel
        .receiveBroadcastStream()
        .cast<int>()
        .distinct();
  }

  /// Returns Stream of state.
  ///
  /// After listening to this Stream, you'll be notified about changes in peripheral state.
  Stream<PeripheralState> getStateChanged() {
    return _stateChangedEventChannel
        .receiveBroadcastStream()
        .distinct()
        .map((dynamic event) => intToPeripheralState(event as int));
  }

  /// Returns Stream of data.
  ///
  ///
  Stream<Uint8List> getDataReceived() {
    return _dataReceivedEventChannel.receiveBroadcastStream().cast<Uint8List>();
  }
}

/// Special exception for illegal arguments
class IllegalArgumentException implements Exception {
  /// Description of exception
  final String message;

  IllegalArgumentException(this.message);

  @override
  String toString() {
    return 'IllegalArgumentException: $message';
  }
}
