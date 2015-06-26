//
//  Modulator.swift
//  ControladorDinamico
//
//  Created by Sergio Sette on 11/22/14.
//  Copyright (c) 2014 Natália Cabral. All rights reserved.
//

import Foundation
import AVFoundation

@objc protocol Modulator
{
    func modulate(modulation:Float)
    func startModulator()
}