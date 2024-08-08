//
//  DetailViewModel.swift
//  PokedexApp
//
//  Created by 김동현 on 8/8/24.
//

import Foundation
import RxSwift
import RxRelay

class DetailViewModel {
  
  private let disposeBag = DisposeBag()
  let pokemonDetailRelay = BehaviorRelay<PokemonDetail>(value: PokemonDetail(id: nil, name: nil, types: nil, height: nil, weight: nil))
  
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
        var translatedDetail = detail
        if let englishName = detail.name {
          // PokemonDetail 구조체를 수정하여 새로운 값을 설정
          translatedDetail = PokemonDetail(id: detail.id,
                                           name: PokemonTranslator.getKoreanName(for: englishName),
                                           types: detail.types,
                                           height: detail.height,
                                           weight: detail.weight)
        }
        self?.pokemonDetailRelay.accept(translatedDetail)
      }, onFailure: { error in
        print("Error fetching detail: \(error)")
      }).disposed(by: disposeBag)
  }
}
