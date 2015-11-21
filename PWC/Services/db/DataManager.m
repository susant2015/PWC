//
//  DataManager.m
//  iauweather
//
//  Created by JianJinHu on 11/7/12.
//
//

#import "DataManager.h"
#define kDataBaseName	@"pwc_crmdb.sqlite"

@implementation DataManager

static DataManager *_sharedScore = nil;

//================================================================================================================================================================================================
+ (DataManager*) sharedScoreManager
{
	if (!_sharedScore)
	{
		_sharedScore = [[DataManager alloc] init];
	}
	
	return _sharedScore;
}

//================================================================================================================================================================================================
+ (void) releaseScoreManager
{
	if (_sharedScore)
	{
		_sharedScore = nil;
	}
}

//================================================================================================================================================================================================
- (id) init
{
	if ( (self=[super init]) )
	{
		m_sqlManager = [[SQLDatabase alloc] init];
		[m_sqlManager initWithDynamicFile: kDataBaseName];
	}
	
	return self;
}

#pragma mark -
#pragma mark User Management.

//================================================================================================================================================================================================
-(int) insertEmailProfile:(NSString *)profile_id
             profile_name:(NSString *)profile_name
        profile_from_name:(NSString *)profile_from_name
           reply_to_email:(NSString *)reply_to_email
{
    //record exist in the Database.
    NSString* strQueryTotal = [NSString stringWithFormat: @"select * from tbl_email_profiles"];
	int nCountTotal = [[m_sqlManager lookupAllForSQL: strQueryTotal] count];
    
    NSMutableString* strSQL = [[NSMutableString alloc] init];
    [strSQL appendFormat: @"insert into '%@'('id', 'profile_id', 'profile_name', 'profile_from_name', 'reply_to_email') values(", @"tbl_email_profiles"];
    [strSQL appendFormat: @"'%d',", nCountTotal];
    [strSQL appendFormat: @"'%@',", profile_id];
    [strSQL appendFormat: @"'%@',", profile_name];
    [strSQL appendFormat: @"'%@',", profile_from_name];
    [strSQL appendFormat: @"'%@')", reply_to_email];
    
    [m_sqlManager runDynamicSQL: strSQL forTable: @"tbl_email_profiles"];
    
    return nCountTotal;
}

//================================================================================================================================================================================================
-(NSArray*) getAllEmailProfiles;
{
    NSString* strQuery = [NSString stringWithFormat: @"select * from tbl_email_profiles"];
    return [m_sqlManager lookupAllForSQL: strQuery];
}

//================================================================================================================================================================================================
-(void) deleteAllEmailProfiles
{
    NSString* strQuery = @"delete from tbl_email_profiles";
    [m_sqlManager lookupAllForSQL: strQuery];
    
}

#pragma mark -
#pragma mark Email Contents Management.

//================================================================================================================================================================================================
-(int) insertEmailContent:(NSString *)content_id
                  subject:(NSString *)subject
             library_name:(NSString*)library_name
                signature:(NSString *)signature
                   cat_id:(NSString*) cat_id
                 category:(NSString*) category

{
    //record exist in the Database.
    NSString* strQueryTotal = [NSString stringWithFormat: @"select * from tbl_email_content"];
	int nCountTotal = [[m_sqlManager lookupAllForSQL: strQueryTotal] count];
    
    NSMutableString* strSQL = [[NSMutableString alloc] init];
    [strSQL appendFormat: @"insert into '%@'('id', 'content_id', 'subject', 'library_name', 'signature', 'cat_id', 'category') values(", @"tbl_email_content"];
    [strSQL appendFormat: @"'%d',", nCountTotal];
    [strSQL appendFormat: @"'%@',", content_id];
    [strSQL appendFormat: @"'%@',", subject];
    [strSQL appendFormat: @"'%@',", library_name];
    [strSQL appendFormat: @"'%@',", signature];
    [strSQL appendFormat: @"'%@',", cat_id];
    [strSQL appendFormat: @"'%@')", category];
    
    [m_sqlManager runDynamicSQL: strSQL forTable: @"tbl_email_content"];
    
    return nCountTotal;
}

//================================================================================================================================================================================================
-(NSArray*) getAllEmailContents
{
    NSString* strQuery = [NSString stringWithFormat: @"select * from tbl_email_content order by cat_id"];
    return [m_sqlManager lookupAllForSQL: strQuery];
}

//================================================================================================================================================================================================
-(void) deleteAllEmailContents
{
    NSString* strQuery = @"delete from tbl_email_content";
    [m_sqlManager lookupAllForSQL: strQuery];
}

#pragma mark -
#pragma mark SMS Content.

//================================================================================================================================================================================================
-(int) insertSMSContent:(NSString *)content_id
                subject:(NSString *)subject
              signature:(NSString *)signature
                 cat_id:(NSString*) cat_id
               category:(NSString*) category
{
    //record exist in the Database.
    NSString* strQueryTotal = [NSString stringWithFormat: @"select * from tbl_sms_content"];
	int nCountTotal = [[m_sqlManager lookupAllForSQL: strQueryTotal] count];
    
    NSMutableString* strSQL = [[NSMutableString alloc] init];
    [strSQL appendFormat: @"insert into '%@'('id', 'content_id', 'subject', 'signature', 'cat_id', 'category') values(", @"tbl_sms_content"];
    [strSQL appendFormat: @"'%d',", nCountTotal];
    [strSQL appendFormat: @"'%@',", content_id];
    [strSQL appendFormat: @"'%@',", subject];
    [strSQL appendFormat: @"'%@',", signature];
    [strSQL appendFormat: @"'%@',", cat_id];
    [strSQL appendFormat: @"'%@')", category];
    
    [m_sqlManager runDynamicSQL: strSQL forTable: @"tbl_sms_content"];
    
    return nCountTotal;
}

//================================================================================================================================================================================================
-(NSArray*) getAllSMSContents
{
    NSString* strQuery = [NSString stringWithFormat: @"select * from tbl_sms_content order by cat_id"];
    return [m_sqlManager lookupAllForSQL: strQuery];
}

//================================================================================================================================================================================================
-(void) deleteAllSMSContents
{
    NSString* strQuery = @"delete from tbl_sms_content";
    [m_sqlManager lookupAllForSQL: strQuery];
}

#pragma mark -
#pragma mark Task Management.

//================================================================================================================================================================================================
-(int) insertTaskList: (int) list_count task_list_name: (NSString*) task_list_name
{
    //record exist in the Database.
    NSString* strQueryTotal = [NSString stringWithFormat: @"select * from tbl_task_list"];
	int nCountTotal = [[m_sqlManager lookupAllForSQL: strQueryTotal] count];
    
    NSMutableString* strSQL = [[NSMutableString alloc] init];
    [strSQL appendFormat: @"insert into '%@'('id', 'list_count', 'task_list_name') values(", @"tbl_task_list"];
    [strSQL appendFormat: @"'%d',", nCountTotal];
    [strSQL appendFormat: @"'%d',", list_count];
    [strSQL appendFormat: @"'%@')", task_list_name];
    
    [m_sqlManager runDynamicSQL: strSQL forTable: @"tbl_task_list"];
    
    return nCountTotal;
}

//================================================================================================================================================================================================
-(NSArray*) getTaskList
{
    NSString* strQuery = [NSString stringWithFormat: @"select * from tbl_task_list"];
    return [m_sqlManager lookupAllForSQL: strQuery];
}

//================================================================================================================================================================================================
-(void) deleteTaskList
{
    NSString* strQuery = @"delete from tbl_task_list";
    [m_sqlManager lookupAllForSQL: strQuery];
}

