//
//  ISHPermissionRequest+All.h
//  ISHPermissionKit
//
//  Created by Felix Lamouroux on 26.06.14.
//  Copyright (c) 2014 iosphere GmbH. All rights reserved.
//

#import <ISHPermissionKit/ISHPermissionKit.h>

@interface ISHPermissionRequest (All)
+ (ISHPermissionRequest *)requestForCategory:(ISHPermissionCategory)category;
@end