//
//  DataManager.h
//

//
//  Created by JianJinHu on 11/7/12.
//
//

#import <Foundation/Foundation.h>
#import "SQLDatabase.h"

@interface DataManager : NSObject
{
    SQLDatabase*	m_sqlManager;
}

+ (DataManager*) sharedScoreManager;
+ (void) releaseScoreManager;

- (id) init;


//Email Profiles.
-(int) insertEmailProfile:(NSString *)profile_id
             profile_name:(NSString *)profile_name
        profile_from_name:(NSString *)profile_from_name
           reply_to_email:(NSString *)reply_to_email;

-(NSArray*) getAllEmailProfiles;
-(void) deleteAllEmailProfiles;

//Email Content
-(int) insertEmailContent:(NSString *)content_id
                  subject:(NSString *)subject
             library_name:(NSString*)library_name
                signature:(NSString *)signature
                   cat_id:(NSString*) cat_id
                 category:(NSString*) category;

-(NSArray*) getAllEmailContents;
-(void) deleteAllEmailContents;

//SMS Contents.
-(int) insertSMSContent:(NSString *)content_id
                subject:(NSString *)subject
              signature:(NSString *)signature
                 cat_id:(NSString*) cat_id
               category:(NSString*) category;


-(NSArray*) getAllSMSContents;
-(void) deleteAllSMSContents;

//Task.
-(int) insertTaskList: (int) list_count task_list_name: (NSString*) task_list_name;
-(NSArray*) getTaskList;
-(void) deleteTaskList;

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
         funnel_id: (int) funnel_id;

-(NSArray*) getTaskWithListID: (int) listID funnelID: (int) nFunnelID assigned_to_id: (int) assigned_to_id;
-(void) deleteAllTasks;

//Funnels.
-(void) insertFunnel: (int) funnel_id
   funnel_is_default: (NSString*) funnel_is_default
         funnel_name: (NSString*) funnel_name
       SalespathList: (NSString*) SalespathList;

-(NSArray*) getAllFunnels;
-(NSArray*) getFunnelWithID: (int) funnel_id;
-(void) deleteAllFunnels;

//SalesPath.
-(void) insertSalesPath: (int) salesPath_slider_id
              isDefault: (int) isDefault
         salesPath_name: (NSString*) salesPath_name;

-(NSArray*) getAllSalesPath;
-(NSArray*) getSalesPathWithID: (int) salesPath_slider_id;
-(void) deleteSalesPath;


//RoleList
-(void) insertRoleUser: (int) admin_id
                 email: (NSString*) email
             firstname: (NSString*) firstname
        is_def_primary: (NSString*) is_def_primary
        is_def_support: (NSString*) is_def_support
           is_def_tech: (NSString*) is_def_tech
              lastname: (NSString*) lastname;

-(NSArray*) getAllRoleUsers;
-(NSArray*) getRoleUser: (int) admin_id;
-(void) deleteAllRoleUsers;

//Category
-(void) insertCategory: (int) tag_category_id
         category_name: (NSString*) category_name
         category_type: (int) category_type
                  tags: (NSString*) tags;
-(NSArray*) getAllCategory;
-(NSArray*) getCategoryWithID: (int) tag_category_id;
-(void) deleteAllCategoy;

//Tags.
-(void) insertTag: (int) tag_id
         tag_name: (NSString*) tag_name;
-(NSArray*) getAllTags;
-(NSArray*) getTagWithID: (int) tag_id;
-(void) deleteAllTag;

//Assigned User
-(void) insertAssignedUser: (int) admin_id
              coach_row_id: (int) coach_row_id
                     email: (NSString*) email
                 firstname: (NSString*) firstname
                  lastname: (NSString*) lastname;

-(NSArray*) getAllAssignedUser;
-(NSArray*) getAssignedUserByID: (int) admin_id;
-(void) deleteAllAssignedUser;

//Lead Role
-(void) insertLeadRole: (int) admin_id
                 email: (NSString*) email
             firstname: (NSString*) firstname
        is_def_primary: (int) is_def_primary
        is_def_support: (int) is_def_support
           is_def_tech: (int) is_def_tech
              lastname: (NSString*) lastname
             role_type: (int) role_type;

-(NSArray*) getAllLeadRole;
-(NSArray*) getLeadRoleByID: (int) admin_id;
-(NSArray*) getLeadRoleByType: (int) role_type;
-(void) deleteAllLeadRole;

