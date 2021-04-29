//
//  NSObject+SwiftLoad.h
//  FlexUI
//
//  Created by Li ChangMing on 2020/9/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define SWIFT_LOAD_DECL(cls, category) \
@protocol _##category##_##cls##_Loadable<NSObject> \
+ (void)_##category##_##cls##_SwiftLoad;\
@end;\
@interface cls(category) \
@end;\
@implementation cls(category) \
+ (void)load { [[self class] _##category##_##cls##_SwiftLoad]; } \
@end; \


SWIFT_LOAD_DECL(UITableViewCell, FlexUI)
SWIFT_LOAD_DECL(UICollectionViewCell, FlexUI)
SWIFT_LOAD_DECL(UIViewController, FlexUI)

NS_ASSUME_NONNULL_END
