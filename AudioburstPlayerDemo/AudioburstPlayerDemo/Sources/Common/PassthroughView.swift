//
//  PassrthroughView.swift
//  AudioburstPlayerDemo
//
//  Created by Aleksander Kobylak on 04/09/2020.
//  Copyright © 2020 Audioburst. All rights reserved.
//

import UIKit

class PassthroughView: UIView {

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        return hitView == self ? nil : hitView
    }
}
