//
//  PaletteStore.swift
//  EmojiArt
//
//  Created by 柴长林 on 2022/3/26.
//

import Foundation
import Combine

struct Palette: Identifiable {
    let id: String = UUID().uuidString
    var name: String
    var emojis: String
}

final class PaletteStore: ObservableObject {
    let name: String

    @Published var palettes: [Palette] = []

    init(named name: String) {
        self.name = name
        if palettes.isEmpty {
            palettes = [
                Palette(name: "Vehicles", emojis: "🚙🚗🚘🚕🚖🏎🚚🛻🚛🚐🚓🚔🚑🚒🚀✈️🛫🛬🛩🚁🛸🚲🏍🛶⛵️🚤🛥🛳⛴🚢🚂🚝🚅🚆🚊🚉🚇🛺🚜"),
                Palette(name: "Sports", emojis: "🏈⚾️🏀⚽️🎾🏐🥏🏓⛳️🥅🥌🏂⛷🎳"),
                Palette(name: "Music", emojis: "🎼🎤🎹🪘🥁🎺🪗🪕🎻"),
                Palette(name: "Animals", emojis: "🐥🐣🐂🐄🐎🐖🐏🐑🦙🐐🐓🐁🐀🐒🦆🦅🦉🦇🐢🐍🦎🦖🦕🐅🐆🦓🦍🦧🦣🐘🦛🦏🐪🐫🦒🦘🦬🐃🦙🐐🦌🐕🐩🦮🐈🦤🦢🦩🕊🦝🦨🦡🦫🦦🦥🐿🦔"),
                Palette(name: "Animal Faces", emojis: "🐵🙈🙊🙉🐶🐱🐭🐹🐰🦊🐻🐼🐻‍❄️🐨🐯🦁🐮🐷🐸🐲"),
                Palette(name: "Flora", emojis: "🌲🌴🌿☘️🍀🍁🍄🌾💐🌷🌹🥀🌺🌸🌼🌻"),
                Palette(name: "Weather", emojis: "☀️🌤⛅️🌥☁️🌦🌧⛈🌩🌨❄️💨☔️💧💦🌊☂️🌫🌪"),
                Palette(name: "COVID", emojis: "💉🦠😷🤧🤒"),
                Palette(name: "Faces", emojis: "😀😃😄😁😆😅😂🤣🥲☺️😊😇🙂🙃😉😌😍🥰😘😗😙😚😋😛😝😜🤪🤨🧐🤓😎🥸🤩🥳😏😞😔😟😕🙁☹️😣😖😫😩🥺😢😭😤😠😡🤯😳🥶😥😓🤗🤔🤭🤫🤥😬🙄😯😧🥱😴🤮😷🤧🤒🤠"),
            ]
        }
    }

    func pallete(at idx: Int) -> Palette {
        let index = min(max(idx, 0), palettes.count - 1)
        return palettes[index]
    }

    @discardableResult
    func removePalette(at index: Int) -> Int {
        if !palettes.isEmpty, palettes.indices.contains(index) {
            palettes.remove(at: index)
        }
        return index % palettes.count
    }

    func insertPalette(named name: String, emojis: String? = nil, at index: Int = 0) {
        let palette = Palette(name: name, emojis: emojis ?? "")
        let safeIdx = min(max(index, 0), palettes.count)
        palettes.insert(palette, at: safeIdx)
    }
}
