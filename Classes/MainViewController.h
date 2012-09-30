//
//  MainViewController.h
//  CoreLocationTest
//
//  Created by David HM Spector on 12/3/09.
//  Copyright Zeitgeist Information Systems 2009. All rights reserved.
//

#import "FlipsideViewController.h"
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>
#import <MapKit/MKReverseGeocoder.h>
#import <CoreLocation/CoreLocation.h>
#import "Reachability.h"                // Apple's "reachability code"
#import <QuartzCore/QuartzCore.h>
#import "TCPClient.h"
#import "TCPServer.h"
#import <CoreMotion/CoreMotion.h>

#define kOne32ndCompassDivision 11.25
#define PixXMeter 7.9166

#define offsetImagePixelsX 1855
#define offsetImagePixelsY 1208

@class MainView;
@class cadViewClass;

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, MKReverseGeocoderDelegate, MKMapViewDelegate, UIAccelerometerDelegate, CLLocationManagerDelegate> {
  
  IBOutlet UISwitch *FUSEDSwitch;
  IBOutlet UISwitch *RFIDSwitch;
  IBOutlet UISwitch *PDRSwitch;
  IBOutlet UISwitch *PrevPosSwitch;
  IBOutlet UISegmentedControl *seg;
  IBOutlet UISegmentedControl *seg2;
  IBOutlet UISegmentedControl *seg3;
  IBOutlet UISegmentedControl *segFiltering;
	
  IBOutlet UITextField *mTextView;
  IBOutlet UITextField *mTextViewSettings;
  IBOutlet UITextField *mTextSend;
  TCP *tcp;
	
  UIImageView *imageView;
  IBOutlet UIScrollView *scroll;
	
  IBOutlet MainView *m_mainView;	
  IBOutlet cadViewClass *m_cadView;
  IBOutlet UITextField *heightTextField;
  IBOutlet UITextField *genderTextField;
  IBOutlet UITextField *RFIDTextField;
  
  IBOutlet UILabel    *stepsLabel;
  IBOutlet UILabel    *posLabel;
  IBOutlet UILabel    *stepsLabel2;
  IBOutlet UILabel    *posLabel2;
  IBOutlet UILabel *accuracyLabel;
  IBOutlet UILabel *accAngleLabel;
  
 
    
    
  IBOutlet UIImageView *initialPosition;
  IBOutlet UIImageView *RFIDinitialPosition;
  IBOutlet UIImageView *fusedinitialPosition;
  IBOutlet UIImageView *secondPosition;
  IBOutlet UIImageView *tPosition;
  IBOutlet UIImageView *fPosition;
  IBOutlet UIImageView *fiPosition;
  IBOutlet UIImageView *sePosition;
  IBOutlet UIImageView *sPosition;
  IBOutlet UIImageView *ePosition;
  IBOutlet UIImageView *nPosition;
  IBOutlet UIImageView *tePosition;
  IBOutlet UIImageView *elPosition;
    /*IBOutlet UIImageView *i12Position;
	IBOutlet UIImageView *i13Position;
	IBOutlet UIImageView *i14Position;
	IBOutlet UIImageView *i15Position;
	IBOutlet UIImageView *i16Position;
	IBOutlet UIImageView *i17Position;
	IBOutlet UIImageView *i18Position;
	IBOutlet UIImageView *i19Position;
	IBOutlet UIImageView *i20Position;
	IBOutlet UIImageView *i21Position;
	IBOutlet UIImageView *i22Position;
	IBOutlet UIImageView *i23Position;
	IBOutlet UIImageView *i24Position;
	IBOutlet UIImageView *i25Position;
	IBOutlet UIImageView *i26Position;
	IBOutlet UIImageView *i27Position;
	IBOutlet UIImageView *i28Position;
	IBOutlet UIImageView *i29Position;
	IBOutlet UIImageView *i30Position;
	/*IBOutlet UIImageView *i31Position;
	IBOutlet UIImageView *i32Position;
	IBOutlet UIImageView *i33Position;
	IBOutlet UIImageView *i34Position;
	IBOutlet UIImageView *i35Position;
	IBOutlet UIImageView *i36Position;
	IBOutlet UIImageView *i37Position;
	IBOutlet UIImageView *i38Position;
	IBOutlet UIImageView *i39Position;
	IBOutlet UIImageView *i40Position;
	IBOutlet UIImageView *i41Position;
	IBOutlet UIImageView *i42Position;
	IBOutlet UIImageView *i43Position;
	IBOutlet UIImageView *i44Position;
	IBOutlet UIImageView *i45Position;
	IBOutlet UIImageView *i46Position;
	IBOutlet UIImageView *i47Position;
	IBOutlet UIImageView *i48Position;
	IBOutlet UIImageView *i49Position;
	IBOutlet UIImageView *i50Position;
	IBOutlet UIImageView *i51Position;
    */
	

  IBOutlet UILabel *initialPositionLabel;
  IBOutlet UILabel *secondPositionLabel;
  IBOutlet UILabel *RFIDinitialPositionLabel;
  IBOutlet UILabel *RFIDsecondPositionLabel;
  IBOutlet UILabel *fusedinitialPositionLabel;
  IBOutlet UILabel *fusedsecondPositionLabel;
  IBOutlet UILabel *testLabel;
  IBOutlet UILabel *tagLabel;
  IBOutlet UILabel *floorLabel;
  IBOutlet UILabel *gyroLabel;
 
	
  // the MapKit parts	
  IBOutlet UILabel    *currentLocation;
  IBOutlet UILabel    *currentElevation;
  IBOutlet UILabel    *currentHeading;
  IBOutlet UILabel    *currentHeading2;	
  IBOutlet UILabel    *currentHeadingCorrected;
  IBOutlet UILabel    *currentSpeed;
  IBOutlet UISwitch   *coreLocationSwitch;
  IBOutlet UILabel    *lastUpdateTime;
  IBOutlet UILabel    *whichNetwork;
  IBOutlet UILabel    *mapStatusText;
  IBOutlet UIButton   *showInfo;
  IBOutlet MKMapView  *mapView;
  IBOutlet MKMapView  *mapView2;
  
  // The Accelerometers Parts
  IBOutlet  UILabel   *xLabel;
  IBOutlet  UILabel   *yLabel;
  IBOutlet  UILabel   *zLabel;
  IBOutlet  UIProgressView  *xBar;
  IBOutlet  UIProgressView  *yBar;
  IBOutlet  UIProgressView  *zBar;
    
  NetworkStatus remoteHostStatus;
	NetworkStatus internetConnectionStatus;
	NetworkStatus localWiFiConnectionStatus;
  
  
  MKPlacemark         *mPlacemark;
  MKPlacemark         *mPlacemark2;
  MKReverseGeocoder   *geoCoder;
  MKReverseGeocoder   *geoCoder2;
  UIAccelerometer     *accelerometer;
  CLLocationManager   *locationManager;
  NSDateFormatter     *dateFormatter;
  UIAccelerationValue accelerationValues[3];
  UIAccelerationValue accelerationValuesPrev[3];
  int currentTag;
  int prevTag;
  int  steps;
  int centerScrollIndex;
  int flag;
  int flag10;
  int flag11;
  int flag12;
  int forcedHeading;
  int RFIDReader;
  int headingDevice;
  int filteringMethod;
  int floorNumber;
  float headingCorrected;
  float pos;
  float posPDRTOFUSED;
  float headingGlobal;
  float stride;
  float x;
  float y;
  float fusedx;
  float fusedy;
  float xx;
  float yy;
  float RFIDxx;
  float RFIDyy;
  float fusedxx;
  float fusedyy;
  float xStart;
  float yStart;
  float kGender;
  float accAngle;
  float accAngleX;
  float accAngleAntX;
  float accAngleY;
  float accAngleAntY;
  float degImage;
  float ratioZoomX;
  float ratioZoomY;
  float gyroHeadingGlobal;
  float zeroMagneticHeading;
  float zeroGyroHeading;

	
  BOOL loc_service_active;
  BOOL rotateMap;
  BOOL rotateMap2;
  BOOL mapFollowsUser;
  BOOL PDR;
  BOOL RFID;
  BOOL FUSED;
  int initialBOOL;
  int RFIDBOOL;
  int fusedBOOL;
  int prevPosBOOL;
  float prevFrameX;
  float prevFrameY;
  CGRect initialPositionRect;
  CGRect RFIDinitialPositionRect;
  CGRect fusedinitialPositionRect;
  CGRect m_cadViewRect;
  CGRect imageViewRect;	
	
  CMMotionManager *motionManager;

  CMAttitude *referenceAttitude;

  CMDeviceMotion *deviceMotion;		
  
  CMAttitude *attitude;

}

