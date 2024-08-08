# PokedexApp 프로젝트 명세서

## 프로젝트 개요
이 프로젝트는 포켓몬 데이터를 활용하여 간단한 포켓몬 도감 애플리케이션을 개발하는 것입니다. 사용자는 포켓몬 목록을 스크롤하며 확인할 수 있으며, 각 포켓몬을 선택하면 해당 포켓몬의 상세 정보를 볼 수 있습니다. 이 프로젝트는 Swift 언어와 RxSwift, Kingfisher 라이브러리를 사용하여 구현되었습니다.

## 주요 기능
1. **포켓몬 목록 표시**
   - 포켓몬 목록을 API로부터 가져와서 `UICollectionView`에 표시합니다.
   - 무한 스크롤을 지원하여 스크롤할 때마다 새로운 포켓몬 데이터를 가져옵니다.

2. **포켓몬 상세 정보 표시**
   - 포켓몬을 선택하면 해당 포켓몬의 상세 정보 페이지로 이동하여 이름, 이미지, 타입, 키, 몸무게 등의 정보를 보여줍니다.
   - 포켓몬 타입과 이름은 한국어로 번역되어 표시됩니다.

3. **이미지 로딩 및 캐싱**
   - 포켓몬 이미지는 Kingfisher 라이브러리를 사용하여 비동기적으로 로드되고 캐싱됩니다.

## 프로젝트 구조
- **Common**
  - `NetworkManager.swift`: 네트워크 요청을 처리하고, API로부터 데이터를 받아오는 싱글톤 네트워크 매니저 클래스.
  - `UIColor+Extensions.swift`: 프로젝트에서 사용되는 색상을 확장한 유틸리티 클래스.
  
- **App**
  - `AppDelegate.swift`: 애플리케이션 시작 시 초기 설정을 담당하는 클래스.

- **Model**
  - `PokemonListItem.swift`: 포켓몬 목록 응답을 처리하기 위한 모델.
  - `PokemonDetail.swift`: 포켓몬 상세 정보를 처리하기 위한 모델.
  - `PokemonTranslator.swift`: 포켓몬 이름을 한국어로 번역하는 유틸리티.
  - `PokemonTypeName.swift`: 포켓몬 타입을 한국어로 번역하는 유틸리티.

- **View**
  - `PokemonCell.swift`: 포켓몬 목록의 각 셀을 구성하는 `UICollectionViewCell` 서브클래스.
  - `MainViewController.swift`: 포켓몬 목록을 보여주는 메인 뷰 컨트롤러.
  - `DetailViewController.swift`: 포켓몬의 상세 정보를 보여주는 뷰 컨트롤러.

- **ViewModel**
  - `MainViewModel.swift`: 메인 화면에 필요한 데이터를 관리하고 처리하는 뷰모델.
  - `DetailViewModel.swift`: 포켓몬의 상세 정보를 관리하고 처리하는 뷰모델.

## 주요 기술 및 라이브러리
- **RxSwift & RxRelay**: 반응형 프로그래밍을 위한 라이브러리로, 데이터 스트림을 관리하고 처리하는 데 사용됩니다. Relay는 Subject와 달리 구독자가 제거되어도 데이터를 유지합니다.
- **SnapKit**: 오토레이아웃을 코드로 간단하게 작성할 수 있게 도와주는 라이브러리.
- **Kingfisher**: 이미지 로딩 및 캐싱을 위한 라이브러리로, 성능을 최적화하고 네트워크 요청을 줄이는 데 사용됩니다.

## 주요 코드 설명
- **NetworkManager.swift**
  - 네트워크 요청을 보내고 JSON 데이터를 디코딩하여 `Single`로 반환하는 기능을 제공.
  
- **PokemonTranslator.swift**
  - 영어로 된 포켓몬 이름을 한국어로 변환하는 기능을 제공.
  
- **PokemonCell.swift**
  - Kingfisher를 사용하여 이미지를 비동기적으로 로드하고 캐싱하며, 스크롤 시 이미지 로딩 버벅임을 줄이기 위해 재사용 로직을 포함.

- **MainViewController.swift & MainViewModel.swift**
  - 포켓몬 목록을 API에서 가져와 `UICollectionView`에 표시하고, 무한 스크롤 기능을 구현.

- **DetailViewController.swift & DetailViewModel.swift**
  - 포켓몬의 상세 정보를 API에서 가져와 사용자에게 표시.

## 사용자 시나리오
1. 앱을 실행하면 포켓몬 목록이 표시됩니다.
2. 사용자는 스크롤을 통해 포켓몬 목록을 확인할 수 있으며, 계속해서 스크롤하면 새로운 포켓몬이 로드됩니다.
3. 포켓몬을 선택하면 상세 정보 화면으로 이동하여 해당 포켓몬의 정보를 확인할 수 있습니다.
4. 상세 정보 화면에서 뒤로 가기를 눌러 목록으로 돌아올 수 있습니다.

이 프로젝트는 간단한 포켓몬 도감을 구현하며, 사용자에게 포켓몬 데이터를 효율적으로 제공하는 것을 목표로 합니다. RxSwift, Kingfisher, SnapKit 등의 라이브러리를 사용하여 코드의 가독성을 높이고 성능을 최적화하였습니다.