//================================================================================================================================================================================================
-(void) insertTask: (NSString*) strID
      task_list_id: (int) task_list_id
       assigned_by: (NSString*) assigned_by
       assigned_on: (NSString*) assigned_on
       assigned_to: (NSString*) assigned_to
    assigned_to_id: (NSString*) assigned_to_id
       customer_id: (NSString*) customer_id
     customer_name: (NSString*) customer_name
        delayed_by: (NSString*) delayed_by
           duedate: (NSString*) duedate
           lead_id: (NSString*) lead_id
            reason: (NSString*) reason
            status: (NSString*) status
              task: (NSString*) task
           task_id: (NSString*) task_id
         funnel_id: (int) funnel_id
{
    //    //record exist in the Database.
    //    NSString* strQueryTotal = [NSString stringWithFormat: @"select * from tbl_task"];
    //	int nCountTotal = [[m_sqlManager lookupAllForSQL: strQueryTotal] count];
    
    NSMutableString* strSQL = [[NSMutableString alloc] init];
    [strSQL appendFormat: @"insert into '%@'('id', 'task_list_id', 'assigned_by', 'assigned_on', 'assigned_to', 'assigned_to_id', 'customer_id', 'customer_name', 'delayed_by', 'duedate', 'lead_id', 'reason', 'status', 'task', 'funnel_id', 'task_id') values(", @"tbl_task"];
    [strSQL appendFormat: @"'%@',", strID];
    [strSQL appendFormat: @"'%d',", task_list_id];
    [strSQL appendFormat: @"'%@',", assigned_by];
    [strSQL appendFormat: @"'%@',", assigned_on];
    [strSQL appendFormat: @"'%@',", assigned_to];
    [strSQL appendFormat: @"'%@',", assigned_to_id];
    [strSQL appendFormat: @"'%@',", customer_id];
    [strSQL appendFormat: @"'%@',", customer_name];
    [strSQL appendFormat: @"'%@',", delayed_by];
    [strSQL appendFormat: @"'%@',", duedate];
    [strSQL appendFormat: @"'%@',", lead_id];
    [strSQL appendFormat: @"'%@',", reason];
    [strSQL appendFormat: @"'%@',", status];
    [strSQL appendFormat: @"'%@',", task];
    [strSQL appendFormat: @"'%d',", funnel_id];
    [strSQL appendFormat: @"'%@')", task_id];
    
    [m_sqlManager runDynamicSQL: strSQL forTable: @"tbl_task"];
}

//================================================================================================================================================================================================
-(NSArray*) getTaskWithListID: (int) listID funnelID: (int) nFunnelID assigned_to_id: (int) assigned_to_id
{
    NSString* strQuery;
    if(nFunnelID == 0)
    {
        strQuery = [NSString stringWithFormat: @"select * from tbl_task where task_list_id = %d", listID];
    }
    else
    {
        strQuery = [NSString stringWithFormat: @"select * from tbl_task where task_list_id = %d and funnel_id=%d", listID, nFunnelID];
    }
    
    if(assigned_to_id != 0)
    {
        strQuery = [strQuery stringByAppendingString: [NSString stringWithFormat: @" and assigned_to_id=%d", assigned_to_id]];
    }
    
    return [m_sqlManager lookupAllForSQL: strQuery];
}

//================================================================================================================================================================================================
-(void) deleteAllTasks
{
    NSString* strQuery = @"delete from tbl_task";
    [m_sqlManager lookupAllForSQL: strQuery];
}

#pragma mark -
#pragma mark Funnels Management.

//================================================================================================================================================================================================
-(void) insertFunnel: (int) funnel_id
   funnel_is_default: (NSString*) funnel_is_default
         funnel_name: (NSString*) funnel_name
       SalespathList: (NSString*) SalespathList
{
    NSMutableString* strSQL = [[NSMutableString alloc] init];
    [strSQL appendFormat: @"insert into '%@'('funnel_id', 'funnel_is_default', 'funnel_name', 'SalespathList') values(", @"tbl_funnel"];
    [strSQL appendFormat: @"'%d',", funnel_id];
    [strSQL appendFormat: @"'%@',", funnel_is_default];
    [strSQL appendFormat: @"'%@',", funnel_name];
    [strSQL appendFormat: @"'%@')", SalespathList];
    
    [m_sqlManager runDynamicSQL: strSQL forTable: @"tbl_funnel"];
}

//================================================================================================================================================================================================
-(NSArray*) getAllFunnels
{
    NSString* strQuery;
    strQuery = [NSString stringWithFormat: @"select * from tbl_funnel"];
    return [m_sqlManager lookupAllForSQL: strQuery];
}

//================================================================================================================================================================================================
-(NSArray*) getFunnelWithID: (int) funnel_id
{
    NSString* strQuery;
    strQuery = [NSString stringWithFormat: @"select * from tbl_task where tbl_funnel = %d", funnel_id];
    return [m_sqlManager lookupAllForSQL: strQuery];
}

//================================================================================================================================================================================================
-(void) deleteAllFunnels
{
    NSString* strQuery = @"delete from tbl_funnel";
    [m_sqlManager lookupAllForSQL: strQuery];
}

#pragma mark -
#pragma mark SalesPath.

//================================================================================================================================================================================================
-(void) insertSalesPath: (int) salesPath_slider_id
              isDefault: (int) isDefault
         salesPath_name: (NSString*) salesPath_name
{
    NSMutableString* strSQL = [[NSMutableString alloc] init];
    [strSQL appendFormat: @"insert into '%@'('salesPath_slider_id', 'isDefault', 'salesPath_name') values(", @"tbl_salespath"];
    [strSQL appendFormat: @"'%d',", salesPath_slider_id];
    [strSQL appendFormat: @"'%d',", isDefault];
    [strSQL appendFormat: @"'%@')", salesPath_name];
    
    [m_sqlManager runDynamicSQL: strSQL forTable: @"tbl_salespath"];
}

//================================================================================================================================================================================================
-(NSArray*) getAllSalesPath
{
    NSString* strQuery;
    strQuery = [NSString stringWithFormat: @"select * from tbl_salespath"];
    return [m_sqlManager lookupAllForSQL: strQuery];
}

//================================================================================================================================================================================================
-(NSArray*) getSalesPathWithID: (int) salesPath_slider_id
{
    NSString* strQuery;
    strQuery = [NSString stringWithFormat: @"select * from tbl_salespath where salesPath_slider_id = %d", salesPath_slider_id];
    return [m_sqlManager lookupAllForSQL: strQuery];
}

//================================================================================================================================================================================================
-(void) deleteSalesPath
{
    NSString* strQuery = @"delete from tbl_salespath";
    [m_sqlManager lookupAllForSQL: strQuery];
}

#pragma mark -
#pragma mark Role User Management.

//================================================================================================================================================================================================
-(void) insertRoleUser: (int) admin_id
                 email: (NSString*) email
             firstname: (NSString*) firstname
        is_def_primary: (NSString*) is_def_primary
        is_def_support: (NSString*) is_def_support
           is_def_tech: (NSString*) is_def_tech
              lastname: (NSString*) lastname
{
    NSMutableString* strSQL = [[NSMutableString alloc] init];
    [strSQL appendFormat: @"insert into '%@'('admin_id', 'email', 'firstname', 'is_def_primary', 'is_def_support', 'is_def_tech', 'lastname') values(", @"tbl_rolelist"];
    [strSQL appendFormat: @"'%d',", admin_id];
    [strSQL appendFormat: @"'%@',", email];
    [strSQL appendFormat: @"'%@',", firstname];
    [strSQL appendFormat: @"'%@',", is_def_primary];
    [strSQL appendFormat: @"'%@',", is_def_support];
    [strSQL appendFormat: @"'%@',", is_def_tech];
    [strSQL appendFormat: @"'%@')", lastname];
    
    [m_sqlManager runDynamicSQL: strSQL forTable: @"tbl_rolelist"];
}

//================================================================================================================================================================================================
-(NSArray*) getAllRoleUsers
{
    NSString* strQuery;
    strQuery = [NSString stringWithFormat: @"select * from tbl_rolelist"];
    return [m_sqlManager lookupAllForSQL: strQuery];
}

//================================================================================================================================================================================================
-(NSArray*) getRoleUser: (int) admin_id
{
    NSString* strQuery;
    strQuery = [NSString stringWithFormat: @"select * from tbl_rolelist where admin_id = %d", admin_id];
    return [m_sqlManager lookupAllForSQL: strQuery];
}

//================================================================================================================================================================================================
-(void) deleteAllRoleUsers
{
    NSString* strQuery = @"delete from tbl_rolelist";
    [m_sqlManager lookupAllForSQL: strQuery];
}


#pragma mark -
#pragma mark Category

//================================================================================================================================================================================================
-(void) insertCategory: (int) tag_category_id
         category_name: (NSString*) category_name
         category_type: (int) category_type
                  tags: (NSString*) tags
{
    NSMutableString* strSQL = [[NSMutableString alloc] init];
    [strSQL appendFormat: @"insert into '%@'('tag_category_id', 'category_name', 'category_type', 'tags') values(", @"tbl_category"];
    [strSQL appendFormat: @"'%d',", tag_category_id];
    [strSQL appendFormat: @"'%@',", category_name];
    [strSQL appendFormat: @"'%d',", category_type];
    [strSQL appendFormat: @"'%@')", tags];
    [m_sqlManager runDynamicSQL: strSQL forTable: @"tbl_category"];
    
}

//================================================================================================================================================================================================
-(NSArray*) getAllCategory
{
    NSString* strQuery;
    strQuery = [NSString stringWithFormat: @"select * from tbl_category"];
    return [m_sqlManager lookupAllForSQL: strQuery];
    
}

