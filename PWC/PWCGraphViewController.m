//
//  PWCGraphViewController.m
//  PWC iPhone App
//
//  Created by Samiul Hoque on 9/25/12.
//  Copyright (c) 2012 Samiul Hoque. All rights reserved.
//

#import "PWCGraphViewController.h"
#import "PWCGlobal.h"
#import "PWCGraphData.h"

@interface PWCGraphViewController ()

@end

@implementation PWCGraphViewController

CGFloat const CPDBarWidth = 0.5f;
CGFloat const CPDBarInitialX = 0.5f;

@synthesize mainLbl;
@synthesize hstView;
@synthesize graphViewTitle;
@synthesize graphPlot;
@synthesize priceAnnotation;
@synthesize legendView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.mainLbl.text = self.graphViewTitle;
    [self initPlot];
    [SVProgressHUD dismiss];
    //NSLog(@"%@",[PWCGraphData getGraphData].yValues);
    UILabel *productVal = (UILabel *)[legendView viewWithTag:201];
    UILabel *discountVal = (UILabel *)[legendView viewWithTag:202];
    UILabel *shipmentVal = (UILabel *)[legendView viewWithTag:203];
    UILabel *taxVal = (UILabel *)[legendView viewWithTag:204];
    UILabel *totalVal = (UILabel *)[legendView viewWithTag:205];
    
    //NSString *pv = [[[PWCGraphData getGraphData] graphYValues] objectAtIndex:0];
    productVal.text = [NSString stringWithFormat:@"%@%.2f",[PWCGlobal getTheGlobal].currencySymbol, [[[[PWCGraphData getGraphData] graphYValues] objectAtIndex:0] floatValue]];
    discountVal.text = [NSString stringWithFormat:@"%@%.2f",[PWCGlobal getTheGlobal].currencySymbol, fabsf([[[[PWCGraphData getGraphData] graphYValues] objectAtIndex:1] floatValue])];
    shipmentVal.text = [NSString stringWithFormat:@"%@%.2f",[PWCGlobal getTheGlobal].currencySymbol, [[[[PWCGraphData getGraphData] graphYValues] objectAtIndex:2] floatValue]];
    taxVal.text = [NSString stringWithFormat:@"%@%.2f",[PWCGlobal getTheGlobal].currencySymbol, [[[[PWCGraphData getGraphData] graphYValues] objectAtIndex:3] floatValue]];
    totalVal.text = [NSString stringWithFormat:@"%@%.2f",[PWCGlobal getTheGlobal].currencySymbol, [PWCGraphData getGraphData].totalVal];
    
    CGFloat height = [UIScreen mainScreen].currentMode.size.height;
    
    if ( height == 1136 )
    {
        // iPhone 5
        self.hstView.frame = CGRectMake(0.0, 35.0, 320.0, 420.0);
        self.legendView.frame = CGRectMake(0.0, 455.0, 320.0, 95.0);
        //NSLog(@"1136");
    }
    else if (height == 960)
    {
        // iPhone 4, 4S
        self.hstView.frame = CGRectMake(0.0, 35.0, 320.0, 332.0);
        self.legendView.frame = CGRectMake(0.0, 367.0, 320.0, 95.0);
        //NSLog(@"960");
    }
    else if (height == 480)
    {
        // iPhone 3GS, 3G
        self.hstView.frame = CGRectMake(0.0, 35.0, 320.0, 332.0);
        self.legendView.frame = CGRectMake(0.0, 367.0, 320.0, 95.0);
        //NSLog(@"480");
    }
}

