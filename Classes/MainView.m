//
//  MainView.m
//  CoreLocationTest
//
//  Created by David HM Spector on 12/3/09.
//  Copyright Zeitgeist Information Systems 2009. All rights reserved.
//

#import "MainView.h"

@implementation MainView



/*
-(void)setVal1:(float)val1 setVal2:(float)val2 setVal3:(float)val3 setVal4:(float)val4 setVal5:(int)val5 {
	self-> posArrMV1 = val1;
	self-> posArrMV2 = val2;
	self-> posArrMV3 = val3;
	self-> posArrMV4 = val4;
	self-> stepsMV = val5;

}*/


-(IBAction)goto{
	myscrollview.contentSize = CGSizeMake(320, 1000);
	[self addSubview:myscrollview];
}

-(IBAction)goto2{

	[myscrollview removeFromSuperview];
}

-(IBAction)goto3{
	[self addSubview:cadView];
}

-(IBAction)goto4{
	[cadView removeFromSuperview];
    [dataView removeFromSuperview];
	
}

-(IBAction)goto5{
	[self addSubview:chooseBuilding];
}

-(IBAction)goto6{
	[self addSubview:evaluation];
}

-(IBAction)hideDataView{
    [dataView removeFromSuperview];  
 
}

-(IBAction)showDataView{
        
    [self addSubview:dataView];
 
}

-(IBAction)hideRFIDSettingsView{
    [RFIDSettingsView removeFromSuperview]; 

}
-(IBAction)showRFIDSettingsView{
     [self addSubview:RFIDSettingsView];

}


-(IBAction)showNavigationSettingsView{
 [self addSubview:NavigationSettingsView];
 [self addSubview:myscrollviewNavigationSettings];
    
 [NavigationSettingsView removeFromSuperview];
 [myscrollviewNavigationSettings removeFromSuperview];
    
 [self addSubview:NavigationSettingsView];
 [self addSubview:myscrollviewNavigationSettings];
    
}

-(IBAction)hideNavigationSettingsView{
     [NavigationSettingsView removeFromSuperview];
     [myscrollviewNavigationSettings removeFromSuperview];

}


-(IBAction)showInfoView{
    [self addSubview:InfoView];
}


-(IBAction)hideInfoView{
[InfoView removeFromSuperview];
    
}

-(IBAction)hideChooseBuildingView{
[chooseBuilding removeFromSuperview];
    
}

-(IBAction)hideEvaluationView{
[evaluation removeFromSuperview];
}


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code

	
	}
    return self;
}


/*-(void)drawRect:(CGRect)rect {
    // Drawing code
	
	
	
	float x1 = self -> posArrMV1;
	float y1 = self -> posArrMV2;
	float x2= self -> posArrMV3;
	float y2= self -> posArrMV4;
	
	int stepsMVL = self -> stepsMV;
	
	posArr2[0] = x1;
	posArr2[1] = y1;

	
	
	
	 CGContextRef	context = UIGraphicsGetCurrentContext();
	
	
	 
	 CGContextSetLineWidth(context, 2.0);
		
	
	//CGContextSetRGBStrokeColor(context, 0.0, 1.0, 0.0, 1.0);
	CGContextSetRGBFillColor(context, 1.0, 0.0, 0.0, 1.0);
		
	/*CGContextMoveToPoint(context, x1, y1); //Start
	CGContextAddLineToPoint(context, x2, y2); // InitialPosition.center
	CGContextStrokePath(context);
	*/
	
	
	/*if(stepsMVL == 0 ){
	
		for (int i = 0; i<=2000; i++) {
			posArr2[i]=0;
		
		}
	}
	
	
	if(stepsMVL % 3 == 0){
		
		
	
		posArr2[2*stepsMVL/3] = x2;
		posArr2[2*stepsMVL/3+1] = y2;
	

		
		for (int i=0; i <= (2*stepsMVL/3 +1); i++) {
		
			int temp3 = i * 2;
			int temp4 = i * 2 + 1;
			
			float temp1 = posArr2[temp3];
			float temp2 = posArr2[temp4];
			
		
			
			CGContextAddRect(context, CGRectMake(temp1, temp2, 4.0, 4.0)); 
			CGContextFillPath(context);
			
			//CGContextMoveToPoint(context, temp1, temp2); //Start
			 //CGContextAddLineToPoint(context, temp1, temp2); // InitialPosition.center 
			 //CGContextAddLineToPoint(context, temp5, temp6); // InitialPosition.center
			 //CGContextStrokePath(context);
	}		
	
		 
		
		
		CGContextStrokePath(context);

		
	}	
	
	
}*/



- (void)dealloc {
    [super dealloc];
}


@end
