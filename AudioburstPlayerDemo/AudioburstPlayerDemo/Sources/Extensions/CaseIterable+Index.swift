//
//  CaseIterable+Index.swift
//  InternalDemoSDK
//
//  Created by Aleksander Kobylak on 18/01/2021.
//

import Foundation

extension CaseIterable where Self: Equatable {

    var index: Self.AllCases.Index? {
        return Self.allCases.firstIndex { self == $0 }
    }
}
