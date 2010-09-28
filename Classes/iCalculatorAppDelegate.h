//
//  iCalculatorAppDelegate.h
//  iCalculator
//
//  Created by Daniel on 10-9-8.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class iCalculatorViewController;

@interface iCalculatorAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    iCalculatorViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet iCalculatorViewController *viewController;

@end

