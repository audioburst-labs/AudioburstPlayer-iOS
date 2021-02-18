//
//  UIViewController.swift
//  Audioburst
//
//  Created by Artur Jaworski on 17/06/2019.
//  Copyright © 2019 Audioburst. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    class func instantiateFromStoryboard() -> Self {
        return self.instantiateFromStoryboard(self)
    }
    
    private class func instantiateFromStoryboard<T>(_ type: T.Type) -> T {
        let name = String(describing: self)
            .replacingOccurrences(of: "ViewController", with: "")
            .replacingOccurrences(of: "Controller", with: "")
        
        let storyboard = UIStoryboard(name: name+"Storyboard", bundle: nil)
        guard let vc = storyboard.instantiateInitialViewController() as? T else {
            fatalError()
        }
        return vc
    }
    
}
