//
//  StorageInteractor.swift
//  InternalDemoSDK
//
//  Created by Aleksander Kobylak on 04/12/2020.
//

import Foundation
import AudioburstPlayer



class StorageInteractor {

    var credentialsItem: ConfigurationItem? {
        get {
            let userDefaults = UserDefaults.standard
            do {
                return try userDefaults.getObject(forKey: Constants.credentialsItemKey, castTo: ConfigurationItem.self)
            } catch {
                return nil
            }
        }
    }

    var customItem: ConfigurationItem? {
        get {
            let userDefaults = UserDefaults.standard
            do {
                return try userDefaults.getObject(forKey: Constants.customItemKey, castTo: ConfigurationItem.self)
            } catch {
                return nil
            }
        }
    }

    func saveCredentials(_ item: ConfigurationItem) {
        let userDefaults = UserDefaults.standard

        do {
            try userDefaults.saveObject(item, forKey: Constants.credentialsItemKey)
        } catch {
            debugPrint(error.localizedDescription)
        }
    }

    func saveCustom(_ item: ConfigurationItem) {
        let userDefaults = UserDefaults.standard
        do {
            try userDefaults.saveObject(item, forKey: Constants.customItemKey)
        } catch {
            debugPrint(error.localizedDescription)
        }
    }

}
