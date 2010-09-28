//
//  iCalculatorViewController.h
//  iCalculator
//
//  Created by Daniel on 10-9-8.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum
{
	operatorTypePlus=0,
	operatorTypeMinus=1,
	operatorTypeMul=2,
	operatorTypeDiv=3,
	operatorNoType=4
} OperatorType;

@interface iCalculatorViewController : UIViewController {
	UIButton *btnOne;
	UIButton *btnThree;
	UIButton *btnFive;
	UIButton *btnPlus;
	UIButton *btnMul;
	UIButton *btnAdd;
	UIButton *btnEqu;
	UITextField *txtResult;
	BOOL isOper;
	BOOL isDotDown;
	BOOL isOverFlow;
	BOOL isCal;
	BOOL isPreOper;
	NSString *currentTxt;
	BOOL isExp;//是否出现一次计算的异常
	BOOL flag;//周转变量
	int currentafterNumber;
	int afterDotNumber;
	double num1;
	double num2;
	double currentNumber;
	int numberCount;
	OperatorType currentOperatorType;
	
	
}
@property(nonatomic,retain) IBOutlet UIButton *btnOne,*btnThree,*btnFive;
@property(nonatomic,retain) IBOutlet UITextField *txtResult;
- (IBAction) numberPress:(id)sender;
- (IBAction) operPress:(id)sender;
- (IBAction) dotPress:(id)sender;
- (IBAction) equPress:(id)sender;
- (IBAction) clearPress:(id)sender;
@end

