//
//  ReverbModulator.swift
//  ControladorDinamico
//
//  Created by Sergio Sette on 11/22/14.
//  Copyright (c) 2014 Natália Cabral. All rights reserved.
//

import Foundation
import AVFoundation

class ReverbModulator : Modulator
{
    var node:AVAudioUnitReverb = AVAudioUnitReverb()
    
    func modulate(modulation:Float)
    {
        self.node.wetDryMix = modulation * 100
    }
    func startModulator()
    {
        node.wetDryMix = 50
        self.node.loadFactoryPreset(AVAudioUnitReverbPreset.Cathedral)
    }
    
    func audioNode() -> AVAudioNode {
        return self.node
    }
}