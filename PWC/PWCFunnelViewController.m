//
//  PWCFunnelViewController.m
//  PWC
//
//  Created by JianJinHu on 8/1/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCFunnelViewController.h"
#import "PWCGlobal.h"
#import "PWCCRMGlobal.h"
#import "DataManager.h"
#import "PWCViewTaskViewController.h"
#import "DataManager.h"
#import "PWCCRMRoleSelViewController.h"

@interface PWCFunnelViewController ()

@end

@implementation PWCFunnelViewController

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
- (void)viewDidLoad
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
        [SVProgressHUD showSuccessWithStatus:@"Syncing Successful."];
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
        [SVProgressHUD dismissWithError:@"Syncing Failed. Try Again later." afterDelay:1.0];
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_arrInfo count] + 1;
}

//==============================================================================================================
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"funnels";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if(indexPath.row == 0)
    {
        cell.textLabel.text = @"All Tasks";
    }
    else
    {
        NSDictionary* dic = [m_arrInfo objectAtIndex: indexPath.row - 1];
        NSString* strName = [dic objectForKey: @"funnel_name"];
        cell.textLabel.text = strName;
    }
    
    return cell;
}

#pragma mark - Table view delegate
//==============================================================================================================
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([[PWCGlobal getTheGlobal].userLevel isEqualToString: @"superadmin"] || [[PWCGlobal getTheGlobal].userLevel isEqualToString: @"admin"])
    {
        [self performSegueWithIdentifier: @"user_select_segue" sender: self];
    }
    else
    {
        [self performSegueWithIdentifier: @"task_list_segue" sender: self];
    }
}

//==============================================================================================================
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    int nSelIndex = [self.tableView indexPathForSelectedRow].row;
    int nFunnelID;
    
    if(nSelIndex == 0)
    {
        nFunnelID = 0;
    }
    else
    {
        NSDictionary* dic = [m_arrInfo objectAtIndex: nSelIndex - 1];
        nFunnelID = [[dic objectForKey: @"funnel_id"] intValue];
    }
    
    if ([segue.identifier isEqualToString:@"task_list_segue"])
    {
        PWCViewTaskViewController *nextView = segue.destinationViewController;
        nextView.m_nFunnelID = nFunnelID;
        nextView.m_nAdminID = 0;

    }
    else if([segue.identifier isEqualToString: @"user_select_segue"])
    {
        PWCCRMRoleSelViewController *nextView = segue.destinationViewController;
        nextView.m_nType = 3;
        nextView.m_nFunnelID = nFunnelID;
        nextView.m_bFunnelUserFlag = YES;
    }
}

#pragma mark -
#pragma mark Action Management.

//==============================================================================================================
-(IBAction) actionRefresh:(id)sender
{
    [self getFunnels];
}

//==============================================================================================================
@end
