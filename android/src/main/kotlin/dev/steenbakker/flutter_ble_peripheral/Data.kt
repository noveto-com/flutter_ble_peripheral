/*
 * Copyright (c) 2020. Julian Steenbakker.
 * All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */

package dev.steenbakker.flutter_ble_peripheral

import android.bluetooth.le.AdvertiseSettings

class Data(
        var uuid: String = "",
        var manufacturerId: Int? = null,
        var manufacturerData: List<Int> = mutableListOf(),
        var serviceDataUuid: String = "8EBDB2F0-7817-45C9-95C5-C5E9031AAA47",
        var serviceData: List<Int> = mutableListOf(),
        var txCharacteristicUUID: String = "8EBDB2F2-7817-45C9-95C5-C5E9031AAA47",
        var rxCharacteristicUUID: String = "8EBDB2F1-7817-45C9-95C5-C5E9031AAA47",
        var includeDeviceName: Boolean = false,
        var includeTxPowerLevel: Boolean = false,
        var advertiseMode: Int = AdvertiseSettings.ADVERTISE_MODE_LOW_LATENCY,
        var connectable: Boolean = false,
        var timeout: Int = 400,
        var txPowerLevel: Int = AdvertiseSettings.ADVERTISE_TX_POWER_HIGH
)