//Product Category.
-(void) insertProductCategory: (NSString*) name
                        value: (NSString*) value;

-(NSArray*) getAllProductCategory;
-(void) deleteAllProductCategory;

//Task2
-(void) insertTask2: (int) task_id
          task_name: (NSString*) task_name
          task_type: (int) task_type;
-(NSArray*) getAllTask2;
-(void) deleteAllTask2;


//Project List
-(void) insertProjectList: (NSString*) Id
                 ProjName: (NSString*) ProjName;

-(NSArray*) getAllProjectLists;
-(void) deleteAllProjectLists;

//Task Title.
-(void) insertPMTaskTitle: (NSString*) tasktitleid
                tasktitle: (NSString*) tasktitle
                taskcount: (NSString*) taskcount
               project_id: (NSString*) project_id;

-(NSArray*) getPMTaskTitlesByProjectID: (NSString*) project_id;
-(NSArray*) getAllPMTaskTitles;
-(void) deleteAllPMTaskTitles;
-(void) deleteAllPMTaskTitleByProjectID: (NSString*) project_id;

//Task List.
-(void) insertPMTaskList: (NSString*) assignedto
                priority: (NSString*) priority
              sprintname: (NSString*) sprintname
               tasktitle: (NSString*) tasktitle
                 taskurl: (NSString*) taskurl
              project_id: (NSString*) project_id
                title_id: (NSString*) title_id
                  todoid: (NSString*) todoid;

-(NSArray*) getPMTaskListsByProjectID: (NSString*) project_id title_id: (NSString*) title_id;
-(NSArray*) getAllPMTaskLists;
-(void) deleteAllPMTaskLists;
-(void) deleteAllPMTaskListsByProjectID: (NSString*) project_id title_id: (NSString*) title_id;

//Pending Quene(BroadCast)
-(void) insertBroadcast: (int) broadcast_id
                   type: (NSString*) type
         broadcast_date: (NSString*) broadcast_date
      broadcast_subject: (NSString*) broadcast_subject;
-(NSArray*) getAllBroadcasts;
-(void) deleteAllBroadcasts;

//Project Manager Task Detail.
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
             taskemaillist: (NSString*) taskemaillist;

-(NSArray*) getPMTaskDetails: (NSString*) Id ProjId: (NSString*) ProjId;
-(void) deletePMTaskDetails: (NSString*) Id ProjId: (NSString*) ProjId;


//Project Manager Task Detail Comment.
-(void) insertPMTaskDetailComment: (NSString*) comment_adminid
              comment_description: (NSString*) comment_description
                     comment_date: (NSString*) comment_date
                       comment_id: (NSString*) comment_id
                 comment_peopleid: (NSString*) comment_peopleid
                 comment_submitby: (NSString*) comment_submitby
                    Comment_files: (NSString*) Comment_files;

-(NSArray*) getPMTaskDetailComment: (NSString*) comment_id;
-(NSArray*) getAllPMTaskDetailComments;


//Project Management Task User List.
-(void) insertPMTaskUserList: (NSString*) tc_comapnyid
              tc_companyname: (NSString*) tc_companyname
                 tc_ismaster: (NSString*) tc_ismaster
                     tc_type: (NSString*) tc_type
                      people: (NSString*) people
                  project_id: (NSString*) project_id;
-(NSArray*) getAllPMTaskUserListByProjectID: (NSString*) project_id;
-(NSDictionary*) getPMTaskUserListById: (NSString*) tc_comapnyid project_id: (NSString*) project_id;
-(void) deleteAllPMTaskUserList;


//Project Management Task People.
-(void) insertPMTaskPeople: (NSString*) tc_companyname
                     tc_id: (NSString*) tc_id
               tc_ismaster: (NSString*) tc_ismaster
                   tc_type: (NSString*) tc_type
              tp_firstname: (NSString*) tp_firstname
                     tp_id: (NSString*) tp_id
               tp_lastname: (NSString*) tp_lastname
                  selected: (NSString*) selected;

-(NSArray*) getAllPMTaskPeople;
-(NSArray*) getPMTaskPeopleByID: (NSString*) tp_id;
-(NSDictionary*) getPMTaskPeopleByTPID: (NSString*) tp_id;
-(void) deleteAllPMTaskUserListByProjectID: (NSString*) project_id;

