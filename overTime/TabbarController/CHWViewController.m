//
//  CHWViewController.m
//  overtime
//
//  Created by Charles Wang on 15-9-29.
//  Copyright (c) 2015年 CharlesWang. All rights reserved.
//

#import "CHWViewController.h"
#import "CHWWorkViewController.h"

@interface CHWViewController () <UIActionSheetDelegate>

@property (nonatomic,strong)UIView *popView;//点击"+"号弹出的视图,高斯模糊效果

@end

@implementation CHWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configTabbarView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 点击自定义的那个tabbar视图上的按钮

-(void)tapButton:(UIButton *)button
{
    if (button.tag == 1)//点击加号按钮 可以自定义一些控件加上动画的效果
    {
//        [button setTitle:@"1" forState:UIControlStateNormal];
        [self configPopView];
    }
    else if(button.tag >= 1) //因为有3个按钮,现在只有2个ViewController,selectedIndex会向前移动一个
    {
        [self setSelectedIndex:button.tag-1];
    }
    else
    {
        [self setSelectedIndex:button.tag]; //给tabbar设置选中的ViewController
    }
}

#pragma mark - 配置tabbarView

- (void)configTabbarView
{
    self.tabBar.hidden=YES;//隐藏掉系统的bar
    UIScreen *s=[UIScreen mainScreen];
    CGFloat wid=[s bounds].size.width;
    CGFloat height=[s bounds].size.height;
    CGFloat buttonWidth = 80.0f;
    CGFloat place = (wid - buttonWidth * 3)/4;
    self.tabbarView=[[UIView alloc]initWithFrame:CGRectMake(0, height-48, wid, 48)];
    self.tabbarView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:self.tabbarView];//自定的tabbar
    for (int i=0; i<3; i++)  //自定义的贴上按钮3个
    {
        if (i == 0 || i == 2)
        {
            continue;
        }
        UIButton *button=[UIButton buttonWithType:UIButtonTypeContactAdd];
        button.frame=CGRectMake(place + (buttonWidth +place )*i, 0, buttonWidth, 48);
//        [button setTitle:[NSString stringWithFormat:@"%d",i] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor colorWithRed:0/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        button.tag=i;
        [button addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.tabbarView addSubview:button];
    }
}

#pragma mark - 初始化弹出的视图

- (void)configPopView
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"开始工作",@"我下班了！", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    [actionSheet showInView:self.view];
    [self.view addSubview:self.popView];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"buttonIndex == %ld",(long)buttonIndex);
    switch (buttonIndex) {
        case 0:
        {
            CHWWorkViewController *workVC = [self.storyboard instantiateViewControllerWithIdentifier:@"WorkViewController"];
            [self presentViewController:workVC animated:YES completion:nil];
        }
            break;
        case 1:
        {
            
        }
            break;
        case 2:
        {
            
        }
            break;
        default:
            break;
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
