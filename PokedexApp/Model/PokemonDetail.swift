//
//  PokemonDetail.swift
//  PokedexApp
//
//  Created by 김동현 on 8/8/24.
//

import Foundation

// 포켓몬의 디테일 정보를 처리하기 위한 구조체
struct PokemonDetail: Codable {
  let id: Int?
  let name: String?
  let types: [PokemonTypeSlot]?
  let height: Int?
  let weight: Int?
}

struct PokemonTypeSlot: Codable {
  let type: PokemonType
}

struct PokemonType: Codable {
  let name: String
  
  var displayName: String {
    return PokemonTypeName(rawValue: name.lowercased())?.displayName ?? name.capitalized
  }
}
