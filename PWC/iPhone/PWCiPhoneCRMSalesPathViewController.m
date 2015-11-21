//
//  PWCiPhoneCRMSalesPathViewController.m
//  PWC
//
//  Created by Samiul Hoque on 7/9/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCiPhoneCRMSalesPathViewController.h"
#import "PWCGlobal.h"
#import "PWCNewLead.h"
#import "PWCCRMData.h"
#import "NSDictionary+MutableDeepCopy.h"
#import "ASIHTTPRequest.h"
#import "PWCGlobal.h"
#import "PWCCRMGlobal.h"
#import "JSON.h"
#import "DataManager.h"
#import "PWCiPhoneCRMTagsViewController.h"

@interface PWCiPhoneCRMSalesPathViewController ()

@end

@implementation PWCiPhoneCRMSalesPathViewController
@synthesize m_newLead;

//==============================================================================================================
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

//==============================================================================================================
-(void) viewDidLoad
{
    [super viewDidLoad];
    [self initMember];
}

//==============================================================================================================
-(void) initMember
{
    m_arrInfo = [[NSMutableArray alloc] init];
    
    NSArray* arr = [[DataManager sharedScoreManager] getAllFunnels];
    if(arr == nil || [arr count] <= 0)
    {
        [self getFunnels];
    }
    else
    {
        [self updateFunnelView];
    }
}

//==============================================================================================================
-(void) updateFunnelView
{
    [m_arrInfo removeAllObjects];
    NSArray* arr = [[DataManager sharedScoreManager] getAllFunnels];
    for(int i = 0; i < [arr count]; i++)
    {
        NSDictionary* dic = [arr objectAtIndex: i];
        [m_arrInfo addObject: dic];
    }
    
    [self.tableView reloadData];
}

//==============================================================================================================
-(void) getFunnels
{
    NSString* strURL = [[NSString stringWithFormat: @"%@funnellist/%@/%@", SERVER_PENDNG_BASE_URL, [PWCGlobal getTheGlobal].merchantId, [PWCGlobal getTheGlobal].userHash] stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding];
    NSLog(@"funnellist = %@", strURL);
    
    [self fetchJSON: strURL index: GET_FUNNELS];
}

//==============================================================================================================
-(void) updateFunnels: (NSDictionary*) json
{
    NSLog(@"funnels list = %@", json);
    [m_arrInfo removeAllObjects];
    
    [[DataManager sharedScoreManager] deleteAllFunnels];
    [[DataManager sharedScoreManager] deleteSalesPath];
    
    NSArray* arrFunnels = [json objectForKey: @"FunnelsList"];
    for(int i = 0; i < [arrFunnels count]; i++)
    {
        NSDictionary* dic = [arrFunnels objectAtIndex: i];
        NSString* funnel_name = [dic objectForKey: @"funnel_name"];
        NSString* funnel_is_default = [dic objectForKey: @"funnel_is_default"];
        int funnel_id = [[dic objectForKey: @"funnel_id"] intValue];
        NSArray* arrSalesPath = [dic objectForKey: @"SalespathList"];
        NSString* strSalespathList = @"";
        
        for(int j = 0; j < [arrSalesPath count]; j++)
        {
            NSDictionary* dicSale = [arrSalesPath objectAtIndex: j];
            int isDefault = [[dicSale objectForKey: @"isDefault"] intValue];
            int salesPath_slider_id = [[dicSale objectForKey: @"salesPath_slider_id"] intValue];
            NSString* salesPath_name = [dicSale objectForKey: @"salesPath_name"];
            [[DataManager sharedScoreManager] insertSalesPath: salesPath_slider_id isDefault: isDefault salesPath_name: salesPath_name];
            
            if([strSalespathList length] <= 0)
            {
                strSalespathList = [strSalespathList stringByAppendingString: [NSString stringWithFormat: @"%d", salesPath_slider_id]];
            }
            else
            {
                strSalespathList = [strSalespathList stringByAppendingString: [NSString stringWithFormat: @",%d", salesPath_slider_id]];
            }
        }
        NSLog(@"strSalespathList = %@", strSalespathList);
        
        [[DataManager sharedScoreManager] insertFunnel: funnel_id
                                     funnel_is_default: funnel_is_default
                                           funnel_name: funnel_name
                                         SalespathList: strSalespathList];
    }
    
    [self updateFunnelView];
}

#pragma mark -
#pragma mark Update

//==============================================================================================================
-(void)fetchJSON: (NSString*) strURL index: (int) nIndex
{
    [SVProgressHUD showWithStatus:@"Loading ..." maskType:SVProgressHUDMaskTypeBlack];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* kivaData = [NSData dataWithContentsOfURL:
                            [NSURL URLWithString:strURL]
                            ];
        NSArray* json = nil;
        if (kivaData)
        {
            json = [NSJSONSerialization JSONObjectWithData:kivaData options:kNilOptions error:nil];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateUIWithDictionary: (NSDictionary*) json index: nIndex];
        });
    });
}

