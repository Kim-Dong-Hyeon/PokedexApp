//
//  PokemonDetail.swift
//  PokedexApp
//
//  Created by 김동현 on 8/8/24.
//

import Foundation

// 포켓몬의 디테일 정보를 처리하기 위한 구조체
struct PokemonDetail: Codable {
  let id: Int?                  // 포켓몬 ID
  let name: String?             // 포켓몬 이름
  let types: [PokemonTypeSlot]? // 포켓몬 타입 배열
  let height: Int?              // 포켓몬의 키
  let weight: Int?              // 포켓몬의 몸무게
}

// 포켓몬 타입 슬롯 모델 구조체 (타입과 관련된 추가 정보를 담을 수 있음)
struct PokemonTypeSlot: Codable {
  let type: PokemonType         // 포켓몬 타입
}

// 포켓몬 타입 정보를 나타내는 모델 구조체
struct PokemonType: Codable {
  let name: String              // 타입 이름
  
  // 타입 이름을 한국어로 번역하여 반환
  var displayName: String {
    return PokemonTypeName(rawValue: name.lowercased())?.displayName ?? name.capitalized
  }
}
