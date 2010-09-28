//
//  iCalculatorViewController.m
//  iCalculator
//
//  Created by Daniel on 10-9-8.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "iCalculatorViewController.h"

@implementation iCalculatorViewController
@synthesize btnOne,btnThree,btnFive,txtResult;



/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/
- (void)viewDidLoad {
    [super viewDidLoad];
	numberCount = 0;//已输入的操作数的个数
	isDotDown = NO;//小数点的判断
	isCal = NO;//是否经过一次有效的等号计算
	isPreOper = NO;//前一次输入是否为操作fu
	flag = NO;
	afterDotNumber = 0;//小数点后数字的位数
	num1 = 0;//操作数1
	num2 = 0;//操作数2
	isOverFlow=NO;
	isExp = NO;//是否发生操作数超过范围异常
	currentOperatorType=operatorNoType;//当前操作fu类型
	currentNumber = 0;//当前操作数
	txtResult.text = @"0";	
	
}
- (void) inition{
	numberCount = 0;
	isDotDown = NO;
	isCal = NO;
	isOverFlow=NO;
	isPreOper = NO;
	afterDotNumber = 0;
	num1 = 0;
	num2 = 0;
	currentOperatorType = operatorNoType;
	txtResult.text = @"0";
	currentNumber = 0;
}	
/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */
- (NSString *)changeFloat:(double)Right 
{	
	NSString *stringFloat;
	stringFloat = [NSString stringWithFormat:@"%.10f",Right];
	const char *floatChars = [stringFloat UTF8String];
    NSUInteger length = [stringFloat length];
	int i;
    for( i = length-1; i>=0; i--)
    {
        if(floatChars[i] == '0') 
			;
		else
		{
            if(floatChars[i] == '.')
                i--;
            break;
        }
    }
    NSString *returnString;
    if(i == -1) 
        returnString = @"0";
	else
        returnString = [stringFloat substringToIndex:i+1];
    return returnString;	
}
-(IBAction) numberPress:(id)sender
{	
	int number = [sender tag];
	if(numberCount == 0||numberCount == 1)
	{
		if([txtResult.text length]>=9 && !isExp)
		{
			return;
		}
		isExp = NO;
		isPreOper = NO;
		numberCount = 1;
		if(isCal)
		{
			[self inition];
			if(flag)
			{
				txtResult.text = @"0.";
				isDotDown = YES;
				flag = NO;
			}			
		}
		
		if(!isDotDown)
		{
			num1 = num1 * 10 +  number;
			txtResult.text = [self changeFloat: num1];
		}
		else{
			
			afterDotNumber ++;
			if(number == 0)
				txtResult.text = [NSString stringWithFormat:@"%@%@",txtResult.text,@"0"];
			else
			{
				num1 = num1 + pow(0.1,afterDotNumber) * number;
				txtResult.text=[NSString stringWithFormat:@"%@%d",txtResult.text,number];
				
			}
		} 
		currentNumber = num1;		
	}
	else if(numberCount == 2) 
	{
		if([txtResult.text length] >= 9)
		{
			if(!isPreOper)
				return;
		}
		
		isPreOper = NO;
		if(!isDotDown)
		{
			
			num2 = num2 * 10 + number;
			txtResult.text = [self changeFloat: num2];
		}
		else 
		{
			afterDotNumber++;
			
			if(number == 0)
				txtResult.text = [NSString stringWithFormat:@"%@%@",txtResult.text,@"0"];
			else
			{
				
				num2 = num2 + pow(0.1,afterDotNumber) * number;
				
				txtResult.text=[NSString stringWithFormat:@"%@%d",txtResult.text,number];
			}
		}
		currentNumber = num2;
	}
	currentafterNumber=afterDotNumber;
}
-(void)showMessage:(NSString *) msg//利用提示框显示提示信息
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
													message:msg
												   delegate:self 
										  cancelButtonTitle:@"OK" 
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
}
- (IBAction) dotPress:(id)sender
{
	
	if(isCal)
		flag = YES;
	if(!isDotDown && !isCal && !isPreOper)
	{
		txtResult.text = [NSString stringWithFormat:@"%@%@",txtResult.text,@"."];
		isDotDown = YES;
	}
	else if(!isDotDown&&(isCal || isPreOper))
	{
		num2 = 0;
		txtResult.text = @"0.";
		isDotDown = YES;
	}
}
- (void) equResult
{
	switch(currentOperatorType)
	{
		case operatorTypePlus:
			num1 = num1 + num2;
			break;
		case operatorTypeMinus:
			num1 = num1 - num2;
			break;
		case operatorTypeMul:
			num1 = num1 * num2;
			break;
		case operatorTypeDiv:
			if(num2 == 0)
			{
				txtResult.text = @"Error";
				[self showMessage:@"the divided number can't be Zero"];
				return;
			}
			num1 = num1 / num2;
			break;			
	}
	currentNumber = num1;
	isOverFlow=NO;
	if([[self changeFloat:num1] length] >= 15)
	{
		txtResult.text = [NSString stringWithFormat:@"%e",num1];
		isExp = YES;
	}
	else if([[self changeFloat: num1] isEqualToString:@"-0"])
		txtResult.text = @"0";
	else
		txtResult.text = [self changeFloat: num1];
}

