//
//  PaletteStore.swift
//  EmojiArt
//
//  Created by ζ΄ιΏζ on 2022/3/26.
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
                Palette(name: "Vehicles", emojis: "ππππππππ»πππππππβοΈπ«π¬π©ππΈπ²ππΆβ΅οΈπ€π₯π³β΄π’ππππππππΊπ"),
                Palette(name: "Sports", emojis: "πβΎοΈπβ½οΈπΎππ₯πβ³οΈπ₯π₯πβ·π³"),
                Palette(name: "Music", emojis: "πΌπ€πΉπͺπ₯πΊπͺπͺπ»"),
                Palette(name: "Animals", emojis: "π₯π£πππππππ¦ππππππ¦π¦π¦π¦π’ππ¦π¦π¦πππ¦π¦π¦§π¦£ππ¦π¦πͺπ«π¦π¦π¦¬ππ¦ππ¦ππ©π¦?ππ¦€π¦’π¦©ππ¦π¦¨π¦‘π¦«π¦¦π¦₯πΏπ¦"),
                Palette(name: "Animal Faces", emojis: "π΅ππππΆπ±π­πΉπ°π¦π»πΌπ»ββοΈπ¨π―π¦π?π·πΈπ²"),
                Palette(name: "Flora", emojis: "π²π΄πΏβοΈππππΎππ·πΉπ₯πΊπΈπΌπ»"),
                Palette(name: "Weather", emojis: "βοΈπ€βοΈπ₯βοΈπ¦π§βπ©π¨βοΈπ¨βοΈπ§π¦πβοΈπ«πͺ"),
                Palette(name: "COVID", emojis: "ππ¦ π·π€§π€"),
                Palette(name: "Faces", emojis: "ππππππππ€£π₯²βΊοΈππππππππ₯°πππππππππ€ͺπ€¨π§π€ππ₯Έπ€©π₯³ππππππβΉοΈπ£ππ«π©π₯Ίπ’π­π€π π‘π€―π³π₯Άπ₯ππ€π€π€­π€«π€₯π¬ππ―π§π₯±π΄π€?π·π€§π€π€ "),
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
