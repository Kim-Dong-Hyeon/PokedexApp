//
//  PokemonCell.swift
//  PokedexApp
//
//  Created by 김동현 on 8/8/24.
//

import UIKit
import SnapKit

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
    contentView.addSubview(imageView)
    imageView.frame = contentView.bounds
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // 스크롤시 버벅임 현상 줄이기
  override func prepareForReuse() {
    super.prepareForReuse()
    imageView.image = nil
  }
  
  func configure(with pokemon: PokemonListItem) {
    if let urlString = pokemon.url, let id = getIdFromUrl(urlString) {
      let imageUrl = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png"
      if let url = URL(string: imageUrl) {
        DispatchQueue.global().async {
          if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
            DispatchQueue.main.async {
              self.imageView.image = image
            }
          }
        }
      }
    }
  }
  
  private func getIdFromUrl(_ url: String) -> String? {
    let components = url.split(separator: "/")
    return components.last.map { String($0) }
  }
}
