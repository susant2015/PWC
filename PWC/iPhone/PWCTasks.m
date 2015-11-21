//
//  PWCTasks.m
//  PWC
//
//  Created by Samiul Hoque on 6/28/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCTasks.h"
#import "PWCGlobal.h"

@implementation PWCTasks

@synthesize tasks = _tasks;

static PWCTasks *_getTasks;

+ (PWCTasks*)getTasks
{
    @synchronized([PWCTasks class])
    {
        if (_getTasks == nil) {
            _getTasks = [[PWCTasks alloc] init];
        }
        return _getTasks;
    }
    return nil;
}

+(id)alloc
{
    @synchronized([PWCTasks class])
    {
        NSAssert(_getTasks == nil, @"Attempted to allocate a second instance of a singleton.");
        _getTasks = [super alloc];
        return _getTasks;
    }
    return nil;
}

- (id)init
{
    if ((self = [super init])) {
        
        NSMutableArray *mutArray = [[NSMutableArray alloc] init];

        NSDictionary *a = [[NSDictionary alloc] initWithObjectsAndKeys:@"Follow Up Phone Call", @"taskname",
                            @"Alauddin H", @"assignedto",
                            @"System", @"assignedby",
                            @"2013-06-21 12:14:17 -0500", @"assignedon",
                            @"2013-06-24 12:14:17 -0500", @"duedate",
                            @"Anjuman Y", @"customer",
                            @"Task Remind Notification Test", @"reason",
                            @"Change Status", @"status",
                            @"", @"comment",
                            nil];
        [mutArray addObject:a];

        a = [[NSDictionary alloc] initWithObjectsAndKeys:@"Check What Remaining", @"taskname",
             @"Alauddin H", @"assignedto",
             @"System", @"assignedby",
             @"2013-06-25 12:14:17 -0500", @"assignedon",
             @"2013-06-28 12:14:17 -0500", @"duedate",
             @"Anjuman Y", @"customer",
             @"Task Remind Notification Test", @"reason",
             @"Change Status", @"status",
             @"", @"comment",
             nil];
        [mutArray addObject:a];
        
        a = [[NSDictionary alloc] initWithObjectsAndKeys:@"Sample Task 123", @"taskname",
             @"Alauddin H", @"assignedto",
             @"System", @"assignedby",
             @"2013-06-25 12:14:17 -0500", @"assignedon",
             @"2013-06-29 12:14:17 -0500", @"duedate",
             @"Anjuman Y", @"customer",
             @"Task Remind Notification Test", @"reason",
             @"Change Status", @"status",
             @"", @"comment",
             nil];
        [mutArray addObject:a];
        
        a = [[NSDictionary alloc] initWithObjectsAndKeys:@"Another Task", @"taskname",
             @"Alauddin H", @"assignedto",
             @"System", @"assignedby",
             @"2013-06-25 12:14:17 -0500", @"assignedon",
             @"2013-06-30 12:14:17 -0500", @"duedate",
             @"Anjuman Y", @"customer",
             @"Task Remind Notification Test", @"reason",
             @"Change Status", @"status",
             @"", @"comment",
             nil];
        [mutArray addObject:a];
        
        a = [[NSDictionary alloc] initWithObjectsAndKeys:@"New Task", @"taskname",
             @"Alauddin H", @"assignedto",
             @"System", @"assignedby",
             @"2013-06-25 12:14:17 -0500", @"assignedon",
             @"2013-07-01 12:14:17 -0500", @"duedate",
             @"Anjuman Y", @"customer",
             @"Task Remind Notification Test", @"reason",
             @"Change Status", @"status",
             @"", @"comment",
             nil];
        [mutArray addObject:a];
        
        a = [[NSDictionary alloc] initWithObjectsAndKeys:@"111 Task", @"taskname",
             @"Alauddin H", @"assignedto",
             @"System", @"assignedby",
             @"2013-06-25 12:14:17 -0500", @"assignedon",
             @"2013-07-02 12:14:17 -0500", @"duedate",
             @"Anjuman Y", @"customer",
             @"Task Remind Notification Test", @"reason",
             @"Change Status", @"status",
             @"", @"comment",
             nil];
        [mutArray addObject:a];
        
        a = [[NSDictionary alloc] initWithObjectsAndKeys:@"Schedule a Task", @"taskname",
             @"Alauddin H", @"assignedto",
             @"System", @"assignedby",
             @"2013-06-25 12:14:17 -0500", @"assignedon",
             @"2013-07-03 12:14:17 -0500", @"duedate",
             @"Anjuman Y", @"customer",
             @"Task Remind Notification Test", @"reason",
             @"Change Status", @"status",
             @"", @"comment",
             nil];
        [mutArray addObject:a];
        
        a = [[NSDictionary alloc] initWithObjectsAndKeys:@"A Task to Do", @"taskname",
             @"Alauddin H", @"assignedto",
             @"System", @"assignedby",
             @"2013-06-25 12:14:17 -0500", @"assignedon",
             @"2013-06-28 12:14:17 -0500", @"duedate",
             @"Anjuman Y", @"customer",
             @"Task Remind Notification Test", @"reason",
             @"Change Status", @"status",
             @"", @"comment",
             nil];
        [mutArray addObject:a];
        
        a = [[NSDictionary alloc] initWithObjectsAndKeys:@"One more task to do", @"taskname",
             @"Alauddin H", @"assignedto",
             @"System", @"assignedby",
             @"2013-06-25 12:14:17 -0500", @"assignedon",
             @"2013-06-30 12:14:17 -0500", @"duedate",
             @"Anjuman Y", @"customer",
             @"Task Remind Notification Test", @"reason",
             @"Change Status", @"status",
             @"", @"comment",
             nil];
        [mutArray addObject:a];
        
        a = [[NSDictionary alloc] initWithObjectsAndKeys:@"Garbage Collection", @"taskname",
             @"Alauddin H", @"assignedto",
             @"System", @"assignedby",
             @"2013-06-25 12:14:17 -0500", @"assignedon",
             @"2013-07-01 12:14:17 -0500", @"duedate",
             @"Anjuman Y", @"customer",
             @"Task Remind Notification Test", @"reason",
             @"Change Status", @"status",
             @"", @"comment",
             nil];
        [mutArray addObject:a];
        
        a = [[NSDictionary alloc] initWithObjectsAndKeys:@"Deallocating the object", @"taskname",
             @"Alauddin H", @"assignedto",
             @"System", @"assignedby",
             @"2013-06-25 12:14:17 -0500", @"assignedon",
             @"2013-07-01 12:14:17 -0500", @"duedate",
             @"Anjuman Y", @"customer",
             @"Task Remind Notification Test", @"reason",
             @"Change Status", @"status",
             @"", @"comment",
             nil];
        [mutArray addObject:a];
        
        a = [[NSDictionary alloc] initWithObjectsAndKeys:@"Syncronizing the objects", @"taskname",
             @"Alauddin H", @"assignedto",
             @"System", @"assignedby",
             @"2013-06-25 12:14:17 -0500", @"assignedon",
             @"2013-07-01 12:14:17 -0500", @"duedate",
             @"Anjuman Y", @"customer",
             @"Task Remind Notification Test", @"reason",
             @"Change Status", @"status",
             @"", @"comment",
             nil];
        [mutArray addObject:a];
        
        self.tasks = [NSArray arrayWithArray:mutArray];
    }
    
    return self;
}

- (void)dealloc
{
    
}

- (NSArray *)allTasks
{
    return self.tasks;
}

@end
