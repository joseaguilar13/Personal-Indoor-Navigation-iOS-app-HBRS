//
//  cadViewClass.h
//  SensorToy
//
//  Created by Jose Carmen Aguilar Herrera on 18/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

//
//  MainView.h
//  CoreLocationTest
//
//  Created by David HM Spector on 12/3/09.
//  Copyright Zeitgeist Information Systems 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "MainView.h"
#import <QuartzCore/QuartzCore.h>

@interface cadViewClass : MainView {
	/*BOutlet UIView *extra;
	IBOutlet UIScrollView *myscrollview;
	IBOutlet UIView *cadView; */
	float posArrMV1;
	float posArrMV2;
	float posArrMV3;
	float posArrMV4;
	float posRFIDArrMV3;
	float posRFIDArrMV4;
	float posFusedArrMV3;
	float posFusedArrMV4;
	float angleMV;
	float posArr2[2000];
	float posRFIDArr2[2000];
	float posFusedArr2[2000];
	float angleSent[2000];
	int stepsMV;
	int stepsMVLTotal;
	
	int flag2;
	int initialBOOL;
	int RFIDBOOL;
	int fusedBOOL;
	UIImageView *PDRIV;
	
}

-(IBAction)resetStepsMVLTotal;
-(void)setVal1:(float)val1 setVal2:(float)val2 setVal3:(float)val3 setVal4:(float)val4 setVal5:(float)val5 setVal6:(float)val6 setVal7:(float)val7 setVal8:(float)val8 setVal9:(int)val9 setVal10:(int)val10 setVal11:(int)val11 setVal12:(int)val12 setVal13:(float)val13;




@end
