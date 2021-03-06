//
//  Macro.h
//  HTUtilties
//
//  Created by 江海天 on 16/3/22.
//  Copyright © 2016年 江海天. All rights reserved.
//

#ifndef HTMacro_h
#define HTMacro_h

#define SCREEN_WIDTH         ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT        ([[UIScreen mainScreen] bounds].size.height)

#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

#define SYSTEM_VERSION   [[UIDevice currentDevice].systemVersion floatValue]

#ifdef DEBUG
	#define NSLog(format, ...)	do {																			\
									fprintf(stderr, "<%s : %d> %s\n",                                           \
									[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],  \
									__LINE__, __func__);                                                        \
									(NSLog)((format), ##__VA_ARGS__);                                           \
									fprintf(stderr, "-------\n");                                               \
								} while (0)
#else
    #define DLog(s, ...)
    #define NSLog(...)
#endif

#endif /* HTMacro_h */
