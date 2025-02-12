//
//  PokemonListItem.swift
//  PokedexApp
//
//  Created by 김동현 on 8/8/24.
//

import Foundation

// 포켓몬 목록 응답을 처리하기 위한 구조체
struct PokemonListResponse: Codable {
  let results: [PokemonListItem]  // 포켓몬 목록 배열
}

// 각 포켓몬의 간략한 정보를 담는 구조체
struct PokemonListItem: Codable {
  let name: String?   // 포켓몬 이름
  let url: String?    // 포켓몬의 상세 정보를 가져올 수 있는 URL
}
