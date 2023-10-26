//
//  DeviceSettingManager.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 02/08/23.
//

import SwiftUI
import Combine

// A class to extract device settings and set into device header parameters.
class DeviceSettingManager: ObservableObject {
    static let shared = DeviceSettingManager()
    
    @Published var deviceHeaderParams: [String: Any] = [:]
    
    private init() {
        prepareDeviceHeaderParam()
    }
    
    private func prepareDeviceHeaderParam() {
        self.deviceHeaderParams = [
            "X-SalesSparrow-App-Version": Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String,
            "X-SalesSparrow-Build-Number": Bundle.main.infoDictionary?["CFBundleVersion"] as! String,
            "X-SalesSparrow-Device-Os-Version": UIDevice.current.systemVersion,
            "X-SalesSparrow-Device-Uuid": UIDevice.current.identifierForVendor?.uuidString ?? "",
            "X-SalesSparrow-Device-Os": UIDevice.current.systemName,
            "X-SalesSparrow-Device-Name": UIDevice.current.name
        ]
    }
}