- (IBAction) equPress:(id)sender
{
	if(numberCount == 1 && isPreOper)
	{
		NSString *temp = txtResult.text;
		[self inition];
		txtResult.text = temp;
	}
	else if(numberCount >= 1&&!isPreOper)
	{
		[self equResult];
		if([[self changeFloat: num1] length] >=9)
			isExp=YES;
		isCal = YES;
		isPreOper = NO;
		numberCount = 1;
		isDotDown = NO;
		afterDotNumber = 0;
	}
	else if(numberCount == 2 && isPreOper)
	{
		
		num2 = isDotDown ? 0 : num1;
		[self equResult];
		isCal = YES;
		isPreOper = NO;
		numberCount = 1;
		isDotDown = NO;
		afterDotNumber = 0;
	}	
}
- (IBAction) operPress:(id)sender
{	
	if(numberCount == 2&&!isPreOper)
	{ 
		isPreOper = YES;
		[self equResult];
	}
	currentOperatorType = [sender tag];
	numberCount = 2 ;
	isPreOper = YES;
	isDotDown = NO;
	isOverFlow=NO;
	isCal = NO;
	num2 = 0;
	afterDotNumber = 0;	
}
- (IBAction) clearPress:(id)sender{
	if([sender tag] == 0)
	{
		//后退操作
		if(numberCount == 1)
		{
			if(isCal)
			{
				[self inition];
				return;
			}		
			if(isDotDown&&afterDotNumber > 0)
			{
				NSString *desiredNumber = [txtResult.text substringWithRange:NSMakeRange(0,[txtResult.text length]-1)];
				afterDotNumber--;
				txtResult.text = desiredNumber;
				num1 = [desiredNumber floatValue];
				NSLog(@"num1: %f",num1);
			}
			else {
				num1 = (int)(num1 / 10);
				isDotDown = NO;
				txtResult.text = [self changeFloat: num1];			
			}					
		}			
		else if(numberCount == 2)
		{
			if(isDotDown&&afterDotNumber > 0)
			{
				NSString *desiredNumber = [txtResult.text substringWithRange:NSMakeRange(0,[txtResult.text length]-1)];
				afterDotNumber--;
				txtResult.text = desiredNumber;
				num2 = [desiredNumber floatValue];
				NSLog(@"num2: %f",num2);
			}
			else {
				num2 = (int)(num2/10);
				isDotDown = NO;
				txtResult.text = [self changeFloat: num2];				
			}						
		}
	}
	else//完全清零(初始化)
	{
		[self inition];		
	}
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end
