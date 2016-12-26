//
//  ViewController.m
//  Countdown
//
//  Created by txx on 16/12/26.
//  Copyright © 2016年 txx. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

{
    dispatch_source_t _timer;
}
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *hourLabel;
@property (weak, nonatomic) IBOutlet UILabel *minuteLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDate *end_date = [self end_dateString:@"2016-12-28 16:01:00"];
    NSTimeInterval interval = [end_date timeIntervalSinceNow];

    if (_timer) return;
    
    __block int timeout = (int)interval ;
    if (timeout == 0) return;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //每秒执行
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0);
    
    dispatch_source_set_event_handler(_timer, ^{
        if (timeout <= 0) { //倒计时结束。关闭
            dispatch_source_cancel(_timer);
            _timer = nil ;
            dispatch_async(dispatch_get_main_queue(), ^{
                self.dayLabel.text = @"";
                self.hourLabel.text = @"00";
                self.minuteLabel.text = @"00";
                self.secondLabel.text = @"00";
            });
        }else
        {
            int day = (int)timeout/(3600 * 24);
            int hour = (int)(timeout - day * 3600 * 24)/3600;
            int minute = (int)(timeout-day*24*3600-hour*3600)/60;
            int second = timeout-day*24*3600-hour*3600-minute*60;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (day==0) {
                    self.dayLabel.text = @"0天";
                }else{
                    self.dayLabel.text = [NSString stringWithFormat:@"%d天",day];
                }
                if (hour<10) {
                    self.hourLabel.text = [NSString stringWithFormat:@"0%d",hour];
                }else{
                    self.hourLabel.text = [NSString stringWithFormat:@"%d",hour];
                }
                if (minute<10) {
                    self.minuteLabel.text = [NSString stringWithFormat:@"0%d",minute];
                }else{
                    self.minuteLabel.text = [NSString stringWithFormat:@"%d",minute];
                }
                if (second<10) {
                    self.secondLabel.text = [NSString stringWithFormat:@"0%d",second];
                }else{
                    self.secondLabel.text = [NSString stringWithFormat:@"%d",second];
                }
                
            });
            timeout--;

        }
    });
    dispatch_resume(_timer);
}
-(NSDate *)end_dateString:(NSString *)string
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *end_date = [formatter dateFromString:string];
    return end_date ;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
