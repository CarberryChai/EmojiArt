//
//  EmojiArtDocument.swift
//  EmojiArt
//
//  Created by 柴长林 on 2022/3/17.
//

import Combine
import CoreGraphics

class EmojiArtDocument: ObservableObject {
    typealias BackGround = EmojiArtModel.BackGround
    typealias Emoji = EmojiArtModel.Emoji

    @Published private(set) var emojiArt: EmojiArtModel

    init() {
        emojiArt = EmojiArtModel()
    }

    var emojis: [Emoji] { emojiArt.emojis }
    var background: BackGround { emojiArt.background }


    func setBackground(_ background: BackGround) {
        emojiArt.background = background
    }

    func addEmoji(_ emoji: String, at location: (x: Int, y: Int), size: CGFloat) {
        emojiArt.addEmoji(emoji, at: location, size: Int(size))
    }

    func moveEmoji(_ emoji: Emoji, by offset: CGSize) {
        if let index = emojiArt.emojis.index(matching: emoji) {
            emojiArt.emojis[index].x += Int(offset.width)
            emojiArt.emojis[index].y += Int(offset.height)
        }
    }

    func scaleEmoji(_ emoji: Emoji, by scale: CGFloat) {
        if let index = emojiArt.emojis.index(matching: emoji) {
            emojiArt.emojis[index].size = Int((CGFloat(emojiArt.emojis[index].size) * scale).rounded(.toNearestOrAwayFromZero))
        }
    }
}