/* 
@property (nonatomic, retain) UILabel *currentLocation;
@property (nonatomic, retain) UILabel *currentElevation;
 @property (nonatomic, retain) UILabel *currentHeading;
 @property (nonatomic, retain) UILabel *currentSpeed;
 @property (nonatomic, retain) UILabel *lastUpdateTime;
@property (nonatomic, retain) UISwitch *coreLocationSwitch;
@property (nonatomic, retain) MKMapView *mapView;
@property (nonatomic, retain) MKPlacemark *mPlacemark;
@property (nonatomic, retain) MKReverseGeocoder *geoCoder;
*/

@property (retain, nonatomic) UITextField *heightTextField;
@property (retain, nonatomic) UITextField *genderTextField;

- (IBAction)toggleCoreLocation;
- (IBAction)showUserLocation;
- (IBAction)showUserLocation2;
- (IBAction)toggleMapType;
- (IBAction)toggleMapType2;
- (IBAction)showInfo;
- (IBAction)toggleMapRotation;
- (IBAction)toggleMapFollowsUser;
- (IBAction)toggleMapRotation2;
- (IBAction)resetDist;
- (IBAction)resetDist2;
- (IBAction)showImPos;
- (IBAction)centerImage;
- (IBAction)centerImage2;
- (IBAction)setStart;
-(IBAction) asClientClicked:(id)sender;
-(IBAction) asServerClicked:(id)sender;
-(IBAction) sendClicked:(id)sender;
-(IBAction) actionSeg;
-(IBAction) actionSeg2;
-(IBAction) actionSeg3;
-(IBAction) actionSegFiltering;
-(IBAction) actionSwitch1;
-(IBAction) actionSwitch2;
-(IBAction) actionSwitch3;
-(IBAction) setUpMapAttitude;
-(IBAction) setUpMapAttitude;
-(IBAction) hideKeyboardHeightTextField;



@property (retain, nonatomic) MainView *m_mainView;
@property (retain, nonatomic) MainView *m_cadView;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UIScrollView *scroll;
@property (retain) TCP *tcp;

@end
