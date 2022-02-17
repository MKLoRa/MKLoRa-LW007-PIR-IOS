//
//  MKPIRScanPageCell.m
//  MKLoRaWAN-PIR_Example
//
//  Created by aa on 2021/12/22.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKPIRScanPageCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

#import "MKPIRScanPageModel.h"

@interface MKPIRScanPageCellIconView : UIView

@property (nonatomic, strong)UIImageView *icon;

@property (nonatomic, strong)UILabel *msgLabel;

@end

@implementation MKPIRScanPageCellIconView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.icon];
        [self addSubview:self.msgLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(2.f);
        make.width.mas_equalTo(20.f);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(20.f);
    }];
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.icon.mas_right).mas_offset(5.f);
        make.right.mas_equalTo(-2.f);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
}

#pragma mark - getter
- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
    }
    return _icon;
}

- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.font = MKFont(12.f);
    }
    return _msgLabel;
}

@end

static CGFloat const offset_X = 15.f;
static CGFloat const rssiIconWidth = 20.f;
static CGFloat const rssiIconHeight = 14.f;
static CGFloat const connectButtonWidth = 80.f;
static CGFloat const connectButtonHeight = 30.f;
static CGFloat const batteryIconWidth = 22.f;
static CGFloat const batteryIconHeight = 12.f;

@interface MKPIRScanPageCell ()

@property (nonatomic, strong)UIImageView *rssiIcon;

@property (nonatomic, strong)UILabel *rssiLabel;

@property (nonatomic, strong)UILabel *deviceNameLabel;

@property (nonatomic, strong)UILabel *macLabel;

@property (nonatomic, strong)UIButton *connectButton;

@property (nonatomic, strong)UILabel *txPowerLabel;

@property (nonatomic, strong)UILabel *timeLabel;

@property (nonatomic, strong)UIImageView *batteryIcon;

@property (nonatomic, strong)UILabel *batteryLabel;

@property (nonatomic, strong)MKPIRScanPageCellIconView *voltageView;

@property (nonatomic, strong)MKPIRScanPageCellIconView *temperatureView;

@property (nonatomic, strong)MKPIRScanPageCellIconView *humidityView;

@end

@implementation MKPIRScanPageCell

+ (MKPIRScanPageCell *)initCellWithTableView:(UITableView *)tableView {
    MKPIRScanPageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKPIRScanPageCellIdenty"];
    if (!cell) {
        cell = [[MKPIRScanPageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKPIRScanPageCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.rssiIcon];
        [self.contentView addSubview:self.rssiLabel];
        [self.contentView addSubview:self.deviceNameLabel];
        [self.contentView addSubview:self.macLabel];
        [self.contentView addSubview:self.connectButton];
        [self.contentView addSubview:self.txPowerLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.batteryIcon];
        [self.contentView addSubview:self.batteryLabel];
        [self.contentView addSubview:self.voltageView];
        [self.contentView addSubview:self.temperatureView];
        [self.contentView addSubview:self.humidityView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.rssiIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20.f);
        make.top.mas_equalTo(10.f);
        make.width.mas_equalTo(rssiIconWidth);
        make.height.mas_equalTo(rssiIconHeight);
    }];
    [self.rssiLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.rssiIcon.mas_centerX);
        make.width.mas_equalTo(40.f);
        make.top.mas_equalTo(self.rssiIcon.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(MKFont(10.f).lineHeight);
    }];
    [self.connectButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-offset_X);
        make.width.mas_equalTo(connectButtonWidth);
        make.top.mas_equalTo(5.f);
        make.height.mas_equalTo(connectButtonHeight);
    }];
    CGFloat nameWidth = (kViewWidth - 2 * offset_X - rssiIconWidth - 10.f - 8.f - connectButtonWidth);
    CGSize nameSize = [NSString sizeWithText:self.deviceNameLabel.text
                                     andFont:self.deviceNameLabel.font
                                  andMaxSize:CGSizeMake(nameWidth, MAXFLOAT)];
    [self.deviceNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.rssiIcon.mas_right).mas_offset(15.f);
        make.centerY.mas_equalTo(self.rssiIcon.mas_centerY);
        make.right.mas_equalTo(self.connectButton.mas_left).mas_offset(-8.f);
        make.height.mas_equalTo(nameSize.height);
    }];
    [self.macLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.deviceNameLabel.mas_left);
        make.right.mas_equalTo(self.connectButton.mas_left).mas_offset(-5.f);
        make.top.mas_equalTo(self.deviceNameLabel.mas_bottom).mas_offset(3.f);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.connectButton.mas_left);
        make.width.mas_equalTo(self.connectButton.mas_width);
        make.centerY.mas_equalTo(self.txPowerLabel.mas_centerY);
        make.height.mas_equalTo(MKFont(10.f).lineHeight);
    }];
    [self.batteryIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20.f);
        make.top.mas_equalTo(self.rssiLabel.mas_bottom).mas_offset(3.f);
        make.width.mas_equalTo(batteryIconWidth);
        make.height.mas_equalTo(batteryIconHeight);
    }];
    [self.batteryLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.batteryIcon.mas_centerX);
        make.width.mas_equalTo(40.f);
        make.top.mas_equalTo(self.batteryIcon.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(MKFont(10.f).lineHeight);
    }];
    
    CGFloat offset_X = 15.f;
    CGFloat viewWidth = (self.contentView.frame.size.width - 4 * offset_X) / 3;
    CGFloat viewHeight = 30.f;
    [self.txPowerLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.width.mas_equalTo(viewWidth + 10);
        make.top.mas_equalTo(self.macLabel.mas_bottom).mas_offset(7.f);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.voltageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(offset_X);
        make.width.mas_equalTo(viewWidth);
        make.top.mas_equalTo(self.batteryLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(viewHeight);
    }];
    [self.temperatureView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.width.mas_equalTo(viewWidth);
        make.centerY.mas_equalTo(self.voltageView.mas_centerY);
        make.height.mas_equalTo(viewHeight);
    }];
    [self.humidityView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-offset_X);
        make.width.mas_equalTo(viewWidth);
        make.centerY.mas_equalTo(self.voltageView.mas_centerY);
        make.height.mas_equalTo(viewHeight);
    }];
}

