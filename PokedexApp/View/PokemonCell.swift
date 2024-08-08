//
//  PokemonCell.swift
//  PokedexApp
//
//  Created by 김동현 on 8/8/24.
//

import UIKit
import SnapKit
import Kingfisher

class PokemonCell: UICollectionViewCell {
  static let id = "PokemonCell"
  
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
  override func prepareForReuse() {
    super.prepareForReuse()
    imageView.kf.cancelDownloadTask()
    imageView.image = nil
  }
  
  func configure(with pokemon: PokemonListItem) {
    if let urlString = pokemon.url, let id = getIdFromUrl(urlString) {
      let imageUrl = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png"
      if let url = URL(string: imageUrl) {
        imageView.kf.setImage(with: url, placeholder: nil, options: [.transition(.fade(0.2)), .cacheOriginalImage])
      }
    }
  }
  
  private func getIdFromUrl(_ url: String) -> String? {
    let components = url.split(separator: "/")
    return components.last.map { String($0) }
  }
}
