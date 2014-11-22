//
//  ModulatedSampler.swift
//  ControladorDinamico
//
//  Created by Sergio Sette on 11/22/14.
//  Copyright (c) 2014 Natália Cabral. All rights reserved.
//

import Foundation
import AVFoundation

class ModulatedSampler
{
    var modulatorNodes:Array<Modulator> = Array<Modulator>()
    var sampler:Sampler
    
    init(sampler:Sampler) {
        self.sampler = sampler
    }
    
    func addModulator(modulator:Modulator)
    {
        self.modulatorNodes.append(modulator)
    }
    
    func startWithEngine(audioEngine:AVAudioEngine)
    {
        let mainMixer = audioEngine.mainMixerNode
        var parentNode:AVAudioNode = mainMixer
        for modulator in modulatorNodes {
            audioEngine.attachNode(modulator.audioNode())
            audioEngine.connect(modulator.audioNode(), to:parentNode, format:audioEngine.mainMixerNode.outputFormatForBus(0))
            parentNode = modulator.audioNode()
        }
        audioEngine.connect(sampler.sampler(), to:parentNode, format:audioEngine.mainMixerNode.outputFormatForBus(0))
    }
}
