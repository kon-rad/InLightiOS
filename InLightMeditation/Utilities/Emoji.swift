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
                emojiText = "đ"
                break
            case "sun_behind_small_cloud":
                emojiText = "đ¤ī¸"
                break
            case "sun_behind_large_cloud":
                emojiText = "â"
                break
            case "cloud_with_lightening":
                emojiText = "đŠī¸"
                break
            case "lightening_bolt":
                emojiText = "âĄ"
                break
            default:
                emojiText = ""
        }
        
        return emojiText
    }
}
