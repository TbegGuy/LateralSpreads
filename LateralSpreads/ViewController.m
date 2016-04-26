//
//  ViewController.m
//  LateralSpreads
//
//  Created by CYY033 on 16/4/26.
//  Copyright © 2016年 LYC. All rights reserved.
//

#import "ViewController.h"
#import "LeftViewController.h"
#define backViewTag   2001

@interface ViewController ()<UIGestureRecognizerDelegate>{
    CGPoint point;
    int   transfrom_x;
    int   begin_x;
    UIPanGestureRecognizer * moveRecognizer;


}
@property (nonatomic , strong) LeftViewController *LeftController;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title                = @"主页";
    // Do any additional setup after loading the view, typically from a nib.
    
}
- (void)viewWillAppear:(BOOL)animated{
    //添加手势
    if (!moveRecognizer) {
        moveRecognizer =                   [[UIPanGestureRecognizer alloc]    initWithTarget:self
                                                                                      action:@selector (moveAction:)];
        [moveRecognizer setDelegate:self];
        
        [moveRecognizer setCancelsTouchesInView:NO];
        [self.navigationController.view addGestureRecognizer:moveRecognizer];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)moveAction:(UIPanGestureRecognizer *)gr
{
    UIView *veiw = [self.navigationController.view viewWithTag:backViewTag];
    [veiw removeFromSuperview];
    veiw         = nil;
    
    UIWindow * window = [[UIApplication sharedApplication].delegate window];
    
    if (![window viewWithTag:666]) {
        LeftViewController * LeftView = [[LeftViewController alloc] init];
        LeftView.view.tag = 666;
        self.LeftController = LeftView;
        [window insertSubview:LeftView.view belowSubview:self.navigationController.view];
    }
    if ([gr state] == UIGestureRecognizerStateBegan) {
        point       = self.navigationController.view.frame.origin;
        transfrom_x = 0;
        begin_x     = 0;
    }
    if ([gr state] == UIGestureRecognizerStateChanged)
    {
        CGPoint translation = [gr translationInView:self.navigationController.view];
        transfrom_x         = transfrom_x + translation.x;
        begin_x             = translation.x;
        CGRect rect         = self.navigationController.view.frame;
        if (rect.origin.x + translation.x >  0) {
            self.navigationController.view.frame = CGRectMake(rect.origin.x + translation.x, 0, rect.size.width, rect.size.height);
            [gr setTranslation:CGPointZero inView:self.navigationController.view];
        }else{
            self.navigationController.view.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);;
        }
        
    }
    if ([gr state] == UIGestureRecognizerStateEnded) {
        if (point.x < MainScreen_Width/2) {
            if (transfrom_x > 0 && begin_x > 0) {
                self.isMoving    = !_isMoving;
                if (![self.navigationController.view viewWithTag:backViewTag]) {
                    UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
                    view.backgroundColor = [UIColor blackColor];
                    view.alpha           = 0.7;
                    view.tag             = backViewTag;
                    UITapGestureRecognizer *singleTap =
                    [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(whenClickView)];
                    singleTap.numberOfTouchesRequired = 1;
                    singleTap.numberOfTapsRequired = 1;
                    [view addGestureRecognizer:singleTap];
                    [self.navigationController.view addSubview:view];
                }
                [self setupMoving];
            }else{
                self.isMoving = !_isMoving;
                UIView *view = [self.navigationController.view viewWithTag:backViewTag];
                [view removeFromSuperview];
                view = nil;
                
                [self setUpStopMoving];
            }
        }else{
            if (transfrom_x < 0 && begin_x < 0 ) {
                self.isMoving = !_isMoving;
                UIView *view = [self.navigationController.view viewWithTag:backViewTag];
                [view removeFromSuperview];
                view = nil;
                [self setUpStopMoving];
            }else{
                self.isMoving = !_isMoving;
                if (![self.navigationController.view viewWithTag:backViewTag]) {
                    UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
                    view.backgroundColor = [UIColor blackColor];
                    view.alpha           = 0.7;
                    view.tag             = backViewTag;
                    UITapGestureRecognizer *singleTap =
                    [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(whenClickView)];
                    singleTap.numberOfTouchesRequired = 1;
                    singleTap.numberOfTapsRequired = 1;
                    [view addGestureRecognizer:singleTap];
                    [self.navigationController.view addSubview:view];
                }
                [self setupMoving];
            }
        }
        
    }
    
    
}
-(void)setupMoving {
    NSDictionary *dict = [[NSDictionary alloc]init];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reHttp" object:self userInfo:dict];
    CGRect bounds      = [UIScreen mainScreen].bounds;
    CGFloat width      = bounds.size.width;
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame   = self.navigationController.view.frame;
        frame.origin.x = width * 0.8;
        self.navigationController.view.frame = frame;
    }];
    
    
}
-(void)setUpStopMoving {
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame   = self.navigationController.view.frame;
        frame.origin.x = 0;
        self.navigationController.view.frame = frame;
    }];
    
}
- (void)whenClickView{
    UIView *view = [self.navigationController.view viewWithTag:backViewTag];
    [view removeFromSuperview];
    view         = nil;
    if (self.navigationController.view.frame.origin.x != 0) {
        self.isMoving = !_isMoving;
        [self setUpStopMoving];
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [self.navigationController.view removeGestureRecognizer:moveRecognizer];
    moveRecognizer = nil;
}
@end
