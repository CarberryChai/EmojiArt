//
//  EmojiArtMode.Background.swift
//  EmojiArt
//
//  Created by 柴长林 on 2022/3/17.
//

import Foundation

extension EmojiArtModel {
    enum BackGround: Equatable {
        case blank
        case url(URL)
        case imageData(Data)

        var url: URL? {
            switch self {
            case .url(let url): return url
            default: return nil
            }
        }

        var imageData: Data? {
            switch self {
            case .imageData(let data): return data
            default: return nil
            }
        }
    }
}