//==============================================================================================================
-(void)updateUIWithDictionary:(NSDictionary*)json index: (int) nIndex
{
    @try
    {
        [SVProgressHUD showSuccessWithStatus:@"Syncing successful."];
        if(json != nil)
        {
            switch (nIndex)
            {
                case GET_FUNNELS:
                    [self updateFunnels: json];
                    break;
                    
                default:
                    break;
            }
            
        }
    }
    
    @catch (NSException *exception)
    {
        NSLog(@"exception = %@", [exception description]);
        [SVProgressHUD dismissWithError:@"Syncing Failed. Try Again Later." afterDelay:1.0];
    }
    
    //turn off the network indicator in the status bar
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

//==============================================================================================================
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//==============================================================================================================
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [m_arrInfo count];
}

//==============================================================================================================
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary* dic = [m_arrInfo objectAtIndex: section];
    NSString* strFunnel = [dic objectForKey: @"funnel_name"];
    return strFunnel;
}

//==============================================================================================================
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary* dic = [m_arrInfo objectAtIndex: section];
    NSString* strSalesPath = [dic objectForKey: @"SalespathList"];
    NSArray* arrSales = [strSalesPath componentsSeparatedByString: @","];
    return [arrSales count];
}

//==============================================================================================================
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"salesPathCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary* dic = [m_arrInfo objectAtIndex: indexPath.section];
    NSString* strSalesPath = [dic objectForKey: @"SalespathList"];
    NSArray* arrSales = [strSalesPath componentsSeparatedByString: @","];
    int nSaleID = [[arrSales objectAtIndex: indexPath.row] intValue];
    NSArray* arrTemp = [[DataManager sharedScoreManager] getSalesPathWithID: nSaleID];
    if(arrTemp != nil && [arrTemp count] > 0)
    {
        NSDictionary* dicRecord = [arrTemp objectAtIndex: 0];
        cell.textLabel.text = [dicRecord objectForKey: @"salesPath_name"];
        int salesPath_slider_id = [[dicRecord objectForKey: @"salesPath_slider_id"] intValue];
        if(m_nSelectedID == salesPath_slider_id)
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    return cell;
}

#pragma mark - Table view delegate
//==============================================================================================================
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dic = [m_arrInfo objectAtIndex: indexPath.section];
    NSString* strSalesPath = [dic objectForKey: @"SalespathList"];
    NSArray* arrSales = [strSalesPath componentsSeparatedByString: @","];
    int nSaleID = [[arrSales objectAtIndex: indexPath.row] intValue];
    NSArray* arrTemp = [[DataManager sharedScoreManager] getSalesPathWithID: nSaleID];
    if(arrTemp != nil && [arrTemp count] > 0)
    {
        NSDictionary* dicRecord = [arrTemp objectAtIndex: 0];
        int salesPath_slider_id = [[dicRecord objectForKey: @"salesPath_slider_id"] intValue];
        m_nSelectedID = salesPath_slider_id;
    }
    
    [self.tableView reloadData];
}

//==============================================================================================================
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"tags_segue"])
    {
        PWCiPhoneCRMTagsViewController *nextView = segue.destinationViewController;
        [m_newLead.salespaths removeAllObjects];        
        [m_newLead.salespaths addObject: [NSString stringWithFormat: @"%d", m_nSelectedID]];
        
        nextView.m_newLead = m_newLead;
    }
}

////==============================================================================================================
//-(BOOL) checkUISalesPathID: (int) salesPath_slider_id
//{
//    if([m_arrSalesPath count] <= 0) return NO;
//    
//    for(int i = 0; i < [m_arrSalesPath count]; i++)
//    {
//        int nID = [[m_arrSalesPath objectAtIndex: i] intValue];
//        if(nID == salesPath_slider_id)
//        {
//            return YES;
//        }
//    }
//    return NO;
//}
//
//
////==============================================================================================================
//-(void) checkSalesPathID: (int) salesPath_slider_id
//{
//    BOOL bFlag = YES;
//    
//    for(int i = 0; i < [m_arrSalesPath count]; i++)
//    {
//        int nID = [[m_arrSalesPath objectAtIndex: i] intValue];
//        if(nID == salesPath_slider_id)
//        {
//            [m_arrSalesPath removeObjectAtIndex: i];
//            return;
//        }
//    }
//    
//    if(bFlag)
//    {
//        [m_arrSalesPath addObject: [NSString stringWithFormat: @"%d", salesPath_slider_id]];
//    }
//}

#pragma mark -
#pragma mark Action Management.

//==============================================================================================================
-(IBAction) actionRefresh:(id)sender
{
    [self getFunnels];
}

//==============================================================================================================
@end
