//
//  PitchModulator.swift
//  ControladorDinamico
//
//  Created by Sergio Sette on 11/22/14.
//  Copyright (c) 2014 Natália Cabral. All rights reserved.
//

import Foundation
import AVFoundation

class PitchModulator : NodeModulator
{
    var node:AVAudioUnitTimePitch = AVAudioUnitTimePitch()
    
    func modulate(modulation:Float)
    {
        node.pitch = (modulation - 0.5) * 800
    }
    func startModulator()
    {
        node.pitch = 0
        node.rate = 1
    }
    
    func audioNode() -> AVAudioNode {
        return self.node
    }
}