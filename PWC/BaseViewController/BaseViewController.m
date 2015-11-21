//
//  BaseViewController.m
//  PWC
//
//  Created by Rubel Debnath on 21/11/15.
//  Copyright © 2015 Premium Web Cart. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showAlertWithTitle:(NSString*)strtitle andMessage:(NSString*)strmessage{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:strtitle
                                  message:strmessage
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"ok"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    //Handel your yes please button action here
                                    [alert dismissViewControllerAnimated:YES completion:nil];
                                    
                                }];
    
    [alert addAction:yesButton];
    
    [self presentViewController:alert animated:YES completion:nil];
    

    
}
@end
