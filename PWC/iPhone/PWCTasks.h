//
//  PWCTasks.h
//  PWC
//
//  Created by Samiul Hoque on 6/28/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PWCTasks : NSObject {
    NSArray *_tasks;
}

@property (strong, nonatomic) NSArray *tasks;

+ (PWCTasks*)getTasks;
- (NSArray *)allTasks;

@end
