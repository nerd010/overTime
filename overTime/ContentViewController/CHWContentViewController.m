//
//  CHWContentViewController.m
//  overtime
//
//  Created by Charles Wang on 15-9-30.
//  Copyright (c) 2015年 CharlesWang. All rights reserved.
//

#import "CHWContentViewController.h"
#import "CHWTimeLineViewController.h"
#import "CHWViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "ContentModel.h"
#import "ContentDatabase.h"

@interface CHWContentViewController ()<UITextViewDelegate,CLLocationManagerDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *longitude;
@property (weak, nonatomic) IBOutlet UILabel *latitude;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (nonatomic,strong) CLLocationManager *locationManager;

@property (nonatomic,copy) NSString *inputContent;
@property (nonatomic, strong) UITextView *contentTV;

@end

@implementation CHWContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"content";
    
    [self initContentView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_locationManager stopUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initContentView
{
    int originX = [UIScreen mainScreen].bounds.size.width/2 - 250/2;
    _contentTV = [[UITextView alloc] initWithFrame:CGRectMake(originX, 100, 250, 260)];
    _contentTV.delegate = self;
    _contentTV.font = [UIFont systemFontOfSize:15];
    _contentTV.textColor = [UIColor blackColor];
    _contentTV.layer.cornerRadius = 3.0f;
    _contentTV.layer.masksToBounds = YES;
    _contentTV.layer.borderWidth = 2.0f;
    _contentTV.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [self.view addSubview:_contentTV];
    
    int btnOriginX = self.view.frame.size.width / 2 - 200 / 2;
    UIButton *enterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    enterBtn.frame = CGRectMake(btnOriginX, 380, 200, 44);
    [enterBtn setTitle:@"确定" forState:UIControlStateNormal];
    [enterBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [enterBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    enterBtn.tag = 100;
    [enterBtn addTarget:self action:@selector(saveContent:) forControlEvents:UIControlEventTouchUpInside];
    enterBtn.enabled = NO;
    if ([_location.text isEqualToString:@""])
    {
        [enterBtn setTitle:@"请获取当前位置" forState:UIControlStateNormal];
        NSLog(@"请获取当前位置");
    }
    else
    {
        enterBtn.enabled = YES;
    }
    
    enterBtn.layer.cornerRadius = 3.0f;
    enterBtn.layer.masksToBounds = YES;
    enterBtn.layer.borderWidth = 1.0f;
    enterBtn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [self.view addSubview:enterBtn];
}

- (void)saveContent:(UIButton *)button
{
    if ([_contentTV.text isEqualToString:@""] || nil == _contentTV.text)
    {
        __weak typeof (self) weakSelf = self;
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"您还没有输入内容，请确认跳转" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            CHWViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"tabbarViewController"];
            [weakSelf presentViewController:VC animated:YES completion:nil];
        }];
        
        [alertC addAction:cancelAction];
        [alertC addAction:defaultAction];
        [self presentViewController:alertC animated:YES completion:nil];
    }
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *startTimeStr = [ud objectForKey:@"startTimeString"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    ContentModel *contentModel = [[ContentModel alloc] init];
    contentModel.timeString = startTimeStr;
    contentModel.workTimeString = _workTimeString;
    contentModel.dateString = currentDateStr;
    contentModel.stopTimeString = _stopTimeString;
    contentModel.userNameString = @"";
    contentModel.companyString = @"";
    contentModel.contentString = _inputContent;
    contentModel.addressString = _location.text;
    contentModel.overTimeString = _overTimeString;
    [[ContentDatabase sharedManager] create:contentModel];
    
    //保存完成后 将本次的开始时间和工作时间 删除
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"startTimeString"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"workTimeString"];
    [[NSUserDefaults standardUserDefaults] synchronize];
   
    CHWViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"tabbarViewController"];
    [self presentViewController:VC animated:YES completion:nil];
    NSLog(@"saveContent");
}