#pragma mark - event method
- (void)connectButtonPressed {
    if ([self.delegate respondsToSelector:@selector(pir_scanCellConnectButtonPressed:)]) {
        [self.delegate pir_scanCellConnectButtonPressed:self.dataModel.index];
    }
}

#pragma mark - setter
- (void)setDataModel:(MKPIRScanPageModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKPIRScanPageModel.class]) {
        return;
    }
    //顶部
    self.rssiLabel.text = [NSString stringWithFormat:@"%lddBm",(long)_dataModel.rssi];
    self.deviceNameLabel.text = (ValidStr(_dataModel.deviceName) ? _dataModel.deviceName : @"N/A");
    self.macLabel.text = [@"MAC: " stringByAppendingString:(ValidStr(_dataModel.macAddress) ? _dataModel.macAddress : @"N/A")];
    self.timeLabel.text = _dataModel.scanTime;
    self.txPowerLabel.text = [NSString stringWithFormat:@"%@%lddBm",@"Tx Power:  ",(long)[_dataModel.txPower integerValue]];
    self.connectButton.hidden = !_dataModel.connectable;
    self.batteryLabel.text = (_dataModel.lowPower ? @"Low" : @"Normal");
    
    //下面的参数
    self.voltageView.msgLabel.text = [_dataModel.battery stringByAppendingString:@" V"];
    if ([_dataModel.temperature isEqualToString:@"ffff"]) {
        //数据无效
        self.temperatureView.icon.hidden = YES;
        self.temperatureView.msgLabel.text = @"";
    }else {
        self.temperatureView.icon.hidden = NO;
        self.temperatureView.msgLabel.text = [_dataModel.temperature stringByAppendingString:@" °C"];
    }
    if ([_dataModel.humidity isEqualToString:@"ffff"]) {
        //数据无效
        self.humidityView.icon.hidden = YES;
        self.humidityView.msgLabel.text = @"";
    }else {
        self.humidityView.icon.hidden = NO;
        self.humidityView.msgLabel.text = [_dataModel.humidity stringByAppendingString:@" %RH"];
    }
}

#pragma mark - getter
- (UIImageView *)rssiIcon {
    if (!_rssiIcon) {
        _rssiIcon = [[UIImageView alloc] init];
        _rssiIcon.image = LOADICON(@"MKLoRaWAN-PIR", @"MKPIRScanPageCell", @"pir_scan_rssiIcon.png");
    }
    return _rssiIcon;
}

