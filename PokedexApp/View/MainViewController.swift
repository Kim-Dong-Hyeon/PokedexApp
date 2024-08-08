//
//  MainViewController.swift
//  PokedexApp
//
//  Created by 김동현 on 8/8/24.
//

import UIKit
import RxSwift
import SnapKit

// 포켓몬 목록을 표시하는 MainViewController
class MainViewController: UIViewController {
  
  private let viewModel = MainViewModel()       // 뷰 모델 인스턴스
  private let disposeBag = DisposeBag()         // RxSwift의 메모리 관리를 위한 DisposeBag
  private var pokemonList = [PokemonListItem]() // 포켓몬 목록 데이터 저장
  
  // 상단 몬스터볼 이미지 뷰
  private let headerImageView: UIImageView = {
    let imageView = UIImageView(image: UIImage(named: "pokemonBall"))
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()
  
  // 포켓몬 목록을 표시할 컬렉션 뷰
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
  
  // 뷰모델과 뷰를 바인딩하여 데이터를 주고 받는 메서드
  private func bind() {
    viewModel.pokemonListRelay
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: { [weak self] pokemonList in
        self?.pokemonList = pokemonList
        self?.collectionView.reloadData()
      }, onError: { error in
        print("에러 발생: \(error)")
      }).disposed(by: disposeBag)
  }
  
  // 컬렉션 뷰의 레이아웃을 생성하는 메서드
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
  
  // UI를 구성하는 메서드
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
  
  // URL에서 포켓몬 ID를 추출하는 메서드
  private func getIdFromUrl(_ url: String) -> String? {
    let components = url.split(separator: "/")
    return components.last.map { String($0) }
  }
}

// 컬렉션 뷰의 Delegate 메서드를 구현
extension MainViewController: UICollectionViewDelegate {
  // 포켓몬을 선택했을 때 상세 정보 화면으로 이동
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let selectedPokemon = pokemonList[indexPath.row]
    guard let url = selectedPokemon.url, let id = getIdFromUrl(url) else { return }
    let detailViewModel = DetailViewModel(pokemonId: id)
    let detailViewController = DetailViewController(viewModel: detailViewModel)
    navigationController?.pushViewController(detailViewController, animated: true)
  }
  
  // 스크롤 시 추가 데이터를 로드하는 무한 스크롤 구현
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let offsetY = scrollView.contentOffset.y
    let contentHeight = scrollView.contentSize.height
    let height = scrollView.frame.size.height
    print("offsetY: \(offsetY)")
    print("계산 값 : \(contentHeight - height - 200)")
    
    if offsetY > contentHeight - height - 200 {
      viewModel.fetchPokemonList()
    }
  }
}

// 컬렉션 뷰의 DataSource 메서드를 구현
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