//================================================================================================================================================================================================
-(NSArray*) getCategoryWithID: (int) tag_category_id
{
    NSString* strQuery;
    strQuery = [NSString stringWithFormat: @"select * from tbl_category where tag_category_id = %d", tag_category_id];
    return [m_sqlManager lookupAllForSQL: strQuery];
}

//================================================================================================================================================================================================
-(void) deleteAllCategoy
{
    NSString* strQuery = @"delete from tbl_category";
    [m_sqlManager lookupAllForSQL: strQuery];
}

#pragma mark -
#pragma mark Tag Managemnet.

//================================================================================================================================================================================================
-(void) insertTag: (int) tag_id
         tag_name: (NSString*) tag_name
{
    NSMutableString* strSQL = [[NSMutableString alloc] init];
    [strSQL appendFormat: @"insert into '%@'('tag_id', 'tag_name') values(", @"tbl_tag"];
    [strSQL appendFormat: @"'%d',", tag_id];
    [strSQL appendFormat: @"'%@')", tag_name];
    [m_sqlManager runDynamicSQL: strSQL forTable: @"tbl_tag"];
}

//================================================================================================================================================================================================
-(NSArray*) getAllTags
{
    NSString* strQuery;
    strQuery = [NSString stringWithFormat: @"select * from tbl_tag"];
    return [m_sqlManager lookupAllForSQL: strQuery];
}

//================================================================================================================================================================================================
-(NSArray*) getTagWithID: (int) tag_id
{
    NSString* strQuery;
    strQuery = [NSString stringWithFormat: @"select * from tbl_tag where tag_id = %d", tag_id];
    return [m_sqlManager lookupAllForSQL: strQuery];
}

//================================================================================================================================================================================================
-(void) deleteAllTag
{
    NSString* strQuery = @"delete from tbl_tag";
    [m_sqlManager lookupAllForSQL: strQuery];
}

#pragma mark -
#pragma mark AssignedUser Management.

//================================================================================================================================================================================================
-(void) insertAssignedUser: (int) admin_id
              coach_row_id: (int) coach_row_id
                     email: (NSString*) email
                 firstname: (NSString*) firstname
                  lastname: (NSString*) lastname
{
    NSMutableString* strSQL = [[NSMutableString alloc] init];
    [strSQL appendFormat: @"insert into '%@'('admin_id', 'coach_row_id', 'email', 'firstname', 'lastname') values(", @"tbl_assigned_user"];
    [strSQL appendFormat: @"'%d',", admin_id];
    [strSQL appendFormat: @"'%d',", coach_row_id];
    [strSQL appendFormat: @"'%@',", email];
    [strSQL appendFormat: @"'%@',", firstname];
    [strSQL appendFormat: @"'%@')", lastname];
    [m_sqlManager runDynamicSQL: strSQL forTable: @"tbl_assigned_user"];
}

//================================================================================================================================================================================================
-(NSArray*) getAllAssignedUser
{
    NSString* strQuery;
    strQuery = [NSString stringWithFormat: @"select * from tbl_assigned_user"];
    return [m_sqlManager lookupAllForSQL: strQuery];
}

//================================================================================================================================================================================================
-(NSArray*) getAssignedUserByID: (int) admin_id
{
    NSString* strQuery;
    strQuery = [NSString stringWithFormat: @"select * from tbl_assigned_user where admin_id = %d", admin_id];
    return [m_sqlManager lookupAllForSQL: strQuery];
}

//================================================================================================================================================================================================
-(void) deleteAllAssignedUser
{
    NSString* strQuery = @"delete from tbl_assigned_user";
    [m_sqlManager lookupAllForSQL: strQuery];
}

#pragma mark -
#pragma mark Lead Role Management.

//================================================================================================================================================================================================
-(void) insertLeadRole: (int) admin_id
                 email: (NSString*) email
             firstname: (NSString*) firstname
        is_def_primary: (int) is_def_primary
        is_def_support: (int) is_def_support
           is_def_tech: (int) is_def_tech
              lastname: (NSString*) lastname
             role_type: (int) role_type
{
    NSMutableString* strSQL = [[NSMutableString alloc] init];
    [strSQL appendFormat: @"insert into '%@'('admin_id', 'email', 'firstname', 'is_def_primary', 'is_def_support', 'is_def_tech', 'lastname', 'role_type') values(", @"tbl_lead_role"];
    [strSQL appendFormat: @"'%d',", admin_id];
    [strSQL appendFormat: @"'%@',", email];
    [strSQL appendFormat: @"'%@',", firstname];
    [strSQL appendFormat: @"'%d',", is_def_primary];
    [strSQL appendFormat: @"'%d',", is_def_support];
    [strSQL appendFormat: @"'%d',", is_def_tech];
    [strSQL appendFormat: @"'%@',", lastname];
    [strSQL appendFormat: @"'%d')", role_type];
    
    [m_sqlManager runDynamicSQL: strSQL forTable: @"tbl_lead_role"];
}

//================================================================================================================================================================================================
-(NSArray*) getAllLeadRole
{
    NSString* strQuery;
    strQuery = [NSString stringWithFormat: @"select * from tbl_lead_role"];
    return [m_sqlManager lookupAllForSQL: strQuery];
}

//================================================================================================================================================================================================
-(NSArray*) getLeadRoleByID: (int) admin_id
{
    NSString* strQuery;
    strQuery = [NSString stringWithFormat: @"select * from tbl_lead_role where admin_id = %d", admin_id];
    return [m_sqlManager lookupAllForSQL: strQuery];
}

//================================================================================================================================================================================================
-(NSArray*) getLeadRoleByType: (int) role_type
{
    NSString* strQuery;
    strQuery = [NSString stringWithFormat: @"select * from tbl_lead_role where role_type='%d'", role_type];
    return [m_sqlManager lookupAllForSQL: strQuery];
}

//================================================================================================================================================================================================
-(void) deleteAllLeadRole
{
    NSString* strQuery = @"delete from tbl_lead_role";
    [m_sqlManager lookupAllForSQL: strQuery];
}

#pragma mark -
#pragma mark Product Category.

//================================================================================================================================================================================================
-(void) insertProductCategory: (NSString*) name
                        value: (NSString*) value
{
    NSMutableString* strSQL = [[NSMutableString alloc] init];
    [strSQL appendFormat: @"insert into '%@'('name', 'value') values(", @"tbl_product_category"];
    [strSQL appendFormat: @"'%@',", name];
    [strSQL appendFormat: @"'%@')", value];
    NSLog(@"%@", strSQL);
    
    [m_sqlManager runDynamicSQL: strSQL forTable: @"tbl_product_category"];
}

//================================================================================================================================================================================================
-(NSArray*) getAllProductCategory
{
    NSString* strQuery;
    strQuery = [NSString stringWithFormat: @"select * from tbl_product_category"];
    return [m_sqlManager lookupAllForSQL: strQuery];
}

//================================================================================================================================================================================================
-(void) deleteAllProductCategory
{
    NSString* strQuery = @"delete from tbl_product_category";
    [m_sqlManager lookupAllForSQL: strQuery];
}

#pragma mark -
#pragma mark Task2

//================================================================================================================================================================================================
-(void) insertTask2: (int) task_id
          task_name: (NSString*) task_name
          task_type: (int) task_type
{
    NSMutableString* strSQL = [[NSMutableString alloc] init];
    [strSQL appendFormat: @"insert into '%@'('task_id', 'task_name', 'task_type') values(", @"tbl_task2"];
    [strSQL appendFormat: @"'%d',", task_id];
    [strSQL appendFormat: @"'%@',", task_name];
    [strSQL appendFormat: @"'%d')", task_type];
    NSLog(@"%@", strSQL);
    
    [m_sqlManager runDynamicSQL: strSQL forTable: @"tbl_task2"];
}

//================================================================================================================================================================================================
-(NSArray*) getAllTask2
{
    NSString* strQuery;
    strQuery = [NSString stringWithFormat: @"select * from tbl_task2"];
    return [m_sqlManager lookupAllForSQL: strQuery];
}

//================================================================================================================================================================================================
-(void) deleteAllTask2
{
    NSString* strQuery = @"delete from tbl_task2";
    [m_sqlManager lookupAllForSQL: strQuery];
}

#pragma mark -
#pragma mark Project List.

//================================================================================================================================================================================================
-(void) insertProjectList: (NSString*) Id
                 ProjName: (NSString*) ProjName
{
    NSMutableString* strSQL = [[NSMutableString alloc] init];
    [strSQL appendFormat: @"insert into '%@'('Id', 'ProjName') values(", @"tbl_project_list"];
    [strSQL appendFormat: @"'%@',", Id];
    [strSQL appendFormat: @"'%@')", ProjName];
    [m_sqlManager runDynamicSQL: strSQL forTable: @"tbl_project_list"];
}

