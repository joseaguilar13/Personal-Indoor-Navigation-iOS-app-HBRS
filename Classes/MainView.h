//
//  MainView.h
//  CoreLocationTest
//
//  Created by David HM Spector on 12/3/09.
//  Copyright Zeitgeist Information Systems 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface MainView : UIView {
	 IBOutlet UIView *extra;
	 IBOutlet UIScrollView *myscrollview;
     IBOutlet UIScrollView *myscrollviewNavigationSettings;
	 IBOutlet UIView *cadView;
	 IBOutlet UIView *chooseBuilding;
	 IBOutlet UIView *evaluation;
     IBOutlet UIView *dataView;
     IBOutlet UIView *RFIDSettingsView;
     IBOutlet UIView *NavigationSettingsView;
     IBOutlet UIView *InfoView;
	 /*float posArrMV1;
	 float posArrMV2;
	 float posArrMV3;
	 float posArrMV4;
	 float posArr2[2000];
	 int stepsMV;
	
	 int flag2;*/
	
}

/*-(void)setVal1:(float)val1 setVal2:(float)val2 setVal3:(float)val3 setVal4:(float)val4 setVal5:(int)val5;*/


-(IBAction)goto;
-(IBAction)goto2;
-(IBAction)goto3;
-(IBAction)goto4;
-(IBAction)goto5;
-(IBAction)goto6;
-(IBAction)hideDataView;
-(IBAction)showDataView;
-(IBAction)hideRFIDSettingsView;
-(IBAction)showRFIDSettingsView;
-(IBAction)showNavigationSettingsView;
-(IBAction)hideNavigationSettingsView;
-(IBAction)showInfoView;
-(IBAction)hideInfoView;
-(IBAction)hideChooseBuildingView;
-(IBAction)hideEvaluationView;
@end


