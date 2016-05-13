//
//  Lrc.h
//  music
//
//  Created by mac on 16/3/29.
//  Copyright (c) 2016年 lzc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Lrc : NSObject

@property (nonatomic,strong)NSMutableArray *songArr;

@property (nonatomic,strong)NSMutableArray *timeArr;

- (void)parserLrcWithPath:(NSString *)path;

@end