- (void)viewDidUnload
{
    [self setMainLbl:nil];
    [self setHstView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)closeBox:(id)sender
{
    //[self.presentingViewController dismissModalViewControllerAnimated:YES];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - CPTPlotDataSource methods
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return [[[PWCGraphData getGraphData] graphXValues] count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    if ((fieldEnum == CPTBarPlotFieldBarTip) && (index < [[[PWCGraphData getGraphData] graphXValues] count])) {
        return [[[PWCGraphData getGraphData] graphYValues] objectAtIndex:index];
    }
    return [NSDecimalNumber numberWithUnsignedInteger:index];
}

-(CPTFill *)barFillForBarPlot:(CPTBarPlot *)barPlot recordIndex:(NSUInteger)index
{
    CPTColor *color = [CPTColor colorWithComponentRed:248.0/255.0 green:166.0/255.0 blue:92.0/255.0 alpha:1.0];
    if (index == 0) {
        color = [CPTColor colorWithComponentRed:100.0/255.0 green:149.0/255.0 blue:199.0/255.0 alpha:1.0];
    } else if (index == 1) {
        color = [CPTColor colorWithComponentRed:204.0/255.0 green:100.0/255.0 blue:95.0/255.0 alpha:1.0];
    } else if (index == 2) {
        color = [CPTColor colorWithComponentRed:94.0/255.0 green:186.0/255.0 blue:208.0/255.0 alpha:1.0];
    } else {
        color = [CPTColor colorWithComponentRed:248.0/255.0 green:166.0/255.0 blue:92.0/255.0 alpha:1.0];
    }
    //CPTGradient *gradient = [CPTGradient gradientWithBeginningColor:color
    //                                                    endingColor:color
    //                                              beginningPosition:0.0
    //                                                 endingPosition:0.3 ];
    //[gradient setGradientType:CPTGradientTypeAxial];
    //[gradient setAngle:320.0];
        
    //CPTFill *fill = [CPTFill fillWithGradient:gradient];
    //CPTFill *fill = [CPTFill fillWithColor:];
    
    //return fill;

    //if (index == 0) {
    //    NSLog(@"CPTColor *col1 = [CPTColor colorWithComponentRed:100/255 green:149/255 blue:199/255 alpha:1.0];");
    //}
    
    //NSLog(@"%@",[self.colorCodesForBars objectAtIndex:index]);
    return [CPTFill fillWithColor:color];
}

#pragma mark - CPTBarPlotDelegate methods
-(void)barPlot:(CPTBarPlot *)plot barWasSelectedAtRecordIndex:(NSUInteger)index
{
    // 1 - Is the plot hidden?
    if (plot.isHidden == YES) {
        return;
    }
    
    // 2 - Create style, if necessary
    static CPTMutableTextStyle *style = nil;
    if (!style) {
        style = [CPTMutableTextStyle textStyle];
        style.color= [CPTColor blueColor];
        style.fontSize = 11.0f;
        style.fontName = @"AvenirNextCondensed-DemiBold";
    }
    
    // 3 - Create annotation, if necessary
    NSNumber *price = [self numberForPlot:plot field:CPTBarPlotFieldBarTip recordIndex:index];
    if (!self.priceAnnotation) {
        NSNumber *x = [NSNumber numberWithInt:0];
        NSNumber *y = [NSNumber numberWithInt:0];
        NSArray *anchorPoint = [NSArray arrayWithObjects:x, y, nil];
        self.priceAnnotation = [[CPTPlotSpaceAnnotation alloc] initWithPlotSpace:plot.plotSpace anchorPlotPoint:anchorPoint];
    }
    
    // 4 - Create number formatter, if needed
    static NSNumberFormatter *formatter = nil;
    if (!formatter) {
        formatter = [[NSNumberFormatter alloc] init];
        [formatter setMaximumFractionDigits:2];
    }
    
    // 5 - Create text layer for annotation
    NSString *priceValue = [NSString stringWithFormat:@"%@%.2f",[PWCGlobal getTheGlobal].currencySymbol,fabsf([price floatValue])];
    CPTTextLayer *textLayer = [[CPTTextLayer alloc] initWithText:priceValue style:style];
    self.priceAnnotation.contentLayer = textLayer;
    
    // 6 - Get plot index based on identifier
    NSInteger plotIndex = 0;

    // 7 - Get the anchor point for annotation
    CGFloat x = index + CPDBarInitialX + (plotIndex * CPDBarWidth);
    NSNumber *anchorX = [NSNumber numberWithFloat:x];
    CGFloat y = [price floatValue] * 1.05;
    NSNumber *anchorY = [NSNumber numberWithFloat:y];
    self.priceAnnotation.anchorPlotPoint = [NSArray arrayWithObjects:anchorX, anchorY, nil];
    
    // 8 - Add the annotation 
    [plot.graph.plotAreaFrame.plotArea addAnnotation:self.priceAnnotation];
}

#pragma mark - Chart behavior
-(void)initPlot
{
    self.hstView.allowPinchScaling = NO;
    [self configureGraph];
    [self configurePlots];
    [self configureAxes];
}

-(void)configureGraph
{
    // 1 - Create the graph
    CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:self.hstView.bounds];
    graph.plotAreaFrame.masksToBorder = NO;
    self.hstView.hostedGraph = graph;
    
    // 2 - Configure the graph
    //[graph applyTheme:[CPTTheme themeNamed:kCPTPlainWhiteTheme]];
    //graph.fill = [CPTFill fillWithColor:[CPTColor colorWithComponentRed:229/255 green:229/255 blue:229/255 alpha:1.0]];
    graph.paddingBottom = 20.0f;
    graph.paddingLeft  = 50.0f;
    graph.paddingTop    = 10.0f;
    graph.paddingRight  = 5.0f;
    
    // 3 - Set up styles
    CPTMutableTextStyle *titleStyle = [CPTMutableTextStyle textStyle];
    titleStyle.color = [CPTColor blackColor];
    titleStyle.fontName = @"Helvetica-Bold";
    titleStyle.fontSize = 14.0f;
    
    // 4 - Set up title
    /*
    NSString *title = [NSString stringWithFormat:@"Total: %.2f", [[PWCGraphData getGraphData] totalValue]];
    graph.title = title;
    graph.titleTextStyle = titleStyle;
    graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
    graph.titleDisplacement = CGPointMake(0.0f, -16.0f);
    */
    
    // 5 - Set up plot space
    CGFloat xMin = 0.0f;
    CGFloat xMax = [[[PWCGraphData getGraphData] graphXValues] count];
    CGFloat yMin = 0.0f;
    if ([[[[PWCGraphData getGraphData] graphYValues] objectAtIndex:1] floatValue] < 0) {
        yMin = [[[[PWCGraphData getGraphData] graphYValues] objectAtIndex:1] floatValue] * 1.25;
    }
    
    CGFloat yMax = [[[[PWCGraphData getGraphData] graphYValues] valueForKeyPath:@"@max.intValue"] floatValue] * 1.25;  // should determine dynamically based on max price
    if (yMax == 0) {
        yMax = 100.0;
    }
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(xMin) length:CPTDecimalFromFloat(xMax)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(yMin) length:CPTDecimalFromFloat(yMax)];
}

