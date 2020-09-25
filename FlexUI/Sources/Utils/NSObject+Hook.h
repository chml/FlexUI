//
//  NSObject+Hook.h
//  FlexUI
//
//  Created by Li ChangMing on 2020/9/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol _NSObjectLoadable<NSObject>
+ (void)_flexSwiftLoad;
@end

#define DECL_HOOK_LOADABLE(cls) \
@interface cls(FlexHook) \
@end


DECL_HOOK_LOADABLE(UITableViewCell)

DECL_HOOK_LOADABLE(UICollectionViewCell)

DECL_HOOK_LOADABLE(UIViewController)


NS_ASSUME_NONNULL_END
