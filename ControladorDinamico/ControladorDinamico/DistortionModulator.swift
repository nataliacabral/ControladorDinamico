//
//  DistortionModulator.swift
//  ControladorDinamico
//
//  Created by Sergio Sette on 11/22/14.
//  Copyright (c) 2014 Natália Cabral. All rights reserved.
//

import Foundation
import AVFoundation

class DistortionModulator : Modulator
{
    var node:AVAudioUnitDistortion = AVAudioUnitDistortion()
    
    func modulate(modulation:Float)
    {
        node.wetDryMix = modulation * 100
    }
    func startModulator()
    {
        node.wetDryMix = 50
        node.loadFactoryPreset(AVAudioUnitDistortionPreset.MultiEcho1)
    }
    
    func audioNode() -> AVAudioNode {
        return self.node
    }
}