//================================================================================================================================================================================================
-(NSArray*) getAllProjectLists
{
    NSString* strQuery;
    strQuery = [NSString stringWithFormat: @"select * from tbl_project_list"];
    return [m_sqlManager lookupAllForSQL: strQuery];
}

//================================================================================================================================================================================================
-(void) deleteAllProjectLists
{
    NSString* strQuery = @"delete from tbl_project_list";
    [m_sqlManager lookupAllForSQL: strQuery];
}

#pragma mark
#pragma mark Project Manager Task Title

//================================================================================================================================================================================================
-(void) insertPMTaskTitle: (NSString*) tasktitleid
                tasktitle: (NSString*) tasktitle
                taskcount: (NSString*) taskcount
               project_id: (NSString*) project_id
{
    NSMutableString* strSQL = [[NSMutableString alloc] init];
    [strSQL appendFormat: @"insert into '%@'('tasktitleid', 'tasktitle', 'taskcount', 'project_id') values(", @"tbl_pm_tasktitle"];
    [strSQL appendFormat: @"'%@',", tasktitleid];
    [strSQL appendFormat: @"'%@',", tasktitle];
    [strSQL appendFormat: @"'%@',", taskcount];
    [strSQL appendFormat: @"'%@')", project_id];
    [m_sqlManager runDynamicSQL: strSQL forTable: @"tbl_pm_tasktitle"];
}

//================================================================================================================================================================================================
-(NSArray*) getPMTaskTitlesByProjectID: (NSString*) project_id
{
    NSString* strQuery;
    strQuery = [NSString stringWithFormat: @"select * from tbl_pm_tasktitle where project_id = %@", project_id];
    return [m_sqlManager lookupAllForSQL: strQuery];
}

//================================================================================================================================================================================================
-(NSArray*) getAllPMTaskTitles
{
    NSString* strQuery;
    strQuery = [NSString stringWithFormat: @"select * from tbl_pm_tasktitle"];
    return [m_sqlManager lookupAllForSQL: strQuery];
}

//================================================================================================================================================================================================
-(void) deleteAllPMTaskTitles
{
    NSString* strQuery = @"delete from tbl_pm_tasktitle";
    [m_sqlManager lookupAllForSQL: strQuery];
}

//================================================================================================================================================================================================
-(void) deleteAllPMTaskTitleByProjectID: (NSString*) project_id
{
    NSString* strQuery = [NSString stringWithFormat: @"delete from tbl_pm_tasktitle where project_id = %@", project_id];
    NSLog(@"strQuery = %@", strQuery);
    [m_sqlManager lookupAllForSQL: strQuery];
}

#pragma mark -
#pragma mark Project Manager Task List

//================================================================================================================================================================================================
-(void) insertPMTaskList: (NSString*) assignedto
                priority: (NSString*) priority
              sprintname: (NSString*) sprintname
               tasktitle: (NSString*) tasktitle
                 taskurl: (NSString*) taskurl
              project_id: (NSString*) project_id
                title_id: (NSString*) title_id
                  todoid: (NSString*) todoid
{
    NSMutableString* strSQL = [[NSMutableString alloc] init];
    [strSQL appendFormat: @"insert into '%@'('assignedto', 'priority', 'sprintname', 'tasktitle', 'taskurl', 'project_id', 'title_id', 'todoid') values(", @"tbl_pm_tasklist"];
    [strSQL appendFormat: @"'%@',", assignedto];
    [strSQL appendFormat: @"'%@',", priority];
    [strSQL appendFormat: @"'%@',", sprintname];
    [strSQL appendFormat: @"'%@',", tasktitle];
    [strSQL appendFormat: @"'%@',", taskurl];
    [strSQL appendFormat: @"'%@',", project_id];
    [strSQL appendFormat: @"'%@',", title_id];    
    [strSQL appendFormat: @"'%@')", todoid];
    [m_sqlManager runDynamicSQL: strSQL forTable: @"tbl_pm_tasklist"];
}

//================================================================================================================================================================================================
-(NSArray*) getPMTaskListsByProjectID: (NSString*) project_id title_id: (NSString*) title_id
{
    NSString* strQuery;
    strQuery = [NSString stringWithFormat: @"select * from tbl_pm_tasklist where project_id = %@ and title_id = %@", project_id, title_id];
    return [m_sqlManager lookupAllForSQL: strQuery];
}

//================================================================================================================================================================================================
-(NSArray*) getAllPMTaskLists
{
    NSString* strQuery;
    strQuery = [NSString stringWithFormat: @"select * from tbl_pm_tasklist"];
    return [m_sqlManager lookupAllForSQL: strQuery];
}

//================================================================================================================================================================================================
-(void) deleteAllPMTaskLists
{
    NSString* strQuery = @"delete from tbl_pm_tasklist";
    [m_sqlManager lookupAllForSQL: strQuery];
}

//================================================================================================================================================================================================
-(void) deleteAllPMTaskListsByProjectID: (NSString*) project_id title_id: (NSString*) title_id
{
    NSString* strQuery = [NSString stringWithFormat: @"delete from tbl_pm_tasklist where project_id = %@ and title_id = %@", project_id, title_id];
    NSLog(@"strQuery = %@", strQuery);
    [m_sqlManager lookupAllForSQL: strQuery];
}

#pragma mark -
#pragma mark Broadcast Management.

//================================================================================================================================================================================================
-(void) insertBroadcast: (int) broadcast_id
                   type: (NSString*) type
         broadcast_date: (NSString*) broadcast_date
      broadcast_subject: (NSString*) broadcast_subject
{
    NSMutableString* strSQL = [[NSMutableString alloc] init];
    [strSQL appendFormat: @"insert into '%@'('broadcast_id', 'type', 'broadcast_date', 'broadcast_subject') values(", @"tbl_crm_broadcast"];
    [strSQL appendFormat: @"'%d',", broadcast_id];
    [strSQL appendFormat: @"'%@',", type];
    [strSQL appendFormat: @"'%@',", broadcast_date];
    [strSQL appendFormat: @"'%@')", broadcast_subject];
    [m_sqlManager runDynamicSQL: strSQL forTable: @"tbl_crm_broadcast"];
}

//================================================================================================================================================================================================
-(NSArray*) getAllBroadcasts
{
    NSString* strQuery;
    strQuery = [NSString stringWithFormat: @"select * from tbl_crm_broadcast"];
    return [m_sqlManager lookupAllForSQL: strQuery];
}

//================================================================================================================================================================================================
-(void) deleteAllBroadcasts
{
    NSString* strQuery = @"delete from tbl_crm_broadcast";
    [m_sqlManager lookupAllForSQL: strQuery];
}

#pragma mark -
#pragma mark Project Manager Task Detail.

