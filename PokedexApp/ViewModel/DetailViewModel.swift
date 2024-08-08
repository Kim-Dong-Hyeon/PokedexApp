//
//  DetailViewModel.swift
//  PokedexApp
//
//  Created by 김동현 on 8/8/24.
//

import Foundation
import RxSwift
import RxRelay

// 포켓몬 상세 정보를 관리하는 ViewModel 클래스
class DetailViewModel {
  
  private let disposeBag = DisposeBag()   // RxSwift의 메모리 관리를 위한 DisposeBag
  // 포켓몬 상세 데이터를 담을 BehaviorRelay, 초기값은 빈 PokemonDetail 객체
  let pokemonDetailRelay = BehaviorRelay<PokemonDetail>(value: PokemonDetail(id: nil, name: nil, types: nil, height: nil, weight: nil))
  
  // 포켓몬 ID를 이용해 초기화
  init(pokemonId: String) {
    fetchPokemonDetail(id: pokemonId)
  }
  
  // 포켓몬 상세 정보를 가져오는 메서드
  private func fetchPokemonDetail(id: String) {
    let urlString = "https://pokeapi.co/api/v2/pokemon/\(id)"
    guard let url = URL(string: urlString) else {
      return
    }
    
    NetworkManager.shared.fetch(url: url)
      .subscribe(onSuccess: { [weak self] (detail: PokemonDetail) in
        var translatedDetail = detail
        if let englishName = detail.name {
          // PokemonDetail 구조체를 수정하여 번역된 값을 설정
          translatedDetail = PokemonDetail(id: detail.id,
                                           name: PokemonTranslator.getKoreanName(for: englishName),
                                           types: detail.types,
                                           height: detail.height,
                                           weight: detail.weight)
        }
        self?.pokemonDetailRelay.accept(translatedDetail)   // relay에 새로운 데이터 저장
      }, onFailure: { error in
        print("Error fetching detail: \(error)")
      }).disposed(by: disposeBag)
  }
}
