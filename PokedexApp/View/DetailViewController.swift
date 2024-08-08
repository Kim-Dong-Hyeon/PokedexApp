//
//  DetailViewController.swift
//  PokedexApp
//
//  Created by 김동현 on 8/8/24.
//

import UIKit
import SnapKit
import RxSwift

// 포켓몬 상세 정보를 표시하는 뷰 컨트롤러 클래스
class DetailViewController: UIViewController {
  
  private let viewModel: DetailViewModel    // 뷰 모델 인스턴스
  private let disposeBag = DisposeBag()     // RxSwift의 메모리 관리를 위한 DisposeBag
  
  // 상세 정보 화면의 컨테이너 뷰
  private let containerView: UIView = {
    let view = UIView()
    view.backgroundColor = .darkRed
    view.layer.cornerRadius = 20
    return view
  }()
  
  // 포켓몬 이미지를 표시할 이미지 뷰
  private let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()
  
  // 포켓몬 이름을 표시할 레이블
  private let nameLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 30)
    label.textAlignment = .center
    label.textColor = .white
    return label
  }()
  
  // 포켓몬 타입을 표시할 레이블
  private let typeLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 20)
    label.textAlignment = .center
    label.textColor = .white
    return label
  }()
  
  // 포켓몬 키를 표시할 레이블
  private let heightLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 20)
    label.textAlignment = .center
    label.textColor = .white
    return label
  }()
  
  // 포켓몬 몸무게를 표시할 레이블
  private let weightLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 20)
    label.textAlignment = .center
    label.textColor = .white
    return label
  }()
  
  // 초기화 메서드
  init(viewModel: DetailViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    bind()
  }
  
  // UI를 구성하는 메서드
  private func configureUI() {
    view.backgroundColor = .mainRed
    
    [containerView].forEach { view.addSubview($0) }
    
    [
      imageView,
      nameLabel,
      typeLabel,
      heightLabel,
      weightLabel
    ].forEach { containerView.addSubview($0) }
    
    containerView.snp.makeConstraints {
      $0.center.equalToSuperview()
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.height.equalTo(view.frame.height / 2)
    }
    
    imageView.snp.makeConstraints {
      $0.top.equalTo(containerView.snp.top).offset(20)
      $0.centerX.equalToSuperview()
      $0.width.height.equalTo(200)
    }
    
    nameLabel.snp.makeConstraints {
      $0.top.equalTo(imageView.snp.bottom).offset(20)
      $0.centerX.equalToSuperview()
    }
    
    typeLabel.snp.makeConstraints {
      $0.top.equalTo(nameLabel.snp.bottom).offset(10)
      $0.centerX.equalToSuperview()
    }
    
    heightLabel.snp.makeConstraints {
      $0.top.equalTo(typeLabel.snp.bottom).offset(10)
      $0.centerX.equalToSuperview()
    }
    
    weightLabel.snp.makeConstraints {
      $0.top.equalTo(heightLabel.snp.bottom).offset(10)
      $0.centerX.equalToSuperview()
    }
  }
  
  // 뷰모델과 뷰를 바인딩하여 데이터를 주고 받는 메서드
  private func bind() {
    viewModel.pokemonDetailRelay
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: { [weak self] detail in
        guard let self = self else { return }
        self.nameLabel.text = "No.\(detail.id ?? 0) \(detail.name?.capitalized ?? "")"
        self.typeLabel.text = "타입: \(detail.types?.first?.type.displayName ?? "")"
        self.heightLabel.text = "키: \((Double(detail.height ?? 0) / 10)) m"
        self.weightLabel.text = "몸무게: \((Double(detail.weight ?? 0) / 10)) kg"
        
        if let id = detail.id {
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
      }).disposed(by: disposeBag)
  }
}
