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
    var modulatorList:Array<Modulator> = Array<Modulator>()
    var sampler:Sampler
    
    init(sampler:Sampler) {
        self.sampler = sampler
    }
    
    func addModulator(modulator:Modulator)
    {
        self.modulatorList.append(modulator)
    }
    
    func startWithEngine(audioEngine:AVAudioEngine)
    {
        let mainMixer = audioEngine.mainMixerNode
        var parentNode:AVAudioNode = mainMixer
        for modulator in modulatorList {
            if (modulator is NodeModulator) {
                let nodeModulator = modulator as NodeModulator
                audioEngine.attachNode(nodeModulator.audioNode())
                audioEngine.connect(nodeModulator.audioNode(), to:parentNode, format:audioEngine.mainMixerNode.outputFormatForBus(0))
                parentNode = nodeModulator.audioNode()
                modulator.startModulator()
            }
            else if (modulator is MidiModulator) {
                let midiModulator = modulator as MidiModulator
                midiModulator.setSampler(sampler)
            }
        }
        audioEngine.connect(sampler.sampler(), to:parentNode, format:audioEngine.mainMixerNode.outputFormatForBus(0))
    }
}
