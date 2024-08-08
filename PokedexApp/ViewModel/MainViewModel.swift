//
//  MainViewModel.swift
//  PokedexApp
//
//  Created by 김동현 on 8/8/24.
//

import Foundation
import RxSwift
import RxRelay

class MainViewModel {
  // 구독 해제를 위한 DisposeBag.
  private let disposeBag = DisposeBag()
  private let limit = 20
  private var offset = 0
  private var isLoading = false
  
  // 포켓몬 목록을 담을 BehaviorRelay
  let pokemonListRelay = BehaviorRelay<[PokemonListItem]>(value: [])
  
  init() {
    fetchPokemonList()
  }
  
  // 포켓몬 리스트를 가져오는 함수
  func fetchPokemonList() {
    guard !isLoading else { return }
    isLoading = true
    
    guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=\(limit)&offset=\(offset)") else {
      return
    }
    
    NetworkManager.shared.fetch(url: url)
      .subscribe(onSuccess: { [weak self] (response: PokemonListResponse) in
        guard let self = self else { return }
        self.offset += self.limit
        var currentList = self.pokemonListRelay.value
        currentList.append(contentsOf: response.results)
        self.pokemonListRelay.accept(currentList)
        self.isLoading = false
      }, onFailure: { [weak self] error in
        self?.isLoading = false
        print("에러 발생: \(error)")
      }).disposed(by: disposeBag)
  }
}
