//
//  Emoji.swift
//  InLightMeditation
//
//  Created by Konrad Gnat on 3/15/22.
//

import Foundation

class Emoji {
    
    static func renderEmoji(emoji: String) -> String {
        var emojiText: String
        switch emoji {
            case "sun_with_face":
                emojiText = "🌞"
                break
            case "sun_behind_small_cloud":
                emojiText = "🌤️"
                break
            case "sun_behind_large_cloud":
                emojiText = "⛅"
                break
            case "cloud_with_lightening":
                emojiText = "🌩️"
                break
            case "lightening_bolt":
                emojiText = "⚡"
                break
            default:
                emojiText = ""
        }
        
        return emojiText
    }
}
