//
//  VolumeModulator.swift
//  ControladorDinamico
//
//  Created by Sergio Sette on 11/22/14.
//  Copyright (c) 2014 Natália Cabral. All rights reserved.
//

import Foundation
import AVFoundation

class VolumeModulator : NodeModulator
{
    var node:AVAudioMixerNode = AVAudioMixerNode()
    
    func modulate(modulation:Float)
    {
        self.node.volume = modulation
        
    }
    func startModulator()
    {
        node.volume = 0.5
    }
    
    func audioNode() -> AVAudioNode {
        return self.node
    }
}