//================================================================================================================================================================================================
-(void) insertPMTaskDetail: (NSString*) AdminId
           CurrentStatusId: (NSString*) CurrentStatusId
                      Date: (NSString*) Date
                        Id: (NSString*) Id
                    IsArcv: (NSString*) IsArcv
                    IsLock: (NSString*) IsLock
                    PathId: (NSString*) PathId
                  Priority: (NSString*) Priority
                PriorityId: (NSString*) PriorityId
                    ProjId: (NSString*) ProjId
                  ProjName: (NSString*) ProjName
                  SprintId: (NSString*) SprintId
               TaskTitleId: (NSString*) TaskTitleId
                     Title: (NSString*) Title
                 TodoTitle: (NSString*) TodoTitle
                      Type: (NSString*) Type
                    UserId: (NSString*) UserId
                assignbyid: (NSString*) assignbyid
      assignedby_firstname: (NSString*) assignedby_firstname
       assignedby_lastname: (NSString*) assignedby_lastname
      assignedto_firstname: (NSString*) assignedto_firstname
       assignedto_lastname: (NSString*) assignedto_lastname
                assigntoid: (NSString*) assigntoid
       peopleResponsibleId: (NSString*) peopleResponsibleId
                sprintname: (NSString*) sprintname
         taskdetailcomment: (NSString*) taskdetailcomment
                 ticket_id: (NSString*) ticket_id
               ticket_type: (NSString*) ticket_type
                  Duration: (NSString*) Duration
                   enddate: (NSString*) enddate
                 startdate: (NSString*) startdate
              taskprogress: (NSString*) taskprogress
          task_description: (NSString*) task_description
                 allsprint: (NSString*) allsprint
             taskemaillist: (NSString*) taskemaillist
{
    NSMutableString* strSQL = [[NSMutableString alloc] init];
    [strSQL appendFormat: @"insert into '%@'('AdminId', 'CurrentStatusId', 'Date', 'Id', 'IsArcv', 'IsLock', 'PathId', 'Priority', 'PriorityId', 'ProjId', 'ProjName', 'SprintId', 'TaskTitleId', 'Title', 'TodoTitle', 'Type', 'UserId', 'assignbyid', 'assignedby_firstname', 'assignedby_lastname', 'assignedto_firstname', 'assignedto_lastname', 'assigntoid', 'peopleResponsibleId', 'sprintname', 'taskdetailcomment', 'ticket_id', 'ticket_type', 'Duration', 'enddate', 'startdate', 'taskprogress', 'task_description', 'allsprint', 'taskemaillist') values(", @"tbl_pm_taskdetail"];
    [strSQL appendFormat: @"'%@',", AdminId];
    [strSQL appendFormat: @"'%@',", CurrentStatusId];
    [strSQL appendFormat: @"'%@',", Date];
    [strSQL appendFormat: @"'%@',", Id];
    [strSQL appendFormat: @"'%@',", IsArcv];
    [strSQL appendFormat: @"'%@',", IsLock];
    [strSQL appendFormat: @"'%@',", PathId];
    [strSQL appendFormat: @"'%@',", Priority];
    [strSQL appendFormat: @"'%@',", PriorityId];
    [strSQL appendFormat: @"'%@',", ProjId];
    [strSQL appendFormat: @"'%@',", ProjName];
    [strSQL appendFormat: @"'%@',", SprintId];
    [strSQL appendFormat: @"'%@',", TaskTitleId];
    [strSQL appendFormat: @"'%@',", Title];
    [strSQL appendFormat: @"'%@',", TodoTitle];
    [strSQL appendFormat: @"'%@',", Type];
    [strSQL appendFormat: @"'%@',", UserId];
    [strSQL appendFormat: @"'%@',", assignbyid];
    [strSQL appendFormat: @"'%@',", assignedby_firstname];
    [strSQL appendFormat: @"'%@',", assignedby_lastname];
    [strSQL appendFormat: @"'%@',", assignedto_firstname];
    [strSQL appendFormat: @"'%@',", assignedto_lastname];
    [strSQL appendFormat: @"'%@',", assigntoid];
    [strSQL appendFormat: @"'%@',", peopleResponsibleId];
    [strSQL appendFormat: @"'%@',", sprintname];
    [strSQL appendFormat: @"'%@',", taskdetailcomment];
    [strSQL appendFormat: @"'%@',", ticket_id];
    [strSQL appendFormat: @"'%@',", ticket_type];
    [strSQL appendFormat: @"'%@',", Duration];
    [strSQL appendFormat: @"'%@',", enddate];
    [strSQL appendFormat: @"'%@',", startdate];
    [strSQL appendFormat: @"'%@',", taskprogress];
    [strSQL appendFormat: @"'%@',", task_description];
    [strSQL appendFormat: @"'%@',", allsprint];    
    [strSQL appendFormat: @"'%@')", taskemaillist];
    [m_sqlManager runDynamicSQL: strSQL forTable: @"tbl_pm_taskdetail"];
}

//================================================================================================================================================================================================
-(NSArray*) getPMTaskDetails: (NSString*) Id ProjId: (NSString*) ProjId
{
    NSString* strQuery;
    strQuery = [NSString stringWithFormat: @"select * from tbl_pm_taskdetail where ProjId = %@ and Id = %@", ProjId, Id];
    return [m_sqlManager lookupAllForSQL: strQuery];
}

//================================================================================================================================================================================================
-(void) deletePMTaskDetails: (NSString*) Id ProjId: (NSString*) ProjId
{
    NSString* strQuery = [NSString stringWithFormat: @"delete from tbl_pm_taskdetail where ProjId = %@ and Id = %@", ProjId, Id];
    [m_sqlManager lookupAllForSQL: strQuery];
}

#pragma mark -
#pragma mark Project Manager Task Detail Comment.

//================================================================================================================================================================================================
-(void) insertPMTaskDetailComment: (NSString*) comment_adminid
              comment_description: (NSString*) comment_description
                     comment_date: (NSString*) comment_date
                       comment_id: (NSString*) comment_id
                 comment_peopleid: (NSString*) comment_peopleid
                 comment_submitby: (NSString*) comment_submitby
                    Comment_files: (NSString*) Comment_files
{
    NSString* strQuery;
    strQuery = [NSString stringWithFormat: @"select * from tbl_pm_taskcomments where comment_id = '%@'", comment_id];
    NSArray* arrComments = [m_sqlManager lookupAllForSQL: strQuery];
    
    //Insert.
    if(arrComments == nil || [arrComments count] <= 0)
    {
        NSMutableString* strSQL = [[NSMutableString alloc] init];
        [strSQL appendFormat: @"insert into '%@'('comment_adminid', 'comment_description', 'comment_date', 'comment_id', 'comment_peopleid', 'comment_submitby', 'Comment_files') values(", @"tbl_pm_taskcomments"];
        [strSQL appendFormat: @"'%@',", comment_adminid];
        [strSQL appendFormat: @"'%@',", comment_description];
        [strSQL appendFormat: @"'%@',", comment_date];
        [strSQL appendFormat: @"'%@',", comment_id];
        [strSQL appendFormat: @"'%@',", comment_peopleid];
        [strSQL appendFormat: @"'%@',", comment_submitby];
        [strSQL appendFormat: @"'%@')", Comment_files];
        
        [m_sqlManager runDynamicSQL: strSQL forTable: @"tbl_pm_taskcomments"];
    }
    
    //Update
    else
    {
        NSString* strQuery = [NSString stringWithFormat: @"update tbl_pm_taskcomments set comment_adminid='%@', comment_description='%@', comment_date='%@', comment_peopleid='%@', comment_submitby='%@', Comment_files='%@', where comment_id = '%@'", comment_adminid, comment_description, comment_date, comment_peopleid, comment_submitby, Comment_files, comment_id];
        [m_sqlManager lookupAllForSQL: strQuery];
    }
}

//================================================================================================================================================================================================
-(NSArray*) getPMTaskDetailComment: (NSString*) comment_id
{
    NSString* strQuery;
    strQuery = [NSString stringWithFormat: @"select * from tbl_pm_taskcomments where comment_id = '%@'", comment_id];
    return [m_sqlManager lookupAllForSQL: strQuery];
}

//================================================================================================================================================================================================
-(NSArray*) getAllPMTaskDetailComments
{
    NSString* strQuery;
    strQuery = [NSString stringWithFormat: @"select * from tbl_pm_taskcomments"];
    return [m_sqlManager lookupAllForSQL: strQuery];
}

#pragma mark -
#pragma mark Project Management Task User List.
//================================================================================================================================================================================================
-(void) insertPMTaskUserList: (NSString*) tc_comapnyid
              tc_companyname: (NSString*) tc_companyname
                 tc_ismaster: (NSString*) tc_ismaster
                     tc_type: (NSString*) tc_type
                      people: (NSString*) people
                  project_id: (NSString*) project_id
{
    if(tc_comapnyid == nil || [tc_comapnyid isKindOfClass: [NSNull class]] || [tc_comapnyid length] <= 0) return;
    
    NSString* strQuery;
    strQuery = [NSString stringWithFormat: @"select * from tbl_pm_task_userlist where tc_comapnyid = '%@' and project_id = '%@'", tc_comapnyid, project_id];
    NSArray* arrCommentFiles = [m_sqlManager lookupAllForSQL: strQuery];
    
    //Insert.
    if(arrCommentFiles == nil || [arrCommentFiles count] <= 0)
    {
        NSMutableString* strSQL = [[NSMutableString alloc] init];
        [strSQL appendFormat: @"insert into '%@'('tc_comapnyid', 'tc_companyname', 'tc_ismaster', 'tc_type', 'people','project_id') values(", @"tbl_pm_task_userlist"];
        [strSQL appendFormat: @"'%@',", tc_comapnyid];
        [strSQL appendFormat: @"'%@',", tc_companyname];
        [strSQL appendFormat: @"'%@',", tc_ismaster];
        [strSQL appendFormat: @"'%@',", tc_type];
        [strSQL appendFormat: @"'%@',",  people];
        [strSQL appendFormat: @"'%@')", project_id];        
        [m_sqlManager runDynamicSQL: strSQL forTable: @"tbl_pm_task_userlist"];
    }
    //Update
    else
    {
        //update
        NSString* strQuery = [NSString stringWithFormat: @"update tbl_pm_task_userlist set tc_companyname='%@', tc_ismaster='%@', tc_type='%@', people='%@' where tc_comapnyid = '%@' and project_id = '%@'", tc_companyname, tc_ismaster, tc_type, people, tc_comapnyid, project_id];
        [m_sqlManager lookupAllForSQL: strQuery];
    }
}

