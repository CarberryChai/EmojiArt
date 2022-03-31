//
//  PaletteStore.swift
//  EmojiArt
//
//  Created by 柴长林 on 2022/3/26.
//

import Foundation
import Combine

struct Palette: Identifiable, Codable, Hashable {
    var id: String = UUID().uuidString
    var name: String
    var emojis: String
}

final class PaletteStore: ObservableObject {
    let name: String

    @Published var palettes: [Palette] = [] {
        didSet {
            storeInUserDefaults()
        }
    }

    private var userDefaultsKey: String {
        "PaletteStore:" + name
    }

    private func storeInUserDefaults() {
        UserDefaults.standard.set(try? JSONEncoder().encode(palettes), forKey: userDefaultsKey)
//        UserDefaults.standard.set(palettes.map {[$0.name, $0.emojis, $0.id]}, forKey: userDefaultsKey)
    }

    private func restoreFromUserDefaults() {
        if let jsonData = UserDefaults.standard.data(forKey: userDefaultsKey) {
            do {
                let decodedPalettes = try JSONDecoder().decode([Palette].self, from: jsonData)
                palettes = decodedPalettes
            } catch {
                print("PaletteStore.restoreFromUserDefaults json decode error. \(error)")
            }
        }
//        if let palettesAsPropertyList = UserDefaults.standard.array(forKey: userDefaultsKey) as? [[String]] {
//            for paletteAsArray in palettesAsPropertyList {
//                if paletteAsArray.count == 3, !palettes.contains(where: { $0.id == paletteAsArray[2] }) {
//                    let palette = Palette(name: paletteAsArray[0], emojis: paletteAsArray[1])
//                    palettes.append(palette)
//                }
//            }
//        }
    }

    init(named name: String) {
        self.name = name
        restoreFromUserDefaults()
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
