//
//  DetailViewModel.swift
//  PokedexApp
//
//  Created by 김동현 on 8/8/24.
//

import Foundation
import RxSwift

class DetailViewModel {
  
  private let disposeBag = DisposeBag()
  let pokemonDetail = BehaviorSubject<PokemonDetail>(value: PokemonDetail(id: nil, name: nil, types: nil, height: nil, weight: nil))
  
  init(pokemonId: String) {
    fetchPokemonDetail(id: pokemonId)
  }
  
  private func fetchPokemonDetail(id: String) {
    let urlString = "https://pokeapi.co/api/v2/pokemon/\(id)"
    guard let url = URL(string: urlString) else {
      return
    }
    
    NetworkManager.shared.fetch(url: url)
      .subscribe(onSuccess: { [weak self] (detail: PokemonDetail) in
        self?.pokemonDetail.onNext(detail)
      }, onFailure: { error in
        print("Error fetching detail: \(error)")
      }).disposed(by: disposeBag)
  }
}