//================================================================================================================================================================================================
-(NSArray*) getAllPMTaskUserListByProjectID: (NSString*) project_id
{
    NSString* strQuery;
    strQuery = [NSString stringWithFormat: @"select * from tbl_pm_task_userlist where project_id = '%@'", project_id];
    return [m_sqlManager lookupAllForSQL: strQuery];
}

//================================================================================================================================================================================================
-(NSDictionary*) getPMTaskUserListById: (NSString*) tc_comapnyid project_id: (NSString*) project_id
{
    NSString* strQuery;
    strQuery = [NSString stringWithFormat: @"select * from tbl_pm_task_userlist where tc_comapnyid = '%@' and project_id = '%@'", tc_comapnyid, project_id];
    NSArray* arr = [m_sqlManager lookupAllForSQL: strQuery];
    if(arr != nil && [arr count] > 0)
    {
        return [arr objectAtIndex: 0];
    }
    
    return nil;
}

//================================================================================================================================================================================================
-(void) deleteAllPMTaskUserListByProjectID: (NSString*) project_id
{
    NSString* strQuery = [NSString stringWithFormat: @"delete from tbl_pm_task_userlist where project_id = '%@'", project_id];
    [m_sqlManager lookupAllForSQL: strQuery];
}

#pragma mark -
#pragma mark Project Management Task People.

//================================================================================================================================================================================================
-(void) insertPMTaskPeople: (NSString*) tc_companyname
                     tc_id: (NSString*) tc_id
               tc_ismaster: (NSString*) tc_ismaster
                   tc_type: (NSString*) tc_type
              tp_firstname: (NSString*) tp_firstname
                     tp_id: (NSString*) tp_id
               tp_lastname: (NSString*) tp_lastname
                  selected: (NSString*) selected
{
    if(tp_id == nil || [tp_id isKindOfClass: [NSNull class]] || [tp_id length] <= 0) return;
    
    NSString* strQuery;
    strQuery = [NSString stringWithFormat: @"select * from tbl_pm_task_people where tp_id = '%@'", tp_id];
    NSArray* arrCommentFiles = [m_sqlManager lookupAllForSQL: strQuery];
    
    //Insert.
    if(arrCommentFiles == nil || [arrCommentFiles count] <= 0)
    {
        NSMutableString* strSQL = [[NSMutableString alloc] init];
        [strSQL appendFormat: @"insert into '%@'('tc_companyname', 'tc_id', 'tc_ismaster', 'tc_type', 'tp_firstname', 'tp_id', 'tp_lastname', 'selected') values(", @"tbl_pm_task_people"];

        [strSQL appendFormat: @"'%@',", tc_companyname];
        [strSQL appendFormat: @"'%@',", tc_id];
        [strSQL appendFormat: @"'%@',", tc_ismaster];
        [strSQL appendFormat: @"'%@',", tc_type];
        [strSQL appendFormat: @"'%@',", tp_firstname];
        [strSQL appendFormat: @"'%@',", tp_id];
        [strSQL appendFormat: @"'%@',", tp_lastname];
        [strSQL appendFormat: @"'%@')", selected];
        [m_sqlManager runDynamicSQL: strSQL forTable: @"tbl_pm_task_people"];
    }
    
    //Update
    else
    {
        NSString* strQuery = [NSString stringWithFormat: @"update tbl_pm_task_people set tc_companyname='%@', tc_id='%@', tc_ismaster='%@', tc_type='%@', tp_firstname='%@', tp_lastname='%@', selected='%@' where tp_id = '%@'", tc_companyname, tc_id, tc_ismaster, tc_type, tp_firstname, tp_lastname, selected, tp_id];
        [m_sqlManager lookupAllForSQL: strQuery];
    }
}

//================================================================================================================================================================================================
-(NSArray*) getAllPMTaskPeople
{
    NSString* strQuery;
    strQuery = [NSString stringWithFormat: @"select * from tbl_pm_task_people"];
    return [m_sqlManager lookupAllForSQL: strQuery];
}

//================================================================================================================================================================================================
-(NSArray*) getPMTaskPeopleByID: (NSString*) tp_id
{
    NSString* strQuery;
    strQuery = [NSString stringWithFormat: @"select * from tbl_pm_task_people where tp_id = %@", tp_id];
    return [m_sqlManager lookupAllForSQL: strQuery];
}

//================================================================================================================================================================================================
-(NSDictionary*) getPMTaskPeopleByTPID: (NSString*) tp_id
{
    NSString* strQuery;
    strQuery = [NSString stringWithFormat: @"select * from tbl_pm_task_people where tp_id = %@", tp_id];
    NSArray* arr = [m_sqlManager lookupAllForSQL: strQuery];
    if(arr != nil && [arr count] > 0)
    {
        return [arr objectAtIndex: 0];
    }
    return nil;
}

//================================================================================================================================================================================================
-(void) deleteAllPMTaskPeople
{
    NSString* strQuery = @"delete from tbl_pm_task_people";
    [m_sqlManager lookupAllForSQL: strQuery];
}

#pragma mark -
#pragma mark Project Management Task Progress.

//================================================================================================================================================================================================
-(void) insertPMTaskProgress: (NSString*) PathId
                   ProjectId: (NSString*) ProjectId
                progress_bar: (NSString*) progress_bar
               approve_title: (NSString*) approve_title
                        date: (NSString*) date
                      status: (NSString*) status
                status_title: (NSString*) status_title
             unapprove_title: (NSString*) unapprove_title
{
    NSMutableString* strSQL = [[NSMutableString alloc] init];
    [strSQL appendFormat: @"insert into '%@'('PathId', 'ProjectId', 'progress_bar', 'approve_title', 'date', 'status', 'status_title', 'unapprove_title') values(", @"tbl_pm_task_progress"];
    [strSQL appendFormat: @"'%@',", PathId];
    [strSQL appendFormat: @"'%@',", ProjectId];
    [strSQL appendFormat: @"'%@',", progress_bar];
    [strSQL appendFormat: @"'%@',", approve_title];
    [strSQL appendFormat: @"'%@',", date];
    [strSQL appendFormat: @"'%@',", status];
    [strSQL appendFormat: @"'%@',", status_title];    
    [strSQL appendFormat: @"'%@')", unapprove_title];
    
    [m_sqlManager runDynamicSQL: strSQL forTable: @"tbl_pm_task_progress"];
}

//================================================================================================================================================================================================
-(NSArray*) getPMTaskProgressByPathId: (NSString*) PathId
{
    NSString* strQuery;
    strQuery = [NSString stringWithFormat: @"select * from tbl_pm_task_progress where PathId = %@", PathId];
    return [m_sqlManager lookupAllForSQL: strQuery];
}

//================================================================================================================================================================================================
-(void) deletePMTaskProgress: (NSString*) PathId
{
    NSString* strQuery = [NSString stringWithFormat: @"delete from tbl_pm_task_progress where PathId = %@", PathId];
    [m_sqlManager lookupAllForSQL: strQuery];
}

//Project Management Progress Bar.
//================================================================================================================================================================================================
-(void) insertPMProgressBar: (NSString*) Id
              progress_date: (NSString*) progress_date
            progress_status: (NSString*) progress_status
             progress_title: (NSString*) progress_title
                      title: (NSString*) title
{
    NSMutableString* strSQL = [[NSMutableString alloc] init];
    [strSQL appendFormat: @"insert into '%@'('Id', 'progress_date', 'progress_status', 'progress_title', 'title') values(", @"tbl_pm_progress_bar"];
    [strSQL appendFormat: @"'%@',", Id];
    [strSQL appendFormat: @"'%@',", progress_date];
    [strSQL appendFormat: @"'%@',", progress_status];
    [strSQL appendFormat: @"'%@',", progress_title];    
    [strSQL appendFormat: @"'%@')", title];
    
    [m_sqlManager runDynamicSQL: strSQL forTable: @"tbl_pm_progress_bar"];
}

//================================================================================================================================================================================================
-(NSArray*) getPMProgressBarById: (NSString*) Id
{
    NSString* strQuery;
    strQuery = [NSString stringWithFormat: @"select * from tbl_pm_progress_bar where Id = %@", Id];
    return [m_sqlManager lookupAllForSQL: strQuery];
}

//================================================================================================================================================================================================
-(NSArray*) getPMAllProgressBar
{
    NSString* strQuery;
    strQuery = [NSString stringWithFormat: @"select * from tbl_pm_progress_bar"];
    return [m_sqlManager lookupAllForSQL: strQuery];
}

