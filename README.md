# FlexUI (WIP)
> A iOS Layout Framework inspired by SwiftUI

; [![CI Status](https://img.shields.io/travis/chmlaiii@gmail.com/FlexUI.svg?style=flat)](https://travis-ci.org/chmlaiii@gmail.com/FlexUI)
; [![Version](https://img.shields.io/cocoapods/v/FlexUI.svg?style=flat)](https://cocoapods.org/pods/FlexUI)
; [![License](https://img.shields.io/cocoapods/l/FlexUI.svg?style=flat)](https://cocoapods.org/pods/FlexUI)
; [![Platform](https://img.shields.io/cocoapods/p/FlexUI.svg?style=flat)](https://cocoapods.org/pods/FlexUI)

## Requirements
* iOS 11
* Swift 5

## Installation
### CocoaPods
```ruby
pod 'FlexUI'
```
## Usage
### Features
* SwiftUI-Like Syntax
* UIKit firendly
* Flexbox layout, backed by `facebook/yoga`
* Flexible text render, backed by `meitu/MPITextKit`
* Build-in Image Loading, backed by `kean/Nuke`
* Differentable ListView(`UITableView`, `UICollectionView`), backby `ra1028/DifferenceKit`

```swift
final class CounterDemoViewController: UIViewController, Component {

  typealias Body = AnyNode

  var fontSize: Int = 12

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Counter"
    view.backgroundColor = .white
    flex.render()
  }

  func body(with coordinator: SimpleCoordinator<CounterDemoViewController>) -> AnyNode {
    VStack(spacing: 20, justifyContent: .center, alignItems: .center) {
      Text("\(coordinator.content.fontSize)")
        .font(.boldSystemFont(ofSize: CGFloat(coordinator.content.fontSize)))
        .padding(UIEdgeInsets(top: 5, left: 8, bottom: 5, right: 8))
        .viewConfig { (label) in
          label.backgroundColor = .gray
        }
      HStack(spacing: 20) {
        Button("-1") {
          coordinator.update(animated: true) {
            $0.fontSize -= 1
          }
        }
        .viewReuseID("-")
        Button("+1") {
          coordinator.update(animated: true) {
            $0.fontSize += 1
          }
        }
        .viewReuseID("+")
      }
    }
    .width(.percent(100))
    .height(.percent(100))
    .asAnyNode
  }
}

```

### More Example
To run the example project, clone the repo, and run `pod install` from the Example directory first.


## Author

chmlaiii@gmail.com

## Credits
* [facebook/yoga](https://github.com/facebook/yoga)
* [ra1028/Carbon](https://github.com/ra1028/Carbon)
* [LinkedInAttic/LayoutKit](https://github.com/LinkedInAttic/LayoutKit)
* [meitu/MPITextKit](https://github.com/meitu/mpitextkit)
* [kean/Nuke](https://github.com/kean/Nuke)


## License

FlexUI is available under the MIT license. See the LICENSE file for more info.
