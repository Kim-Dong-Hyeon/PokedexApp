//
//  PokemonCell.swift
//  PokedexApp
//
//  Created by 김동현 on 8/8/24.
//

import UIKit
import SnapKit
import Kingfisher

// 포켓몬 목록을 표시하기 위한 컬렉션 뷰 셀 클래스
class PokemonCell: UICollectionViewCell {
  static let id = "PokemonCell"   // 셀 재사용을 위한 식별자
  
  // 포켓몬 이미지를 표시할 이미지 뷰
  let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.backgroundColor = .cellBackground
    imageView.layer.cornerRadius = 10
    return imageView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    [imageView].forEach { contentView.addSubview($0) }
    imageView.snp.makeConstraints { $0.edges.equalToSuperview() }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // 스크롤시 버벅임 현상 줄이기
  // 셀이 재사용될 때 이미지 다운로드를 취소하고 이미지를 초기화
  override func prepareForReuse() {
    super.prepareForReuse()
    imageView.kf.cancelDownloadTask()
    imageView.image = nil
  }
  
  // 포켓몬 데이터를 셀에 저장
  func configure(with pokemon: PokemonListItem) {
    if let urlString = pokemon.url, let id = getIdFromUrl(urlString) {
      let imageUrl = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png"
      if let url = URL(string: imageUrl) {
        imageView.kf.setImage(with: url, placeholder: nil, options: [.transition(.fade(0.2)), .cacheOriginalImage])
      }
    }
  }
  
  // URL에서 포켓몬 ID를 추출(URL에 ID값 포함)
  private func getIdFromUrl(_ url: String) -> String? {
    let components = url.split(separator: "/")
    return components.last.map { String($0) }
  }
}
