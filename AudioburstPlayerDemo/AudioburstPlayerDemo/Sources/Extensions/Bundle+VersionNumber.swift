//
//  Bundle+VersionNumber.swift
//  Audioburst
//
//  Created by Stanislau Zamana on 09/09/2019.
//  Copyright © 2019 Audioburst. All rights reserved.
//

import Foundation

extension Bundle {
    var versionNumber: String {
        let buildNumber = object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? ""
        let version = object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
        return "v" + version + " (" + buildNumber + ")"
    }
}
