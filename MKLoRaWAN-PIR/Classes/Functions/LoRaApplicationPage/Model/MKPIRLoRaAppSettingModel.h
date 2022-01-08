//
//  MKPIRLoRaAppSettingModel.h
//  MKLoRaWAN-PIR_Example
//
//  Created by aa on 2021/5/21.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKPIRLoRaAppSettingModel : NSObject

@property (nonatomic, copy)NSString *timeSyncInterval;

@property (nonatomic, copy)NSString *checkInterval;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
