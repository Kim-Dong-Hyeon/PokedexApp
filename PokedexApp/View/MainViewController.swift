//
//  MainViewController.swift
//  PokedexApp
//
//  Created by 김동현 on 8/8/24.
//

import UIKit
import RxSwift
import SnapKit

class MainViewController: UIViewController {
  
  private let viewModel = MainViewModel()
  private let disposeBag = DisposeBag()
  private var pokemonList = [PokemonListItem]()
  
  private let headerImageView: UIImageView = {
    let imageView = UIImageView(image: UIImage(named: "pokemonBall"))
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()
  
  private lazy var collectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    collectionView.register(PokemonCell.self, forCellWithReuseIdentifier: PokemonCell.id)
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.backgroundColor = .darkRed
    return collectionView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    bind()
    configureUI()
  }
  
  private func bind() {
    viewModel.pokemonListSubject
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: { [weak self] pokemonList in
        self?.pokemonList = pokemonList
        self?.collectionView.reloadData()
      }, onError: { error in
        print("에러 발생: \(error)")
      }).disposed(by: disposeBag)
  }
  
  private func createLayout() -> UICollectionViewLayout {
    
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1/3),
      heightDimension: .fractionalHeight(1.0)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .fractionalWidth(1/3)
    )
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    group.interItemSpacing = .fixed(10)
    group.contentInsets = .init(top: 5, leading: 5, bottom: 5, trailing: 5)
    
    let section = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .none
    
    return UICollectionViewCompositionalLayout(section: section)
  }
  
  private func configureUI() {
    view.backgroundColor = .mainRed
    
    [
      headerImageView,
      collectionView
    ].forEach { view.addSubview($0) }
    
    headerImageView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      $0.centerX.equalToSuperview()
      $0.width.height.equalTo(100)
    }
    
    collectionView.snp.makeConstraints {
      $0.top.equalTo(headerImageView.snp.bottom).offset(20)
      $0.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
    }
  }
  private func getIdFromUrl(_ url: String) -> String? {
    let components = url.split(separator: "/")
    return components.last.map { String($0) }
  }
}

extension MainViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let selectedPokemon = pokemonList[indexPath.row]
    guard let url = selectedPokemon.url, let id = getIdFromUrl(url) else { return }
    let detailViewModel = DetailViewModel(pokemonId: id)
    let detailViewController = DetailViewController(viewModel: detailViewModel)
    navigationController?.pushViewController(detailViewController, animated: true)
  }
}

extension MainViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return pokemonList.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonCell.id, for: indexPath) as? PokemonCell else {
      return UICollectionViewCell()
    }
    
    let pokemon = pokemonList[indexPath.row]
    cell.configure(with: pokemon)
    return cell
  }
  
  
}
