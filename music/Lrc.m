//
//  Lrc.m
//  music
//
//  Created by mac on 16/3/29.
//  Copyright (c) 2016年 lzc. All rights reserved.
//

#import "Lrc.h"

@implementation Lrc

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.songArr = [NSMutableArray array];
        self.timeArr = [NSMutableArray array];
    }
    return self;
}

- (void)parserLrcWithPath:(NSString *)path
{
    [self.timeArr removeAllObjects];
    [self.songArr removeAllObjects];
    NSString *str = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSArray *arr = [str componentsSeparatedByString:@"["];
    for (NSString *sepLrc in arr) {
        NSArray *array = [sepLrc componentsSeparatedByString:@"]"];
        
        if(!([array[0] isEqualToString:@""] || [array[1] isEqualToString:@"\r\n"] || [array[1] isEqualToString:@"\n"]))
        {
            [self.timeArr addObject:array[0]];
            [self.songArr addObject:array[1]];
        }
    }
    
}

@end
