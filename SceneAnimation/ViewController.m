//
//  ViewController.m
//  SceneAnimation
//
//  Created by 罗富中 on 16/6/3.
//  Copyright © 2016年 social-touch. All rights reserved.
//

#import "ViewController.h"
#import "ContainerViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)click:(id)sender {
    [self.navigationController pushViewController:[[ContainerViewController alloc]init] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
