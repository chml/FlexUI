//
//  FlexboxViewController.swift
//  FlexUI_Example
//
//  Created by Li ChangMing on 2020/9/3.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import FlexUI

private func block(color: UIColor = .random, size: CGSize = .init(width: 100, height: 100)) -> AnyNode {
  AnyNode(View(of: UIView.self)
    .width(size.width)
    .height(size.height)
    .viewConfig { (v) in
      v.backgroundColor = color
  })
}

final class FlexboxViewController: UIViewController {
  

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Flexbox Layout"
    view.backgroundColor = .white
    let cond = true

    let shadow = Shadow(color: .gray, offset: .init(x: 0, y: 1), blur: 2)

    let body =
      VStack(spacing: 10) {
        block()
        block()
          .overlay {
            VStack {
              block(size: CGSize(width: 40, height: 40))
              block(size: CGSize(width: 40, height: 40))
            }
            .bottom(10)
            .end(10)
        }

        if cond {
          block(size: CGSize(width: 50, height: 50))
            .alignSelf(.center)
            .dropShadow(shadow)
        }

        HStack(spacing: 8, wrap: .noWrap) {
          ForEach("Hello, FlexUI".uppercased().map { "\($0)" }) {
            Text("\($0)")
              .font(UIFont(name: "Menlo-Bold", size: 20)!)
              .textColor(.random)
              .padding(8)
              .viewConfig { (v) in
                v.backgroundColor = .init(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
                v.layer.cornerRadius = 5
                v.layer.masksToBounds = true
              }
          }
        }
        .padding(of: .horizontal, 8)
        .scrollable()

        block()

        HStack(spacing: 8, wrap: .wrap, lineSpacing: 8) {
          ForEach("Hello, FlexUI".map { "\($0)" }) {
            Text("\($0)")
              .font(UIFont(name: "Menlo-Bold", size: 20)!)
              .textColor(.random)
              .padding(8)
              .viewConfig { (v) in
                v.backgroundColor = .init(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
                v.layer.cornerRadius = 5
                v.layer.masksToBounds = true
            }
          }
        }

        block()
          .alignSelf(.flexEnd)

        Text("سالانيو: أيقن يا سيدي أنني لو خاطرت بمالي مثل مخاطرتك لدرجت أهوائي تتعقب آمالي في تلك الآفاق البعيدة، أو لما وجدني من نشدني إلا عاكفًا على فريعات الأعشاب أستخبرها عن مهاب الرياح، أو مكبًّا على صور الأرض أبحث عن المرافئ والأرصفة والموانئ، فأيما شيء تبينت منه أدنى بأس على أوساقي مت له جزعًا.")
          .textColor(.random)
          .padding(20)
        Text("阿拉伯语源自古语言闪米特语，源自阿拉伯半岛[7]，于5世纪时在北方方言基础上形成统一的文学语言[7]，从公元6世纪开始便有古阿拉伯语的文献，公元7世纪开始，随着伊斯兰帝国的扩张，及阿拉伯人和伊斯兰教传入其他国家，阿拉伯语完全取代了伊拉克、叙利亚、埃及和北非从前使用的语言。许多语言学家认为阿语是闪语系中最接近闪米特祖语的。")
          .padding(40)
          .viewConfig { v in
            v.backgroundColor = .lightGray
          }
      }
      .scrollable()
      .width(.percent(100))
      .height(.percent(100))
      .asAnyNode

    view.flex.render(body)
  }

}

