//
//  Sounds.swift
//  InLightMeditation
//
//  Created by Konrad Gnat on 9/6/21.
//

import Foundation
import AVFoundation

 class Sounds {

   static var audioPlayer:AVAudioPlayer?

   static func playSounds(soundFile: String) {

       if let path = Bundle.main.path(forResource: soundFile, ofType: nil){

           do {
               audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
               audioPlayer?.prepareToPlay()
               audioPlayer?.play()
           } catch {
               print("Error when attempting to play sound file: ", soundFile)
           }
       }
    }
 }
