//
//  PitchModulator.swift
//  ControladorDinamico
//
//  Created by Sergio Sette on 11/22/14.
//  Copyright (c) 2014 Natália Cabral. All rights reserved.
//

import Foundation
import AVFoundation

class PitchModulator : Modulator
{
    var node:AVAudioUnitTimePitch = AVAudioUnitTimePitch()
    
    func modulate(modulation:Float)
    {
        node.pitch = (modulation - 0.3) * 2800
    }
    func startModulator()
    {
        node.pitch = 50
        node.rate = 2
    }
    
    func audioNode() -> AVAudioNode {
        return self.node
    }
}