- (void)addAction:(UIAlertAction *)action
{
    
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    _inputContent = textView.text;
    NSLog(@"text-->%@",textView.text);
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (NSString *)overTimeDurationWithLateTime:(NSDate *)lateTime stopTime:(NSDate *)stopTime
{
    long dd = (long)[stopTime timeIntervalSince1970] - [lateTime timeIntervalSince1970];
    NSString *workTimeString=@"";
    if (dd/3600<1)
    {
        workTimeString = [NSString stringWithFormat:@"%ld", dd/60];
        workTimeString = [self worKDurationTime:workTimeString unitString:@"minutes" unitStr:@"minute"];
    }
    if (dd/3600>1&&dd/86400<1)
    {
        workTimeString = [NSString stringWithFormat:@"%ld", dd/3600];
        workTimeString = [self worKDurationTime:workTimeString unitString:@"hours" unitStr:@"hour"];
    }
    if (dd/86400>1)
    {
        workTimeString = [NSString stringWithFormat:@"%ld", dd/86400];
        workTimeString = [self worKDurationTime:workTimeString unitString:@"days" unitStr:@"day"];
    }
    NSLog(@"workTimeString:%@",workTimeString);
    return workTimeString;
}

- (NSString *)worKDurationTime:(NSString *)worktime
                    unitString:(NSString *)unitString
                       unitStr:(NSString *)unitStr
{
    int workDay = worktime.intValue;
    
    if (workDay >1)
    {
        worktime=[NSString stringWithFormat:@"work for %@ %@", worktime,unitString];
    }
    else
    {
        worktime=[NSString stringWithFormat:@"work for %@ %@", worktime,unitStr];
    }
    
    return worktime;
}


#pragma mark -- CLLocationManagerDelegate

- (IBAction)clickedLocationButton:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if (100 == button.tag)
    {
//        button.titleLabel.text = @"正在获取当前位置";
        [button setTitle:@"正在获取当前位置" forState:UIControlStateNormal];
    }
    _locationManager = [[CLLocationManager alloc] init];
    //设置代理
    _locationManager.delegate=self;
    if (![CLLocationManager locationServicesEnabled])
    {
        NSLog(@"定位服务当前可能尚未打开，请设置打开！");
        return;
    }
    else
    {
        [_locationManager requestLocation];
      
        //设置定位精度
        _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        //定位频率,每隔多少米定位一次
        CLLocationDistance distance=10.0;//十米定位一次
        _locationManager.distanceFilter=distance;
        //启动跟踪定位
        [_locationManager startUpdatingLocation];
    }
    
    //如果没有授权则请求用户授权
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined)
    {
        [_locationManager requestWhenInUseAuthorization];

    }
    else if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse)
    {
        //设置代理
//        _locationManager.delegate=self;
        //设置定位精度
        _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        //定位频率,每隔多少米定位一次
        CLLocationDistance distance=10.0;//十米定位一次
        _locationManager.distanceFilter=distance;
        //启动跟踪定位
        [_locationManager startUpdatingLocation];
    }
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >=9.0)
    {
        _locationManager.allowsBackgroundLocationUpdates = YES;
    }
    else if ([[[UIDevice currentDevice] systemVersion] doubleValue] >=8.0)
    {
        [_locationManager requestWhenInUseAuthorization];
    }
    [_locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
            {
                [_locationManager requestWhenInUseAuthorization];
            }
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
            {
                [_locationManager requestWhenInUseAuthorization];
            }
            break;
        default:            
            break;   
    }
}

- (void)requestAlwaysAuthorization
{
    NSLog(@"1111");
}

//ios6以下
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    _longitude.text = [NSString stringWithFormat:@"%f",newLocation.coordinate.longitude];
    _latitude.text = [NSString stringWithFormat:@"%f",newLocation.coordinate.latitude];
    
    //获取当前城市
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (placemarks.count >0)
        {
            CLPlacemark *placeMark = [placemarks objectAtIndex:0];
            _location.text = placeMark.name;
            
            //获取城市
            NSString *city = placeMark.locality;
            if (!city)
            {
                //四大直辖市无法通过locality获得,只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placeMark.administrativeArea;
            }
            NSLog(@"city-->%@",city);
        }
        else if (error == nil || [placemarks count] == 0)
        {
             NSLog(@"No results were returned.");
        }
        else if (error != nil)
        {
            NSLog(@"An error occurred = %@", error);
        }
    }];
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [manager stopUpdatingLocation];
}

//ios6 以后
//-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
//{
//   
//}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
    CLLocation *currentLocation = [locations lastObject];
    CLLocationCoordinate2D coor = currentLocation.coordinate;
    NSString *longitude = [NSString stringWithFormat:@"%.2f",coor.longitude];
    NSString *latitude = [NSString stringWithFormat:@"%.2f",coor.latitude];
    _longitude.text = longitude;
    _latitude.text = latitude;
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder reverseGeocodeLocation:[locations lastObject]  completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if (placemarks.count > 0)
        {
            CLPlacemark*placeMark = [placemarks objectAtIndex:0];
            
            NSString *city = placeMark.locality;;
            
            if (!city)
            {
                //四大直辖市无法通过locality获得,只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placeMark.administrativeArea;
            }
            if (city)
            {
                UIButton *button = (UIButton *)[self.view viewWithTag:100];
                [button setTitle:@"位置获取完成" forState:UIControlStateNormal];
                button.enabled = YES;
                NSLog(@"位置获取完成");
            }
            _location.text = city;
            NSLog(@"city-->%@",city);
        }
        else if (error == nil || [placemarks count] == 0)
        {
            NSLog(@"No results were returned.");
        }
        else if (error != nil)
        {
            NSLog(@"An error occurred = %@", error);
        }
    }];
    [self.locationManager stopUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if (error.code == kCLErrorDenied)
    {
        // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
        NSLog(@"error-->%ld",(long)error.code);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"警告" message:@"请打开GPS获取位置" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
