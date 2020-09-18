//
//  Data.swift
//  FlexUI_Example
//
//  Created by Li ChangMing on 2020/9/17.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation

let imageURLs:[URL] = [
  URL(string: "https://s3.ifanr.com/wp-content/uploads/2020/09/www.gif")!,
  URL(string: "https://s3.ifanr.com/wp-content/uploads/2020/09/daima8.jpg!720")!,
  URL(string: "https://s3.ifanr.com/wp-content/uploads/2020/09/chengfengpolangdejiejie.jpg!720")!,
  URL(string: "https://s3.ifanr.com/wp-content/uploads/2020/08/wukong.jpg!720")!,
  URL(string: "https://s3.ifanr.com/wp-content/uploads/2020/08/IMB_ZX07DS.gif")!,
  URL(string: "https://s3.ifanr.com/wp-content/uploads/2020/08/p2544088909.jpg!720")!,
//  Bundle.main.url(forResource: "IMB_ZX07DS", withExtension: "gif")!,
]

func randomImageURL() -> URL {
  return imageURLs.randomElement()!
}
