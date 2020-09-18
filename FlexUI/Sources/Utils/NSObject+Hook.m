//
//  NSObject+Hook.m
//  FlexUI
//
//  Created by Li ChangMing on 2020/9/18.
//

#import "NSObject+Hook.h"

#define IMPL_HOOK_LOADABLE(cls) \
@implementation cls(FlexHook) \
+ (void)load { \
  [self _flexSwiftLoad]; \
} \
@end \

IMPL_HOOK_LOADABLE(UITableViewCell)

IMPL_HOOK_LOADABLE(UICollectionViewCell)
