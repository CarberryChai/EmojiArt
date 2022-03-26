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
            scheduleAutosave()
            if emojiArt.background != oldValue.background {
                fetchBackGroundImageDataIfNecessary()
            }
        }
    }
    @Published var backgroundImage: UIImage?
    @Published var bgImgLoading = false

    init() {
        if let url = AutoSave.url, let autosavedEmojiArt = try? EmojiArtModel(url: url) {
            emojiArt = autosavedEmojiArt
            fetchBackGroundImageDataIfNecessary()
        } else {
            emojiArt = EmojiArtModel()
        }
    }

    var emojis: [Emoji] { emojiArt.emojis }
    var background: BackGround { emojiArt.background }
    private var autosaveTimer: Timer?

    private func scheduleAutosave() {
        autosaveTimer?.invalidate()
        autosaveTimer = Timer.scheduledTimer(withTimeInterval: AutoSave.coalescingInterval, repeats: false) { _ in
            self.autosave()
        }
    }

    private struct AutoSave {
        static let filename = "Autosaved.emojiart"
        static var url: URL? {
            let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            return documentDirectory?.appendingPathComponent(filename)
        }
        static let coalescingInterval = 5.0
    }

    private func autosave() {
        if let url = AutoSave.url {
            save(to: url)
        }
    }

    private func save(to url: URL) {
        let thisfunction = "\(String(describing: self)).\(#function)"
        do {
            let data: Data = try emojiArt.json()
            print("json = \(String(data: data, encoding: .utf8) ?? "nil")")
            print("\(thisfunction) success!!")
            try data.write(to: url)
        } catch let encodingError where encodingError is EncodingError {
            print("\(thisfunction) could not encode EmojiArt to JSON becasue \(encodingError.localizedDescription)")
        } catch {
            print("\(thisfunction)  \(error)")
        }
    }


    private func fetchBackGroundImageDataIfNecessary() {
        backgroundImage = nil
        switch emojiArt.background {
        case .imageData(let data):
            backgroundImage = UIImage(data: data)
        case .url(let url):
            bgImgLoading = true
            DispatchQueue.global(qos: .userInitiated).async {
                let imgData = try? Data(contentsOf: url)
                DispatchQueue.main.async { [weak self] in
                    if self?.emojiArt.background == EmojiArtModel.BackGround.url(url) {
                        self?.bgImgLoading = false
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
