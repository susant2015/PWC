//
//  PWCGraphViewController.h
//  PWC iPhone App
//
//  Created by Samiul Hoque on 9/25/12.
//  Copyright (c) 2012 Samiul Hoque. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWCGraphViewController : UIViewController <CPTBarPlotDataSource, CPTBarPlotDelegate>


@property (strong, nonatomic) IBOutlet CPTGraphHostingView *hstView;
@property (strong, nonatomic) NSString *graphViewTitle;

@property (strong, nonatomic) IBOutlet UILabel *mainLbl;
@property (nonatomic, strong) CPTBarPlot *graphPlot;
@property (nonatomic, strong) CPTPlotSpaceAnnotation *priceAnnotation;
@property (strong, nonatomic) IBOutlet UIView *legendView;

-(void)initPlot;
-(void)configureGraph;
-(void)configurePlots;
-(void)configureAxes;


- (IBAction)closeBox:(id)sender;

@end
