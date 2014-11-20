//
//  SoundManager.swift
//  ControladorDinamico
//
//  Created by Sergio Sette on 11/19/14.
//  Copyright (c) 2014 Natália Cabral. All rights reserved.
//

import AVFoundation

class SoundManager : NSObject {
    var audioEngine:AVAudioEngine

    
    class var sharedInstance: SoundManager {
        struct Static {
            static var instance: SoundManager?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = SoundManager()
        }
        
        return Static.instance!
    }
    
    override init() {
        self.audioEngine = AVAudioEngine()
//        self.audioEngine!.startAndReturnError(nil)
    }
    
    func startEngine()
    {
        self.audioEngine.startAndReturnError(nil)
    }
    func stopEngine()
    {
        self.audioEngine.stop()
    }
}


