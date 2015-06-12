//
//  DisplayTicketViewController.m
//  Vibez
//
//  Created by Harry Liddell on 07/06/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "DisplayTicketViewController.h"
#import "UIImage+MDQRCode.h"

@interface DisplayTicketViewController ()

@end

@implementation DisplayTicketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat imageSize = ceilf(self.view.bounds.size.width * 0.6f);
    UIImageView *qrImageView = [[UIImageView alloc] initWithFrame:CGRectMake(floorf(self.view.bounds.size.width * 0.5f - imageSize * 0.5f), floorf(self.view.bounds.size.height * 0.5f - imageSize * 0.9f), imageSize, imageSize)];
    [self.view addSubview:qrImageView];
    
    qrImageView.image = [UIImage mdQRCodeForString:@"Hello, world!" size:qrImageView.bounds.size.width fillColor:[UIColor darkGrayColor]];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