-(void)configurePlots
{
    // 1 - Set up the plot
    self.graphPlot = [CPTBarPlot tubularBarPlotWithColor:[CPTColor redColor] horizontalBars:NO];
    
    // 2 - Set up line style
    CPTMutableLineStyle *barLineStyle = [[CPTMutableLineStyle alloc] init];
    barLineStyle.lineColor = [CPTColor lightGrayColor];
    barLineStyle.lineWidth = 0.5;
    
    // 3 - Add plots to graph
    CPTGraph *graph = self.hstView.hostedGraph;
    CGFloat barX = CPDBarInitialX;
    NSArray *plots = [NSArray arrayWithObjects:self.graphPlot, nil];
    for (CPTBarPlot *plot in plots) {
        plot.dataSource = self;
        plot.delegate = self;
        plot.barWidth = CPTDecimalFromDouble(CPDBarWidth);
        plot.barOffset = CPTDecimalFromDouble(barX);
        plot.lineStyle = barLineStyle;
        plot.opacity = 1.0f;
        [graph addPlot:plot toPlotSpace:graph.defaultPlotSpace];
        plot.anchorPoint = CGPointMake(0.0, 0.0);
        
        CABasicAnimation *scaleUp = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
        scaleUp.duration = 0.8f;
        scaleUp.removedOnCompletion = NO;
        scaleUp.fillMode = kCAFillModeForwards;
        scaleUp.fromValue = [NSNumber numberWithFloat:0.0];
        scaleUp.toValue = [NSNumber numberWithFloat:1.0];
        [plot addAnimation:scaleUp forKey:@"animateLayer"];
         
        barX += CPDBarWidth;
    }
}

