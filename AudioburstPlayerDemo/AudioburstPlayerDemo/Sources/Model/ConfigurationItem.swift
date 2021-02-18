//
//  ConfigurationItem.swift
//
//
//  Created by Aleksander Kobylak on 04/12/2020.
//

import Foundation
import AudioburstPlayer

struct ConfigurationItem: Hashable, Codable {

    static func == (lhs: ConfigurationItem, rhs: ConfigurationItem) -> Bool {
        lhs.name == rhs.name
    }

    func hash(into hasher: inout Hasher) {
            hasher.combine(name)
    }

    let name: String
    let appKey: String
    let experienceId: String?
    let configuration: ABPlayer.Configuration?


    enum CodingKeys: String, CodingKey {
        case name
        case appKey = "appkey"
        case experienceId = "experienceid"
        case configuration = "configuration"
    }

}
