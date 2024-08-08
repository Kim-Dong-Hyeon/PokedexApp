//
//  MainViewModel.swift
//  PokedexApp
//
//  Created by 김동현 on 8/8/24.
//

import Foundation
import RxSwift
import RxRelay

// 메인 화면의 데이터와 로직을 관리하는 ViewModel 클래스
class MainViewModel {
  // 구독 해제를 위한 DisposeBag.
  private let disposeBag = DisposeBag() // RxSwift의 메모리 관리를 위한 DisposeBag
  private let limit = 20                // 한 번에 가져올 포켓몬의 개수
  private var offset = 0                // 현재까지 가져온 포켓몬의 개수
  private var isLoading = false         // 데이터 로드 중인지 여부
  
  // 포켓몬 목록을 담을 BehaviorRelay, 데이터의 초기값은 빈 배열
  let pokemonListRelay = BehaviorRelay<[PokemonListItem]>(value: [])
  
  init() {
    fetchPokemonList()  // 초기 포켓몬 데이터를 가져옴
  }
  
  // 포켓몬 리스트를 가져오는 함수
  func fetchPokemonList() {
    guard !isLoading else { return }    // 이미 로딩 중이면 작업을 중단
    isLoading = true
    
    guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=\(limit)&offset=\(offset)") else {
      return
    }
    
    NetworkManager.shared.fetch(url: url)
      .subscribe(onSuccess: { [weak self] (response: PokemonListResponse) in
        guard let self = self else { return }
        self.offset += self.limit                         // 다음 로드를 위해 offset 증가
        var currentList = self.pokemonListRelay.value     // 현재 목록을 가져옴
        currentList.append(contentsOf: response.results)  // 새로 가져온 데이터를 추가
        self.pokemonListRelay.accept(currentList)         // 변경된 목록을 relay에 저장
        self.isLoading = false                            // 로딩 상태를 해제
      }, onFailure: { [weak self] error in
        self?.isLoading = false                           // 로딩 상태를 해제
        print("에러 발생: \(error)")
      }).disposed(by: disposeBag)
  }
}
