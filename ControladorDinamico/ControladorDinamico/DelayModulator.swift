//
//  DelayModulator.swift
//  ControladorDinamico
//
//  Created by Sergio Sette on 11/23/14.
//  Copyright (c) 2014 Natália Cabral. All rights reserved.
//

import Foundation
import AVFoundation

class DelayModulator : Modulator
{
    var node:AVAudioUnitDelay = AVAudioUnitDelay()
    
    func modulate(modulation:Float)
    {
        node.wetDryMix = modulation * 100.0
    }
    func startModulator()
    {
        node.feedback = -100
        node.wetDryMix = 50
    }
    
    func audioNode() -> AVAudioNode {
        return self.node
    }
}