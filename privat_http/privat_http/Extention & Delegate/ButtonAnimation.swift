//
//  ButtonAnimation.swift
//  privat_http
//
//  Created by Roman Mishchenko on 9/30/19.
//  Copyright © 2019 Roman Mishchenko. All rights reserved.
//

import UIKit

extension UIButton {
    func pulsate() {
        let puls = CASpringAnimation(keyPath: "transform.scale")
        puls.duration = 0.6
        puls.fromValue = 0.95
        puls.toValue = 1
        puls.repeatCount = 2
        puls.initialVelocity = 0.5
        puls.damping = 1.0
        layer.add(puls, forKey: nil)
    }
}
