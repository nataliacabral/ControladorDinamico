//
//  Modulator.swift
//  ControladorDinamico
//
//  Created by Sergio Sette on 11/21/14.
//  Copyright (c) 2014 Natália Cabral. All rights reserved.
//

import Foundation
import AVFoundation

@objc protocol Modulator
{
    func leftModulator() -> AVAudioNode
    func rightModulator() -> AVAudioNode
    func topModulator() -> AVAudioNode
    func bottomModulator() -> AVAudioNode
    func setModule(module:Float)
    func startModulator()
}