//================================================================================================================================================================================================
-(void) deletePMProgressBar: (NSString*) Id
{
    NSString* strQuery = [NSString stringWithFormat: @"delete from tbl_pm_progress_bar where Id = %@", Id];
    [m_sqlManager lookupAllForSQL: strQuery];
}

#pragma mark -
#pragma mark Project Management Sprint Management.

//================================================================================================================================================================================================
-(void) insertPMSprite: (NSString*) sprint_id
           sprint_name: (NSString*) sprint_name
        current_sprint: (NSString*) current_sprint
            project_id: (NSString*) project_id
                todoid: (NSString*) todoid
{
    NSMutableString* strSQL = [[NSMutableString alloc] init];
    [strSQL appendFormat: @"insert into '%@'('sprint_id', 'sprint_name', 'current_sprint', 'project_id', 'todoid') values(", @"tbl_pm_sprint"];
    [strSQL appendFormat: @"'%@',", sprint_id];
    [strSQL appendFormat: @"'%@',", sprint_name];
    [strSQL appendFormat: @"'%@',", current_sprint];
    [strSQL appendFormat: @"'%@',", project_id];
    [strSQL appendFormat: @"'%@')", todoid];
    
    [m_sqlManager runDynamicSQL: strSQL forTable: @"tbl_pm_sprint"];
}

//================================================================================================================================================================================================
-(NSArray*) getPMAllSprintByProjectID: (NSString*) project_id todoid: (NSString*) todoid
{
    NSString* strQuery;
    strQuery = [NSString stringWithFormat: @"select * from tbl_pm_sprint where project_id = '%@' and todoid = '%@'", project_id, todoid];
    return [m_sqlManager lookupAllForSQL: strQuery];
}

//================================================================================================================================================================================================
-(NSDictionary*) getPMSprintByID: (NSString*) sprint_id
{
    NSString* strQuery;
    strQuery = [NSString stringWithFormat: @"select * from tbl_pm_sprint where sprint_id = '%@'", sprint_id];
    NSArray* arr = [m_sqlManager lookupAllForSQL: strQuery];
    if(arr != nil && [arr count] > 0)
    {
        NSDictionary* dicResult = [arr objectAtIndex: 0];
        return dicResult;
    }
    
    return nil;
}

//================================================================================================================================================================================================
-(NSString*) getPMSprintNameByID: (NSString*) sprint_id
{
    NSString* strQuery;
    strQuery = [NSString stringWithFormat: @"select * from tbl_pm_sprint where sprint_id = '%@'", sprint_id];
    NSArray* arr = [m_sqlManager lookupAllForSQL: strQuery];
    if(arr != nil && [arr count] > 0)
    {
        NSDictionary* dicResult = [arr objectAtIndex: 0];
        return [dicResult valueForKey: @"sprint_name"];
    }
    
    return nil;
}

//================================================================================================================================================================================================
-(void) deletePMSprintByID: (NSString*) sprint_id
{
    NSString* strQuery = [NSString stringWithFormat: @"delete from tbl_pm_sprint where sprint_id = '%@'", sprint_id];
    [m_sqlManager lookupAllForSQL: strQuery];
}

//================================================================================================================================================================================================
-(void) deletePMAllSprintByProjectID: (NSString*) project_id todoid: (NSString*) todoid
{
    NSString* strQuery = [NSString stringWithFormat: @"delete from tbl_pm_sprint where project_id = '%@' and todoid = '%@'", project_id, todoid];
    [m_sqlManager lookupAllForSQL: strQuery];
}

#pragma -
#pragma Project Management Comment Files.

//================================================================================================================================================================================================
-(void) insertPMTaskCommentFiles: (NSString*) fileid fileurl: (NSString*) fileurl filname: (NSString*) filname uploadeddate: (NSString*) uploadeddate
{
    NSString* strQuery;
    strQuery = [NSString stringWithFormat: @"select * from tbl_pm_task_comment_files where fileid = '%@'", fileid];
    NSArray* arrCommentFiles = [m_sqlManager lookupAllForSQL: strQuery];

    //Insert.
    if(arrCommentFiles == nil || [arrCommentFiles count] <= 0)
    {
        NSMutableString* strSQL = [[NSMutableString alloc] init];
        [strSQL appendFormat: @"insert into '%@'('fileid', 'fileurl', 'filname', 'uploadeddate') values(", @"tbl_pm_task_comment_files"];
        [strSQL appendFormat: @"'%@',", fileid];
        [strSQL appendFormat: @"'%@',", fileurl];
        [strSQL appendFormat: @"'%@',", filname];
        [strSQL appendFormat: @"'%@')", uploadeddate];
        
        [m_sqlManager runDynamicSQL: strSQL forTable: @"tbl_pm_task_comment_files"];
    }
    
    //Update
    else
    {
        //update
        NSString* strQuery = [NSString stringWithFormat: @"update tbl_pm_task_comment_files set fileurl='%@', filname='%@', uploadeddate='%@' where id = '%@'", fileurl, filname, uploadeddate, fileid];
        [m_sqlManager lookupAllForSQL: strQuery];
    }
}

//================================================================================================================================================================================================
-(NSDictionary*) getPMTaskCommentFile: (NSString*) fileid
{
    NSString* strQuery;
    strQuery = [NSString stringWithFormat: @"select * from tbl_pm_task_comment_files where fileid = '%@'", fileid];
    NSArray* arr = [m_sqlManager lookupAllForSQL: strQuery];
    if(arr != nil && [arr count] > 0)
    {
        return [arr objectAtIndex: 0];
    }
    return nil;
}

#pragma mark -
#pragma mark Project Management Message List.

//================================================================================================================================================================================================
-(void) insertPMMessageList: (NSString*) Id
                       Date: (NSString*) Date
                MessageType: (NSString*) MessageType
                   PostedBy: (NSString*) PostedBy
                    Subject: (NSString*) Subject
                 project_id: (NSString*) project_id
{
    NSMutableString* strSQL = [[NSMutableString alloc] init];
    [strSQL appendFormat: @"insert into '%@'('Id', 'Date', 'MessageType', 'PostedBy', 'Subject', 'project_id') values(", @"tbl_pm_message_list"];
    [strSQL appendFormat: @"'%@',", Id];
    [strSQL appendFormat: @"'%@',", Date];
    [strSQL appendFormat: @"'%@',", MessageType];
    [strSQL appendFormat: @"'%@',", PostedBy];
    [strSQL appendFormat: @"'%@',", Subject];
    [strSQL appendFormat: @"'%@')", project_id];
    
    [m_sqlManager runDynamicSQL: strSQL forTable: @"tbl_pm_message_list"];
}

//================================================================================================================================================================================================
-(NSArray*) getPMMessageListByProjectID: (NSString*) project_id
{
    NSString* strQuery;
    strQuery = [NSString stringWithFormat: @"select * from tbl_pm_message_list where project_id = '%@'", project_id];
    return [m_sqlManager lookupAllForSQL: strQuery];
}

//================================================================================================================================================================================================
-(void) deleteAllPMMessageListByProjectID: (NSString*) project_id
{
    NSString* strQuery = [NSString stringWithFormat: @"delete from tbl_pm_message_list where project_id = '%@'", project_id];
    [m_sqlManager lookupAllForSQL: strQuery];
}


//Message Detail.

//================================================================================================================================================================================================
-(void) insertPMMessageDetail: (NSString*) messageID
             messageProjectId: (NSString*) messageProjectId
               messageSubject: (NSString*) messageSubject
                     postedBy: (NSString*) postedBy
                     postedTo: (NSString*) postedTo
                  messageBody: (NSString*) messageBody
               messageComment: (NSString*) messageComment
                  messageFile: (NSString*) messageFile
{
    NSString* strQuery;
    strQuery = [NSString stringWithFormat: @"select * from tbl_pm_message_detail where messageID = '%@'", messageID];
    NSArray* arrCommentFiles = [m_sqlManager lookupAllForSQL: strQuery];
    
    //Insert.
    if(arrCommentFiles == nil || [arrCommentFiles count] <= 0)
    {
        NSMutableString* strSQL = [[NSMutableString alloc] init];
        [strSQL appendFormat: @"insert into '%@'('messageID', 'messageProjectId', 'messageSubject', 'postedBy', 'postedTo', 'messageBody', 'messageComment', 'messageFile') values(", @"tbl_pm_message_detail"];
        [strSQL appendFormat: @"'%@',", messageID];
        [strSQL appendFormat: @"'%@',", messageProjectId];
        [strSQL appendFormat: @"'%@',", messageSubject];
        [strSQL appendFormat: @"'%@',", postedBy];
        [strSQL appendFormat: @"'%@',", postedTo];
        [strSQL appendFormat: @"'%@',", messageBody];
        [strSQL appendFormat: @"'%@',", messageComment];        
        [strSQL appendFormat: @"'%@')", messageFile];
        
        [m_sqlManager runDynamicSQL: strSQL forTable: @"tbl_pm_message_detail"];
    }
    
    //Update
    else
    {
        //update
        NSString* strQuery = [NSString stringWithFormat: @"update tbl_pm_message_detail set messageProjectId='%@', messageSubject='%@', postedBy='%@', postedTo='%@', messageBody='%@', messageComment='%@', messageFile='%@' where messageID = '%@'", messageProjectId, messageSubject, postedBy, postedTo, messageBody, messageComment, messageFile, messageID];
        [m_sqlManager lookupAllForSQL: strQuery];
    }
}

