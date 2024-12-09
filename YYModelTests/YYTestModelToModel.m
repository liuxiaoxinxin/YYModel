//
//  YYTestModelToModel.m
//  YYModel <https://github.com/ibireme/YYModel>
//
//  Created by liujixin on 24/12/09.
//  Copyright (c) 2024 liujixin.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <XCTest/XCTest.h>
#import <UIKit/UIKit.h>
#import "YYModel.h"
#import "YYTestHelper.h"

@interface YYTestModelToModelNestUser : NSObject
@property uint64_t uid;
@property NSString *name;
@end
@implementation YYTestModelToModelNestUser
@end

@interface YYTestModelToModelOne : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, strong) NSNumber *score;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, strong) YYTestModelToModelNestUser *user;

@end
@implementation YYTestModelToModelOne

@end

@interface YYTestModelToModelTwo : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, strong) NSNumber *score;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, strong) YYTestModelToModelNestUser *user;
@end
@implementation YYTestModelToModelTwo

@end


@interface YYTestModelToModelTestCase : XCTestCase

@end

@implementation YYTestModelToModelTestCase


- (void)testtNonnullValue {
    
    YYTestModelToModelOne *model1 = [[YYTestModelToModelOne alloc] init];
    model1.name = @"John Doe";
    model1.age = 30;
    model1.email = @"";
    model1.score = @0;
    model1.user = [YYTestModelToModelNestUser new];

    YYTestModelToModelOne *model2 = [YYTestModelToModelOne new];
    model2.score = @2;
    model2.email = @"xxxx";
    
    [model2 yy_modelSetNonnullValueWithModel:model1 usingEmptyCheck:^BOOL(id  _Nonnull value) {
        if ([value isKindOfClass:[NSString class]] && [value isEqualToString:@""]) {
            return YES;
        }
        if ([value isKindOfClass:[NSNumber class]] && [value isEqualToNumber:@0]) {
            return YES;
        }
        return NO;
    }];
    
    XCTAssertEqualObjects(model2.name, @"John Doe");
    XCTAssertEqual(model2.age, 30);
    
    XCTAssertEqual(model2.score, @2);
    XCTAssertEqual(model2.email, @"xxxx");
    
    XCTAssertNotNil(model2.user);
}

- (void)testAnyModel {
    YYTestModelToModelOne *modelOne = [[YYTestModelToModelOne alloc] init];
    modelOne.name = @"John Doe";
    modelOne.age = 30;
    modelOne.email = @"xxx@gmail.com";
    modelOne.score = @0;
    modelOne.user = [YYTestModelToModelNestUser new];
    modelOne.user.name = @"John Doe";
    modelOne.address = @"HangZhou Xihu";

    YYTestModelToModelTwo *modelTwo = [YYTestModelToModelTwo new];
    modelTwo.name = @"xxx";
    modelTwo.age = 20;
    [modelTwo yy_modelSetWithAnyModel:modelOne];
    
    XCTAssertEqualObjects(modelTwo.name, @"John Doe");
    XCTAssertEqualObjects(modelTwo.user.name, @"John Doe");
    XCTAssertEqualObjects(modelTwo.email, @"xxx@gmail.com");
    XCTAssertEqual(modelTwo.age, 30);

    XCTAssertNil(modelTwo.location);
}

@end
