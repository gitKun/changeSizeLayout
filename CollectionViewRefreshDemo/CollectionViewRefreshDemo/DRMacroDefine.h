//
//  DRMacroDefine.h
//  CollectionViewRefreshDemo
//
//  Created by 李亚坤 on 2019/10/13.
//  Copyright © 2019 DR_Kun. All rights reserved.
//

#ifndef DRMacroDefine_h
#define DRMacroDefine_h



#ifdef __GNUC__
__unused static void cleanUpBlock(__strong void(^*block)(void)) {
    (*block)();
}

#define OnBlockExit(block_name) __strong void(^block_name)(void) __attribute__((cleanup(cleanUpBlock), unused)) = ^

#endif


#endif /* DRMacroDefine_h */
