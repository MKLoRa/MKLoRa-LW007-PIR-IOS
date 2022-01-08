//
//  MKPIRTextButtonCell.h
//  MKLoRaWAN-PIR_Example
//
//  Created by aa on 2021/5/26.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKPIRTextButtonCellModel : NSObject

/// cell唯一识别号
@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *leftMsg;

@property (nonatomic, copy)NSString *rightMsg;

@property (nonatomic, copy)NSString *rightButtonTitle;

@end

@protocol MKPIRTextButtonCellDelegate <NSObject>

/// 用户点击了右侧按钮
/// @param index cell所在序列号
- (void)pir_textButtonCell_buttonAction:(NSInteger)index;

@end

@interface MKPIRTextButtonCell : MKBaseCell

@property (nonatomic, strong)MKPIRTextButtonCellModel *dataModel;

@property (nonatomic, weak)id <MKPIRTextButtonCellDelegate>delegate;

+ (MKPIRTextButtonCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
