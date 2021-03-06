//
//  EmojiArtModel.swift
//  EmojiArt
//
//  Created by 柴长林 on 2022/3/16.
//

import Foundation
import SwiftUI

struct EmojiArtModel: Codable {
    var background: BackGround
    var emojis: [Emoji]

    init() {
        self.background = .blank
        self.emojis = []
    }

    init(json: Data) throws {
        self = try JSONDecoder().decode(EmojiArtModel.self, from: json)
    }

    init(url: URL) throws {
        let data = try Data(contentsOf: url)
        self = try EmojiArtModel(json: data)
    }

    mutating func addEmoji(_ text: String, at location: (x: Int, y: Int), size: Int) {
        emojis.append(Emoji(text: text, x: location.x, y: location.y, size: size, id: emojiCounter))
        emojiCounter += 1
    }

    func json() throws -> Data {
        try JSONEncoder().encode(self)
    }

    struct Emoji: Identifiable, Hashable, Codable {
        let text: String
        var x: Int // offset from the center
        var y: Int // offset from the center
        var size: Int
        let id: Int

        fileprivate init(text: String, x: Int, y: Int, size: Int, id: Int) {
            self.text = text
            self.x = x
            self.y = y
            self.size = size
            self.id = id
        }
    }

    private var emojiCounter = 0
}