//================================================================================================================================================================================================
-(NSDictionary*) getPMMessageDetail: (NSString*) messageID
{
    NSString* strQuery;
    strQuery = [NSString stringWithFormat: @"select * from tbl_pm_message_detail where messageID = '%@'", messageID];
    NSArray* arr = [m_sqlManager lookupAllForSQL: strQuery];
    if(arr != nil && [arr count] > 0)
    {
        return [arr objectAtIndex: 0];
    }
    
    return nil;
}

//Message Comment.
//================================================================================================================================================================================================
-(void) insertPMMessageComment: (NSString*) msg_comment_id
          msg_comment_peopleid: (NSString*) msg_comment_peopleid
          msg_comment_submitby: (NSString*) msg_comment_submitby
           msg_comment_adminid: (NSString*) msg_comment_adminid
              msg_comment_date: (NSString*) msg_comment_date
           msg_comment_details: (NSString*) msg_comment_details
             msg_comment_files: (NSString*) msg_comment_files
{
    NSString* strQuery;
    strQuery = [NSString stringWithFormat: @"select * from tbl_pm_message_comment where msg_comment_id = '%@'", msg_comment_id];
    NSArray* arrCommentFiles = [m_sqlManager lookupAllForSQL: strQuery];
    
    //Insert.
    if(arrCommentFiles == nil || [arrCommentFiles count] <= 0)
    {
        NSMutableString* strSQL = [[NSMutableString alloc] init];
        [strSQL appendFormat: @"insert into '%@'('msg_comment_id', 'msg_comment_peopleid', 'msg_comment_submitby', 'msg_comment_adminid', 'msg_comment_date', 'msg_comment_details', 'msg_comment_files') values(", @"tbl_pm_message_comment"];
        [strSQL appendFormat: @"'%@',", msg_comment_id];
        [strSQL appendFormat: @"'%@',", msg_comment_peopleid];
        [strSQL appendFormat: @"'%@',", msg_comment_submitby];
        [strSQL appendFormat: @"'%@',", msg_comment_adminid];
        [strSQL appendFormat: @"'%@',", msg_comment_date];
        [strSQL appendFormat: @"'%@',", msg_comment_details];
        [strSQL appendFormat: @"'%@')", msg_comment_files];
        
        [m_sqlManager runDynamicSQL: strSQL forTable: @"tbl_pm_message_comment"];
    }
    
    //Update
    else
    {
        //update
        NSString* strQuery = [NSString stringWithFormat: @"update tbl_pm_message_comment set msg_comment_peopleid='%@', msg_comment_submitby='%@', msg_comment_adminid='%@', msg_comment_date='%@', msg_comment_details='%@', msg_comment_files='%@' where msg_comment_id = '%@'", msg_comment_peopleid, msg_comment_submitby, msg_comment_adminid, msg_comment_date, msg_comment_details, msg_comment_files, msg_comment_id];
        [m_sqlManager lookupAllForSQL: strQuery];
    }
}

//================================================================================================================================================================================================
-(NSDictionary*) getPMMessageComment: (NSString*) msg_comment_id
{
    NSString* strQuery;
    strQuery = [NSString stringWithFormat: @"select * from tbl_pm_message_comment where msg_comment_id = '%@'", msg_comment_id];
    NSArray* arr = [m_sqlManager lookupAllForSQL: strQuery];
    if(arr != nil && [arr count] > 0)
    {
        return [arr objectAtIndex: 0];
    }
    
    return nil;
}

//================================================================================================================================================================================================
-(NSArray*) getAllPMMessageComments
{
    NSString* strQuery;
    strQuery = [NSString stringWithFormat: @"select * from tbl_pm_message_comment"];
    return [m_sqlManager lookupAllForSQL: strQuery];
}

//Message File.
//================================================================================================================================================================================================
-(void) insertPMMessageFile: (NSString*) fileid
                   filename: (NSString*) filename
                    fileurl: (NSString*) fileurl
{
    NSString* strQuery;
    strQuery = [NSString stringWithFormat: @"select * from tbl_pm_message_file where fileid = '%@'", fileid];
    NSArray* arrCommentFiles = [m_sqlManager lookupAllForSQL: strQuery];
    
    //Insert.
    if(arrCommentFiles == nil || [arrCommentFiles count] <= 0)
    {
        NSMutableString* strSQL = [[NSMutableString alloc] init];
        [strSQL appendFormat: @"insert into '%@'('fileid', 'filename', 'fileurl') values(", @"tbl_pm_message_file"];
        [strSQL appendFormat: @"'%@',", fileid];
        [strSQL appendFormat: @"'%@',", filename];
        [strSQL appendFormat: @"'%@')", fileurl];
        
        [m_sqlManager runDynamicSQL: strSQL forTable: @"tbl_pm_message_file"];
    }
    else
    {
        //update
        NSString* strQuery = [NSString stringWithFormat: @"update tbl_pm_message_file set filename='%@', fileurl='%@' where fileid = '%@'", filename, fileurl, fileid];
        [m_sqlManager lookupAllForSQL: strQuery];
    }
}

//================================================================================================================================================================================================
-(NSDictionary*) getPMMessageFile: (NSString*) fileid
{
    NSString* strQuery;
    strQuery = [NSString stringWithFormat: @"select * from tbl_pm_message_file where fileid = '%@'", fileid];
    NSArray* arr = [m_sqlManager lookupAllForSQL: strQuery];
    if(arr != nil && [arr count] > 0)
    {
        return [arr objectAtIndex: 0];
    }
    
    return nil;
}

//================================================================================================================================================================================================
-(NSArray*) getAllPMMessageFiles
{
    NSString* strQuery;
    strQuery = [NSString stringWithFormat: @"select * from tbl_pm_message_file"];
    return [m_sqlManager lookupAllForSQL: strQuery];
    
}

#pragma mark -
#pragma mark PM Added Task

//================================================================================================================================================================================================
-(void) insertPMAddedTask: (NSString*) AdminId
                     Date: (NSString*) Date
                       Id: (NSString*) Id
               PriorityId: (NSString*) PriorityId
                   ProjId: (NSString*) ProjId
                TodoTitle: (NSString*) TodoTitle
                   UserId: (NSString*) UserId
           assignedtoname: (NSString*) assignedtoname
               sprintname: (NSString*) sprintname
                     type: (NSString*) type
{
    NSMutableString* strSQL = [[NSMutableString alloc] init];
    [strSQL appendFormat: @"insert into '%@'('AdminId', 'Date', 'Id', 'PriorityId', 'ProjId', 'TodoTitle', 'UserId', 'assignedtoname', 'sprintname', 'type') values(", @"tbl_pm_tasksadded"];
    [strSQL appendFormat: @"'%@',", AdminId];
    [strSQL appendFormat: @"'%@',", Date];
    [strSQL appendFormat: @"'%@',", Id];
    [strSQL appendFormat: @"'%@',", PriorityId];
    [strSQL appendFormat: @"'%@',", ProjId];
    [strSQL appendFormat: @"'%@',", TodoTitle];
    [strSQL appendFormat: @"'%@',", UserId];
    [strSQL appendFormat: @"'%@',", assignedtoname];
    [strSQL appendFormat: @"'%@',", sprintname];       
    [strSQL appendFormat: @"'%@')", type];
    
    [m_sqlManager runDynamicSQL: strSQL forTable: @"tbl_pm_tasksadded"];
}

//================================================================================================================================================================================================
-(NSArray*) getAllPMAddedTasks: (int) nType
{
    NSString* strQuery;
    strQuery = [NSString stringWithFormat: @"select * from tbl_pm_tasksadded where type = '%d'", nType];
    return [m_sqlManager lookupAllForSQL: strQuery];
}

//================================================================================================================================================================================================
-(void) deleteAllPMAddedTasks
{
    NSString* strQuery = [NSString stringWithFormat: @"delete from tbl_pm_tasksadded"];
    [m_sqlManager lookupAllForSQL: strQuery];
}

//================================================================================================================================================================================================
@end
