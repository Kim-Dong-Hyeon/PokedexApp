//
//  DetailViewController.swift
//  PokedexApp
//
//  Created by 김동현 on 8/8/24.
//

import UIKit
import SnapKit
import RxSwift

class DetailViewController: UIViewController {
  
  private let viewModel: DetailViewModel
  private let disposeBag = DisposeBag()
  
  private let containerView: UIView = {
    let view = UIView()
    view.backgroundColor = .darkRed
    view.layer.cornerRadius = 20
    return view
  }()
  
  private let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()
  
  private let nameLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 30)
    label.textAlignment = .center
    label.textColor = .white
    return label
  }()
  
  private let typeLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 20)
    label.textAlignment = .center
    label.textColor = .white
    return label
  }()
  
  private let heightLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 20)
    label.textAlignment = .center
    label.textColor = .white
    return label
  }()
  
  private let weightLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 20)
    label.textAlignment = .center
    label.textColor = .white
    return label
  }()
  
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
  
  private func bind() {
    viewModel.pokemonDetail
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
