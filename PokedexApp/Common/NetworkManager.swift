//
//  NetworkManager.swift
//  PokedexApp
//
//  Created by 김동현 on 8/8/24.
//

import Foundation
import RxSwift

// 네트워크 요청과 관련된 오류 정의
enum NetworkError: Error {
  case invalidUrl
  case dataFetchFail
  case decodingFail
}

// 네트워크 로직이 필요할때 앱의 모든 곳에서 사용할 수 있는 싱글톤 네트워크 매니저.
class NetworkManager {
  static let shared = NetworkManager()  // 싱글톤 인스턴스(외부에서 공유받아 사용)
  private init() {}   // 외부에서 생성하지 못하게 private 초기화
  
  // 네트워크 로직을 수행하고, 결과를 Single 로 리턴함.
  // Single 은 오직 한 번만 값을 뱉는 Observable 이기 때문에 서버에서 데이터를 한 번 불러올 때 적절.
  // 제네릭을 이용한 네트워크 요청 메서드, Decodable을 준수하는 모든 타입을 지원.
  func fetch<T: Decodable>(url: URL) -> Single<T> {
    return Single.create { observer in
      let session = URLSession(configuration: .default) // 기본 세션 구성
      session.dataTask(with: URLRequest(url: url)) { data, response, error in
        // error 가 있다면 Single 에 fail 방출.
        if let error = error {
          observer(.failure(error))
          return
        }
        
        // data 가 없거나 http 통신 에러 일 때 dataRetchFail 방출.
        guard let data = data,
              let response = response as? HTTPURLResponse,
              (200..<300).contains(response.statusCode) else {
          observer(.failure(NetworkError.dataFetchFail))
          return
        }
        
        do {
          // data 를 받고 json 디코딩 과정까지 성공한다면 결과를 success 와 함께 방출.
          let decodedData = try JSONDecoder().decode(T.self, from: data)
          observer(.success(decodedData))
        } catch {
          // 디코딩 실패했다면 decodingFail 방출.
          observer(.failure(NetworkError.decodingFail))
        }
      }.resume()
      
      return Disposables.create()
    }
  }
}