- (UILabel *)rssiLabel {
    if (!_rssiLabel) {
        _rssiLabel = [[UILabel alloc] init];
        _rssiLabel.textColor = RGBCOLOR(102, 102, 102);
        _rssiLabel.textAlignment = NSTextAlignmentCenter;
        _rssiLabel.font = MKFont(10.f);
    }
    return _rssiLabel;
}

- (UILabel *)deviceNameLabel {
    if (!_deviceNameLabel) {
        _deviceNameLabel = [[UILabel alloc] init];
        _deviceNameLabel.textAlignment = NSTextAlignmentLeft;
        _deviceNameLabel.font = MKFont(15.f);
        _deviceNameLabel.textColor = DEFAULT_TEXT_COLOR;
    }
    return _deviceNameLabel;
}

- (UILabel *)macLabel {
    if (!_macLabel) {
        _macLabel = [self createLabelWithFont:MKFont(12.f)];
    }
    return _macLabel;
}

- (UIButton *)connectButton{
    if (!_connectButton) {
        _connectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_connectButton setBackgroundColor:NAVBAR_COLOR_MACROS];
        [_connectButton setTitle:@"CONNECT" forState:UIControlStateNormal];
        [_connectButton setTitleColor:COLOR_WHITE_MACROS forState:UIControlStateNormal];
        [_connectButton.titleLabel setFont:MKFont(15.f)];
        [_connectButton.layer setMasksToBounds:YES];
        [_connectButton.layer setCornerRadius:10.f];
        [_connectButton addTarget:self
                           action:@selector(connectButtonPressed)
                 forControlEvents:UIControlEventTouchUpInside];
    }
    return _connectButton;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = DEFAULT_TEXT_COLOR;
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.font = MKFont(10.f);
        _timeLabel.text = @"N/A";
    }
    return _timeLabel;
}

- (UILabel *)txPowerLabel {
    if (!_txPowerLabel) {
        _txPowerLabel = [[UILabel alloc] init];
        _txPowerLabel.textColor = DEFAULT_TEXT_COLOR;
        _txPowerLabel.font = MKFont(12.f);
        _txPowerLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _txPowerLabel;
}

- (UIImageView *)batteryIcon {
    if (!_batteryIcon) {
        _batteryIcon = [[UIImageView alloc] init];
        _batteryIcon.image = LOADICON(@"MKLoRaWAN-PIR", @"MKPIRScanPageCell", @"pir_scan_battery.png");
    }
    return _batteryIcon;
}

- (UILabel *)batteryLabel {
    if (!_batteryLabel) {
        _batteryLabel = [[UILabel alloc] init];
        _batteryLabel.textColor = RGBCOLOR(102, 102, 102);
        _batteryLabel.textAlignment = NSTextAlignmentCenter;
        _batteryLabel.font = MKFont(10.f);
    }
    return _batteryLabel;
}

- (MKPIRScanPageCellIconView *)voltageView {
    if (!_voltageView) {
        _voltageView = [[MKPIRScanPageCellIconView alloc] init];
        _voltageView.icon.image = LOADICON(@"MKLoRaWAN-PIR", @"MKPIRScanPageCell", @"pir_scan_voltageIcon.png");
    }
    return _voltageView;
}

- (MKPIRScanPageCellIconView *)temperatureView {
    if (!_temperatureView) {
        _temperatureView = [[MKPIRScanPageCellIconView alloc] init];
        _temperatureView.icon.image = LOADICON(@"MKLoRaWAN-PIR", @"MKPIRScanPageCell", @"pir_scan_temperature.png");
    }
    return _temperatureView;
}

- (MKPIRScanPageCellIconView *)humidityView {
    if (!_humidityView) {
        _humidityView = [[MKPIRScanPageCellIconView alloc] init];
        _humidityView.icon.image = LOADICON(@"MKLoRaWAN-PIR", @"MKPIRScanPageCell", @"pir_scan_humidity.png");
    }
    return _humidityView;
}

- (UILabel *)createLabelWithFont:(UIFont *)font {
    UILabel *msgLabel = [[UILabel alloc] init];
    msgLabel.textColor = RGBCOLOR(102, 102, 102);
    msgLabel.textAlignment = NSTextAlignmentLeft;
    msgLabel.font = font;
    return msgLabel;
}

@end
