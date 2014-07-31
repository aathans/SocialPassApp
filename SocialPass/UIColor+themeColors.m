//
//  UIColor+themeColors.m
//  SocialPass
//
//  Created by Alexander Athan on 6/26/14.
//  Copyright (c) 2014 Dolo. All rights reserved.
//

#import "UIColor+themeColors.h"

@implementation UIColor (themeColors)

+(UIColor *)SPGray{
    return [UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:0.13];
}

+(UIColor *)SPLightGray{
    return [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:0.13];
}

+(UIColor *)SPGraySelected{
    return [UIColor colorWithRed:50.0/255.0 green:50.0/255.0 blue:50.0/255.0 alpha:0.2];
}

+(UIColor *)SPSkipRed{
    return [UIColor colorWithRed:255.0/255.0 green:66.0/255.0 blue:48.0/255.0 alpha:1.0];
}

+(UIColor *)SPJoinGreen{
    return [UIColor colorWithRed:34.0/255.0 green:255.0/255.0 blue:0 alpha:1.0];
}
@end