//Project Management Task Progress.
-(void) insertPMTaskProgress: (NSString*) PathId
                   ProjectId: (NSString*) ProjectId
                progress_bar: (NSString*) progress_bar
               approve_title: (NSString*) approve_title
                        date: (NSString*) date
                      status: (NSString*) status
                status_title: (NSString*) status_title
             unapprove_title: (NSString*) unapprove_title;

-(NSArray*) getPMTaskProgressByPathId: (NSString*) PathId;
-(void) deletePMTaskProgress: (NSString*) PathId;

//Project Management Progress Bar.
-(void) insertPMProgressBar: (NSString*) Id
              progress_date: (NSString*) progress_date
            progress_status: (NSString*) progress_status
             progress_title: (NSString*) progress_title
                      title: (NSString*) title;

-(NSArray*) getPMProgressBarById: (NSString*) Id;
-(NSArray*) getPMAllProgressBar;
-(void) deletePMProgressBar: (NSString*) Id;

//Project Management Sprint.
-(void) insertPMSprite: (NSString*) sprint_id
           sprint_name: (NSString*) sprint_name
        current_sprint: (NSString*) current_sprint
            project_id: (NSString*) project_id
                todoid: (NSString*) todoid;
-(NSArray*) getPMAllSprintByProjectID: (NSString*) project_id todoid: (NSString*) todoid;
-(NSDictionary*) getPMSprintByID: (NSString*) sprint_id;
-(NSString*) getPMSprintNameByID: (NSString*) sprint_id;
-(void) deletePMSprintByID: (NSString*) sprint_id;
-(void) deletePMAllSprintByProjectID: (NSString*) project_id todoid: (NSString*) todoid;

//Project Management Comment Files.

-(void) insertPMTaskCommentFiles: (NSString*) fileid fileurl: (NSString*) fileurl filname: (NSString*) filname uploadeddate: (NSString*) uploadeddate;
-(NSDictionary*) getPMTaskCommentFile: (NSString*) fileid;

//Project Management Message List.
-(void) insertPMMessageList: (NSString*) Id
                       Date: (NSString*) Date
                MessageType: (NSString*) MessageType
                   PostedBy: (NSString*) PostedBy
                    Subject: (NSString*) Subject
                 project_id: (NSString*) project_id;
-(NSArray*) getPMMessageListByProjectID: (NSString*) project_id;
-(void) deleteAllPMMessageListByProjectID: (NSString*) project_id;

//Message Detail.
-(void) insertPMMessageDetail: (NSString*) messageID
             messageProjectId: (NSString*) messageProjectId
               messageSubject: (NSString*) messageSubject
                     postedBy: (NSString*) postedBy
                     postedTo: (NSString*) postedTo
                  messageBody: (NSString*) messageBody
               messageComment: (NSString*) messageComment
                  messageFile: (NSString*) messageFile;
-(NSDictionary*) getPMMessageDetail: (NSString*) messageID;

//Message Comment.
-(void) insertPMMessageComment: (NSString*) msg_comment_id
          msg_comment_peopleid: (NSString*) msg_comment_peopleid
          msg_comment_submitby: (NSString*) msg_comment_submitby
           msg_comment_adminid: (NSString*) msg_comment_adminid
              msg_comment_date: (NSString*) msg_comment_date
           msg_comment_details: (NSString*) msg_comment_details
             msg_comment_files: (NSString*) msg_comment_files;
-(NSDictionary*) getPMMessageComment: (NSString*) msg_comment_id;
-(NSArray*) getAllPMMessageComments;

//Message File.
-(void) insertPMMessageFile: (NSString*) fileid
                   filename: (NSString*) filename
                    fileurl: (NSString*) fileurl;
-(NSDictionary*) getPMMessageFile: (NSString*) fileid;
-(NSArray*) getAllPMMessageFiles;

-(void) insertPMAddedTask: (NSString*) AdminId
                     Date: (NSString*) Date
                       Id: (NSString*) Id
               PriorityId: (NSString*) PriorityId
                   ProjId: (NSString*) ProjId
                TodoTitle: (NSString*) TodoTitle
                   UserId: (NSString*) UserId
           assignedtoname: (NSString*) assignedtoname
               sprintname: (NSString*) sprintname
                     type: (NSString*) type;

-(NSArray*) getAllPMAddedTasks: (int) nType;
-(void) deleteAllPMAddedTasks;
@end
