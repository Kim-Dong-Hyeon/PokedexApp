//
//  MainViewModel.swift
//  PokedexApp
//
//  Created by 김동현 on 8/8/24.
//

import Foundation
import RxSwift

class MainViewModel {
  // 구독 해제를 위한 DisposeBag.
  private let disposeBag = DisposeBag()
  private let limit = 20
  private let offset = 0
  
  // 포켓몬 목록을 담을 BehaviorSubject
  let pokemonListSubject = BehaviorSubject(value: [PokemonListItem]())
  
  init() {
    fetchPokemonList()
  }
  
  // 포켓몬 리스트를 가져오는 함수
  private func fetchPokemonList() {
    guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=\(limit)&offset=\(offset)") else {
      pokemonListSubject.onError(NetworkError.invalidUrl)
      return
    }
    
    NetworkManager.shared.fetch(url: url)
      .subscribe(onSuccess: { [weak self] (response: PokemonListResponse) in
        self?.pokemonListSubject.onNext(response.results)
      }, onFailure: { [weak self] error in
        self?.pokemonListSubject.onError(error)
      }).disposed(by: disposeBag)
  }
}