-(void)configureAxes
{
    // 1 - Configure styles
    CPTMutableTextStyle *axisTitleStyle = [CPTMutableTextStyle textStyle];
    axisTitleStyle.color = [CPTColor blackColor];
    //axisTitleStyle.fontName = @"Helvetica-Bold";
    axisTitleStyle.fontName = @"AvenirNextCondensed-DemiBold";
    axisTitleStyle.fontSize = 9.0f;
    CPTMutableLineStyle *axisLineStyle = [CPTMutableLineStyle lineStyle];
    axisLineStyle.lineWidth = 2.0f;
    axisLineStyle.lineColor = [[CPTColor blackColor] colorWithAlphaComponent:1];
    
    // 2 - Get the graph's axis set
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *) self.hstView.hostedGraph.axisSet;
    
    // 3 - Configure the x-axis
    axisSet.xAxis.labelingPolicy = CPTAxisLabelingPolicyNone;
    axisSet.xAxis.title = @"";
    axisSet.xAxis.titleTextStyle = axisTitleStyle;
    axisSet.xAxis.titleOffset = 25.0f;
    axisSet.xAxis.axisLineStyle = axisLineStyle;
    axisSet.xAxis.majorTickLineStyle = axisLineStyle;
    axisSet.xAxis.majorTickLength = 1.0f;
    axisSet.xAxis.tickDirection = CPTSignNegative;
    NSMutableSet *xLabels = [NSMutableSet setWithCapacity:[[[PWCGraphData getGraphData] graphXValues] count]];
    NSMutableSet *xLocations = [NSMutableSet setWithCapacity:[[[PWCGraphData getGraphData] graphXValues] count]];
    NSInteger i = 0;
    for (NSString *value in [[PWCGraphData getGraphData] graphXValues]) {
        CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:value  textStyle:axisSet.xAxis.titleTextStyle];
        CGFloat location = i++;
        label.tickLocation = CPTDecimalFromCGFloat((location+CPDBarInitialX));
        label.offset = axisSet.xAxis.majorTickLength;
        if (label) {
            [xLabels addObject:label];
            [xLocations addObject:[NSNumber numberWithFloat:location]];
        }
    }
    axisSet.xAxis.axisLabels = xLabels;
    axisSet.xAxis.majorTickLocations = xLocations;
    
    // 4 - Configure the y-axis
    /*
    axisSet.yAxis.labelingPolicy = CPTAxisLabelingPolicyAutomatic;
    axisSet.yAxis.title = @"Price";
    axisSet.yAxis.titleTextStyle = axisTitleStyle;
    axisSet.yAxis.titleOffset = 5.0f;
    axisSet.yAxis.axisLineStyle = axisLineStyle;
     */
    
    CPTAxis *y = axisSet.yAxis;
    y.title = @"AMOUNT";
    y.titleTextStyle = axisTitleStyle;
    y.titleOffset = -50.0f;
    y.axisLineStyle = axisLineStyle;
    //y.majorGridLineStyle = gridLineStyle;
    y.labelingPolicy = CPTAxisLabelingPolicyNone;
    //y.labelTextStyle = axisTextStyle;
    y.labelOffset = 4.0f;
    y.labelAlignment = CPTAlignmentRight;
    y.majorTickLineStyle = axisLineStyle;
    y.majorTickLength = 4.0f;
    y.minorTickLength = 2.0f;
    y.tickDirection = CPTSignPositive;
    NSInteger majorIncrement = [[[[PWCGraphData getGraphData] graphYValues] valueForKeyPath:@"@max.intValue"] intValue] / 8;
    if (majorIncrement == 0) {
        majorIncrement = 10;
    }
    if (majorIncrement%2 == 1) {
        majorIncrement = majorIncrement + 1;
    }
    NSInteger minorIncrement = majorIncrement / 2;
    //NSLog(@"major = %d, minor = %d", majorIncrement, minorIncrement);
    CGFloat yMax = [[[[PWCGraphData getGraphData] graphYValues] valueForKeyPath:@"@max.intValue"] floatValue] * 1.25;
    if (yMax == 0.0) {
        yMax = 100.0;
    }
    NSMutableSet *yLabels = [NSMutableSet set];
    NSMutableSet *yMajorLocations = [NSMutableSet set];
    NSMutableSet *yMinorLocations = [NSMutableSet set];
    for (NSInteger j = minorIncrement; j <= yMax; j += minorIncrement) {
        NSUInteger mod = j % majorIncrement;
        if (mod == 0) {
            NSString *txt = [NSString stringWithFormat:@"%i", j];
            CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:txt textStyle:y.titleTextStyle];
            NSDecimal location = CPTDecimalFromInteger(j);
            label.tickLocation = location;
            label.offset = -y.majorTickLength - y.labelOffset - (txt.length * 5);
            //NSLog(@"%f",label.offset);
            label.alignment = CPTAlignmentRight;
            if (label) {
                [yLabels addObject:label];
            }
            [yMajorLocations addObject:[NSDecimalNumber decimalNumberWithDecimal:location]];
        } else {
            [yMinorLocations addObject:[NSDecimalNumber decimalNumberWithDecimal:CPTDecimalFromInteger(j)]];
        }
    }
    y.axisLabels = yLabels;    
    y.majorTickLocations = yMajorLocations;
    y.minorTickLocations = yMinorLocations;
}

-(void)hideAnnotation:(CPTGraph *)graph
{
    if ((graph.plotAreaFrame.plotArea) && (self.priceAnnotation)) {
        [graph.plotAreaFrame.plotArea removeAnnotation:self.priceAnnotation];
        self.priceAnnotation = nil;
    }
}

@end
