//
//  EmojiArtDocument.swift
//  EmojiArt
//
//  Created by 柴长林 on 2022/3/17.
//

import Combine
import CoreGraphics
import UIKit

class EmojiArtDocument: ObservableObject {
    typealias BackGround = EmojiArtModel.BackGround
    typealias Emoji = EmojiArtModel.Emoji

    @Published private(set) var emojiArt: EmojiArtModel {
        didSet {
            if emojiArt.background != oldValue.background {
                fetchBackGroundImageDataIfNecessary()
            }
        }
    }
    @Published var backgroundImage: UIImage?
    @Published var bgImgLoading = false

    init() {
        emojiArt = EmojiArtModel()
    }

    var emojis: [Emoji] { emojiArt.emojis }
    var background: BackGround { emojiArt.background }


    private func fetchBackGroundImageDataIfNecessary() {
        backgroundImage = nil
        switch emojiArt.background {
            case .imageData(let data):
                backgroundImage = UIImage(data: data)
            case.url(let url):
                DispatchQueue.global(qos: .userInitiated).async {
                    let imgData = try? Data(contentsOf: url)
                    DispatchQueue.main.async { [weak self] in
                        if self?.emojiArt.background == EmojiArtModel.BackGround.url(url) {
                            if let imageData = imgData {
                                self?.backgroundImage = UIImage(data: imageData)
                            }
                        }
                    }
                }
            case .blank:
                break
        }
    }


    func setBackground(_ background: BackGround) {
        emojiArt.background = background
        print(background)
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
