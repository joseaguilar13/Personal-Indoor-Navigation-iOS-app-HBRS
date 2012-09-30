//
//  MainViewController.m
//  CoreLocationTest
//
//  Created by David HM Spector on 12/3/09.
//  Copyright Zeitgeist Information Systems 2009. All rights reserved.
//

#import "MainViewController.h"
#import "MainView.h"
#import "cadViewClass.h"
#import "vector.h"
#import <Math.h>




@implementation MainViewController
//@synthesize currentLocation, currentElevation, currentHeading, coreLocationSwitch, mapView, mPlacemark, geoCoder;
@synthesize m_mainView;
@synthesize m_cadView;

@synthesize heightTextField, genderTextField;
@synthesize imageView;
@synthesize scroll;
@synthesize tcp;




//posArr[100]={0.0};

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    // Custom initialization
  }
  return self;
}


- (void)viewDidLoad 
{
  [super viewDidLoad];
	
	steps= 0;
	flag = 0;
	headingCorrected=0;
	pos=0;
    posPDRTOFUSED=0;
	stride = 0;
	x=-10;
	y=-10;
	fusedx=0;
	fusedy=0;
	flag10=0;
	flag11=1;
	flag12=1;
	xx=0;
	yy=0;
	RFIDxx=offsetImagePixelsX + 512;
	RFIDyy=offsetImagePixelsY + 393;
	fusedxx=offsetImagePixelsX + 512;
	fusedyy=offsetImagePixelsY + 393;
	forcedHeading=0;					  
	xStart=offsetImagePixelsX + 512;
	yStart=offsetImagePixelsY + 393;
	centerScrollIndex=1;
	zeroMagneticHeading = 0; 
	zeroGyroHeading = 180;
    filteringMethod = 0;
    
    accelerationValues[0]=0;
    accelerationValues[1]=0;
    accelerationValues[2]=0;
    accelerationValuesPrev[0]=0;
    accelerationValuesPrev[1]=0;
    accelerationValuesPrev[2]=0;
	
	
		
	 UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"Welcome to iPIN, this app will help you to navigate through the building C in FBRS, please initialize your personal data (height and gender) and choose between the three available methods for localization" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	 [alert show];
	 [alert release];
	
	//TIMER NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(myMethod) userInfo:nil repeats:YES];
	
	// Create our CMMotionManager instance
	if (motionManager == nil) {
		motionManager = [[CMMotionManager alloc] init];
	}
	
	// Turn on the appropriate type of data
	motionManager.accelerometerUpdateInterval = 0.01;
	motionManager.deviceMotionUpdateInterval = 0.01;
	
	
	//[motionManager startDeviceMotionUpdates];
	
    
    //[motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXArbitraryZVertical]; // Normal X arbitrary (x is no the projection of the magnetic north, and Z is always vertical to gravity
    [motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXArbitraryCorrectedZVertical]; // Normal X arbitrary (x is no the projection of the magnetic north, and Z is corrected with the magnetometer
    //[motionManager starDevceMotionUpdatesUsingReferenceFrame:[CMAttitudeReferenceFrameXTrueNorthZVertical];//True north in the earth, we need location manager to convert the magnetic north to true north, based on location and world magnetic model
    //[motionManager starDevceMotionUpdatesUsingReferenceFrame:[CMAttitudeReferenceFrameXMagneticNorthZVertical];//Earth magnetic north, x axis is the projection of the magnetic north and y is perpendicular to x
	
    
    //To notify when the compass is interfered 
    /*-(BOOL)locationManagerShouldDisplayHeadingCalibration : (CLLocationManager *)manager {
        
        //do stuff
        
        return YES;
    } */
    
    // To dismiss the overlay, remove the calibration view
    
    /*- (void)dismissHeadingCalibrationDisplay */
    
    
    //New in iOS 5
    motionManager.showsDeviceMovementDisplay = YES;
    
    //[motionManager starDevceMotionUpdatesUsingReferenceFrame:[CMAttitudeReferenceFrameXTrueNorthZVertical];
    
	referenceAttitude = nil;
	
	
	mTextSend.text =@"\r000101010000\r";
	
	flag10=0;
	ratioZoomX = 1;
	ratioZoomY = 1;
	
	kGender=0.415;
	RFIDReader=0;
	headingDevice = 0;
	currentTag=0;
	prevTag=0;
	degImage=0;
	
	initialBOOL=0;
	RFIDBOOL=0;
	fusedBOOL=0;
	
	//UIImage *image = [UIImage imageNamed:@"PlanoCV2.gif"];
    UIImage *image = [UIImage imageNamed:@"mapFBRS18dic2011-2.png"];
    
    
    
    
    //UIImage *image2 = [UIImage imageNamed:@"Fondo1.gif"];
	//UIImage *image = [UIImage imageNamed:@"Foto del día 28-05-2011 a la(s) 11:38.jpg"];
	
	
	floorNumber=3;
	
	imageView = [[UIImageView alloc] initWithImage:image];
  
	
    
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"MainMenuImage2.png"]];
    
    m_mainView.backgroundColor = background;
    
    [background release];
	
	if(floorNumber == 3){
		
		floorLabel.text=@"C-3";
	
	}else {
		
	}

	
	
	
	//[scroll addSubview:m_cadView];
	
 
	
	[scroll addSubview:imageView];
    //[scroll addSubview:m_cadView];
	
	//***[m_cadView addSubview:imageView];
    //[m_cadView addSubview:imageView];
	//***[m_cadView addSubview:initialPosition];
	//****[m_cadView addSubview:RFIDinitialPosition];
    //****[m_cadView addSubview:fusedinitialPosition];
	//[m_cadView setNeedsDisplay];
	
	
	//imageViewRect = imageView.frame;
    //imageViewRect = scroll.contentSize;
	imageViewRect.size.width  = 3746; //scroll.contentSize.width;
	imageViewRect.size.height = 3172; //scroll.contentSize.height;
	
	
	//prevFrameX = imageViewRect.x;
	//prevFrameY = imageViewRect.y;
	
	
	//[m_cadView addSubview:imageView];
	[imageView addSubview:m_cadView];
	[imageView addSubview:initialPosition];
	[imageView addSubview:RFIDinitialPosition];
	[imageView addSubview:fusedinitialPosition];
    //[m_cadView addSubview:imageView];
	//[m_cadView addSubview:initialPosition];
	//[m_cadView addSubview:RFIDinitialPosition];
    //[m_cadView addSubview:fusedinitialPosition];
	
	//[scroll addSubview:initialPosition];
	//[scroll addSubview:RFIDinitialPosition];
	//[scroll addSubview:fusedinitialPosition];
	
	
	[scroll setContentSize:[image size]];
    
	[scroll setMaximumZoomScale:1000.0];
    
    [scroll setMinimumZoomScale:0.01];
	
	
	//[initialPosition setCenter:CGPointMake(xStart, yStart)];
	//x=-10;
	//y=-10;
	
	/*for (int i=0; i<100; i++) {
		posArr[2*i] = 270.0;
		posArr[(2*i)+1] = 397.0;
	}*/
	
	/*posArr[0]= initialPosition.center.x;
	posArr[1]= initialPosition.center.y;
	posArr[2]= initialPosition.center.x;
	posArr[3]= initialPosition.center.y;
	posArr[4]= initialPosition.center.x;
	posArr[4]= initialPosition.center.y;
	posArr[6]= initialPosition.center.x;
	posArr[7]= initialPosition.center.y;
	posArr[8]= initialPosition.center.x;
	posArr[9]= initialPosition.center.y;*/
	
	
    if(PrevPosSwitch.on){
    
          [m_cadView setVal1:xStart - offsetImagePixelsX setVal2:yStart - offsetImagePixelsY setVal3:initialPosition.center.x - offsetImagePixelsX setVal4:initialPosition.center.y - offsetImagePixelsY setVal5:RFIDinitialPosition.center.x - offsetImagePixelsX setVal6:RFIDinitialPosition.center.y - offsetImagePixelsY setVal7:fusedinitialPosition.center.x - offsetImagePixelsX setVal8:fusedinitialPosition.center.y - offsetImagePixelsY setVal9:steps setVal10:initialBOOL setVal11:RFIDBOOL setVal12:fusedBOOL setVal13:degImage];
        
        [m_cadView setNeedsDisplay];
        
    }
	
  
	
	
  // First, determine what we can about network reacability  
  [[Reachability sharedReachability] setHostName:@"www.apple.com"];	
  remoteHostStatus          = [[Reachability sharedReachability] remoteHostStatus];
  internetConnectionStatus	= [[Reachability sharedReachability] internetConnectionStatus];
  localWiFiConnectionStatus	= [[Reachability sharedReachability] localWiFiConnectionStatus];
  switch (internetConnectionStatus) {
    case ReachableViaCarrierDataNetwork:
      whichNetwork.text = @"Cellular";
      break;
    case ReachableViaWiFiNetwork:
      whichNetwork.text = @"WiFi";
      break;
    case NotReachable:
    default:
      whichNetwork.text = @"None";
      break;
	
  }
  
  // The sensors
  accelerometer = [UIAccelerometer sharedAccelerometer];
	accelerometer.updateInterval = 0.1;
	accelerometer.delegate = self;	
  
  // Core Location
  locationManager = [[CLLocationManager alloc] init];
  locationManager.delegate = self;
  locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters; 
  locationManager.distanceFilter = kCLDistanceFilterNone;
  [locationManager startUpdatingLocation];
  loc_service_active = YES;
  
  if ([locationManager headingAvailable])
    [locationManager startUpdatingHeading];
  else 
    currentHeading.text = @"N/A";
  
  // The map
  mapView.delegate = self;
	mapView2.delegate = self;
  mapView.zoomEnabled = YES;
	mapView2.zoomEnabled = YES;
  mapView.scrollEnabled = YES;
	mapView2.scrollEnabled = YES;
	mapView.showsUserLocation = YES;
	mapView2.showsUserLocation = YES;
  mapView.mapType = MKMapTypeHybrid;
	mapView2.mapType = MKMapTypeHybrid;
  mapStatusText.text = @"Not following user";
  
  
  
  /*Region and Zoom */
  MKCoordinateRegion region;
  MKCoordinateSpan span;
  span.latitudeDelta = 0.2;
  span.longitudeDelta = 0.2;
  
  CLLocationCoordinate2D location = mapView.userLocation.coordinate;
  
  location.latitude =  50.73;
  location.longitude = 7.11;
  region.span = span;
  region.center = location;
  
  [mapView setRegion:region animated:YES];
	
  [mapView regionThatFits:region];

  
  /*Geocoder Stuff*/
  //  geoCoder=[[MKReverseGeocoder alloc] initWithCoordinate:location];
  //  geoCoder.delegate = self;
  //  [geoCoder start];
  
  
  dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
  [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];

	/*Region and Zoom */
	MKCoordinateRegion region2;
	MKCoordinateSpan span2;
	span2.latitudeDelta = 0.2;
	span2.longitudeDelta = 0.2;
	
	CLLocationCoordinate2D location2 = mapView2.userLocation.coordinate;
	
	location2.latitude =  50.73;
	location2.longitude = 7.11;
	region2.span = span2;
	region2.center = location2;
	

	[mapView2 setRegion:region2 animated: YES];

	[mapView2 regionThatFits:region2];
	
	/*Geocoder Stuff*/
	//  geoCoder=[[MKReverseGeocoder alloc] initWithCoordinate:location];
	//  geoCoder.delegate = self;
	//  [geoCoder start];
	
	
	dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	[dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
	
}


-(UIView *)viewForZoomingInScrollView:(UIScrollView*)scrollView{

	//ratioZoomX = (imageView.frame.size.width/imageViewRect.size.width);
	//ratioZoomY = (imageView.frame.size.height/imageViewRect.size.height);
	ratioZoomX = (scroll.contentSize.width/imageViewRect.size.width);
	ratioZoomY = (scroll.contentSize.height/imageViewRect.size.height);
	
	NSLog(@"Zoom ratio is: ", [NSString stringWithFormat:@"%.3f", ratioZoomX]);
    //mTextSend.text = [NSString stringWithFormat:@"%.3f", ratioZoom];
	//mTextSend.text = [NSString stringWithFormat:@"%.3f", scroll.contentSize.width];
	
	//mTextView.text = [NSString stringWithFormat:@"%.3f", initialPosition.center.x];
	
	//imageViewRect = imageView.frame;
	
/*
    float constantX = imageView.frame.size.width/imageViewRect.size.width;
	
	float constantY = imageView.frame.size.height/imageViewRect.size.height;
	
	float initialPositionNextX = initialPosition.frame.size.width*(constantX);
		
	float initialPositionNextY = initialPosition.frame.size.height*(constantY);
	
	float initialPositionCenterX= initialPosition.center.x * constantX;
	
	float initialPositionCenterY = initialPosition.center.y * constantY;
	
	
	float m_cadViewNextX = m_cadView.frame.size.width*(constantX);
	
	float m_cadViewNextY = m_cadView.frame.size.height*(constantY);

	//initialPosition.height=initialPosition.height*(imageView.height/prevFrameY);
	//float RFIDinitialPositionNext= RFIDinitialPosition.frame.size.width=RFIDinitialPosition.frame.size.width*(constantX);
	//RFIDinitialPosition.height=RFIDinitialPosition.height*(imageView.height/prevFrameY);
	//fusedinitialPosition.width=fusedinitialPosition.width*(imageView.width/prevFrameX);
	//fusedinitialPosition.height=fusedinitialPosition.height*(imageView.height/prevFrameY);
	//m_cadView.width=m_cadView.width*(imageView.width/prevFrameX);
	//m_cadView.height=m_cadView.height*(imageView.height/prevFrameY);
	
    CGRect initialPositionFrame =CGRectMake(initialPosition.frame.origin.x, initialPosition.frame.origin.y, initialPositionNextX, initialPositionNextY);
	initialPosition.frame = initialPositionFrame;
	
	CGRect m_cadViewFrame =CGRectMake(m_cadView.frame.origin.x, m_cadView.frame.origin.y, m_cadViewNextX, m_cadViewNextY);
	m_cadView.frame = m_cadViewFrame;
	
	[initialPosition setCenter:CGPointMake(initialPositionCenterX, initialPositionCenterY)];
	
	imageViewRect = imageView.frame;
	
	//prevFrameX = imageViewRect.width;
	//prevFrameY = imageViewRect.height;
	
	/*return m_cadView;
	return initialPosition;
	return RFIDinitialPosition;
	return fusedinitialPosition;*/
   
	return imageView;


}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {  
	[self dismissModalViewControllerAnimated:YES];
}


- (IBAction)showInfo {    
	
	FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
	controller.delegate = self;
	
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:controller animated:YES];
	
	[controller release];
}




- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
  // release all our UI bits 
	
	
  [motionManager stopAccelerometerUpdates];
  [motionManager stopDeviceMotionUpdates];
  [motionManager release];  
  motionManager = nil;
  [currentLocation release];
  [currentElevation release];
  [currentHeading release];
  [coreLocationSwitch release];
  [mapView release];
  [mapView2 release];
  
  [xLabel release];
  [yLabel release];
  [zLabel release];
  
  [xBar release];
  [yBar release];
  [zBar release];
	[heightTextField release];
	[genderTextField release];
	[posLabel release];
	[imageView release];
	[scroll release];
	
  
  // deactivate and release the sensors, map and geocoder
  accelerometer.delegate = nil;
  [accelerometer release];  
  
  mapView.delegate = nil;
  [mapView release];
	mapView2.delegate = nil;
	[mapView2 release];
  //  geoCoder.delegate = nil;
  //  [geoCoder release];
  
  locationManager.delegate = nil;
  [locationManager release];
  
  [dateFormatter release];
  
  //...and finally:
  [super dealloc];
}

#pragma mark MapKit Delegate Methods

// this causes the map to track the user... this *will* interfere with the 
// user's pinch/zoom control of the map.  You have been warned.
- (void) observeValueForKeyPath:(NSString *)keyPath
                       ofObject:(id)Oobject
                         change:(NSDictionary *)change
                        context:(void *)context
{
  mapView.centerCoordinate = mapView.userLocation.location.coordinate;
  mapView2.centerCoordinate = mapView2.userLocation.location.coordinate;
  
}



- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder 
       didFailWithError:(NSError *)error
{
  NSLog(@"Reverse Geocoder Errored");  
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark
{
  NSLog(@"Reverse Geocoder completed");
  mPlacemark = placemark;
  [mapView addAnnotation:placemark];
  [mapView2 addAnnotation:placemark];

}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation
{
  MKPinAnnotationView *annView=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"currentloc"];
  annView.animatesDrop = TRUE;
  return annView;
}


#pragma mark UIAccelerometer Delegate Methods

- (void)accelerometer:(UIAccelerometer *)meter didAccelerate:(UIAcceleration *)acceleration {
  
  
   // Use the accelerometer force vectors including the gravity 
  
    xLabel.text = [NSString stringWithFormat:@"%.5f", acceleration.x];
  xBar.progress = ABS(acceleration.x);
	
	accelerationValues[0]= acceleration.x;
  
  yLabel.text = [NSString stringWithFormat:@"%.5f", acceleration.y];
  yBar.progress = ABS(acceleration.y);
	accelerationValues[1]= acceleration.y;
  
  zLabel.text = [NSString stringWithFormat:@"%.5f", acceleration.z];
  zBar.progress = ABS(acceleration.z);
  accelerationValues[2]= acceleration.z;
    
    
    //Use the userAcceleration from CoreMotion, excluding the gravity vector, and just looking at the user or device acceleration applied
    /*
    deviceMotion = motionManager.deviceMotion;
    accelerationValues[0]=deviceMotion.userAcceleration.x;
    accelerationValues[1]=deviceMotion.userAcceleration.y;
    accelerationValues[2]=deviceMotion.userAcceleration.z;
    xLabel.text = [NSString stringWithFormat:@"%.5f", deviceMotion.userAcceleration.x];
    xBar.progress = ABS(deviceMotion.userAcceleration.x);
	
	accelerationValues[0]= deviceMotion.userAcceleration.x;
    
    yLabel.text = [NSString stringWithFormat:@"%.5f", deviceMotion.userAcceleration.y];
    yBar.progress = ABS(deviceMotion.userAcceleration.y);
	accelerationValues[1]= deviceMotion.userAcceleration.y;
    
    zLabel.text = [NSString stringWithFormat:@"%.5f", deviceMotion.userAcceleration.z];
    zBar.progress = ABS(deviceMotion.userAcceleration.z);
    accelerationValues[2]= deviceMotion.userAcceleration.z;*/ 
    
	
	accAngleX = accAngleAntX + 0.5 *(acceleration.x - accAngleAntX);
	accAngleY = accAngleAntY + 0.5 *(acceleration.y - accAngleAntY);
	
	accAngle = atan((accAngleX/accAngleY))* 180/M_PI;
	
	accAngleLabel.text = [NSString stringWithFormat:@"%.2f", accAngle];
	
	accAngleAntX = accAngleX;
	accAngleAntY = accAngleY;
    
   
	
	
	
}


#pragma mark ---- Location Manager Delegate Methods ----
- (void) locationManager:(CLLocationManager *)manager
     didUpdateToLocation:(CLLocation *)newLocation
            fromLocation:(CLLocation *)oldLocation 
{  
  NSLog(@"Location: %@", [newLocation description]);
  currentLocation.text  = [NSString stringWithFormat:@"%3.2f, %3.2f", newLocation.coordinate.latitude, newLocation.coordinate.longitude];
  currentElevation.text = [NSString stringWithFormat:@"%3.2f", newLocation.altitude];
  currentSpeed.text = newLocation.speed < 0 ?  @" - " : [NSString stringWithFormat:@"@%3.2f m/s", newLocation.speed];
  lastUpdateTime.text =  [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:newLocation.timestamp]];
	
	NSString *acc= [[NSString alloc] initWithFormat:@"%g",
					newLocation.horizontalAccuracy];
	accuracyLabel.text = acc;
	
}


- (void)locationManager:(CLLocationManager *)manager 
       didFailWithError:(NSError *)error
{
  NSLog(@"Error: %@", [error description]);
}


-(BOOL)locationManagerShouldDisplayHeadingCalibration : (CLLocationManager *)manager {
    
    //do stuff
    
    return YES;
}

- (void)locationManager:(CLLocationManager *)manager 
       didUpdateHeading:(CLHeading *)newHeading
{
  
	
	if (!FUSEDSwitch.on) {
		fusedBOOL=0;
		
		/*UIImage *imageF = [UIImage imageNamed:@""];  // this was an attempt to change the image displayed in the imageView (fusedinitialPosition)
	
		fusedinitialPosition = [[UIImageView alloc] initWithImage:imageF];*/
		
	}
	
	if(!PDRSwitch.on){
		initialBOOL=0;

	}
	
	if(!RFIDSwitch.on){
		RFIDBOOL=0;
	}else{
		
	}	
	
	if (FUSEDSwitch.on) {
		fusedBOOL=1;

	}
	
	if(PDRSwitch.on){
		initialBOOL=1;
	
	}
	
	if(RFIDSwitch.on){
		RFIDBOOL=1;
	}else{
		
	}	
	
	
  float heading = [newHeading trueHeading];
  
	
    //vec3f_t gyroCorrection = {0.0f, 0.0f, headingGlobal};
    
    //referenceAttitude = referenceAttitude - gyroCorrection;
    
    //referenceAttitude = {0.0f, 0.0f, headingGlobal};
    
    
	deviceMotion = motionManager.deviceMotion;		
	attitude = deviceMotion.attitude;
    // userAcceleration = deviceMotion.userAcceleration;
	
	// If we have a reference attitude, multiply attitude by its inverse
	// After this call, attitude will contain the rotation from referenceAttitude
	// to the current orientation instead of from the fixed reference frame to the
	// current orientation
	if (referenceAttitude != nil) {
		[attitude multiplyByInverseOfAttitude:referenceAttitude];
	}
	
	
	
	float gyroHeading = attitude.yaw*(180/M_PI) ; 
	
	
	gyroHeading = gyroHeading - 180 ;
	
	gyroHeadingGlobal = -gyroHeading;
	
	
	gyroLabel.text = [NSString stringWithFormat:@"%.2f", gyroHeadingGlobal];
	
		
	//float heading = newHeading.magneticHeading;
	
	
	
	NSString *ordinalPoint = nil;
	
	float headingCorrectedLocal = 0;
	
	
	//Correct magnetometer heading by using the accelerometer values
	if (newHeading != nil) {
		float Ax = accelerationValues[0];
		float Ay = accelerationValues[1];
		float Az = accelerationValues[2];
		float filterFactor = 0.2;
		float Mx = [newHeading x] * filterFactor + (Mx * (1.0 - filterFactor));
		float My = [newHeading y] * filterFactor + (My * (1.0 - filterFactor));
		float Mz = [newHeading z] * filterFactor + (Mz * (1.0 - filterFactor));
		
		float counter = (  -pow(Ax, 2)*Mz + Ax*Az*Mx - pow(Ay, 2)*Mz + Ay*Az*My );
		//float counter = (-(Ax * Mx * Az) - ((pow(Az, 2)* Mz)) - (Ay*Az*My));

		float denominator = ( sqrt( pow((My*Az-Mz*Ay), 2) + pow((Mz*Ax-Mx*Az), 2) + pow((Mx*Ay-My*Ax), 2) ) * sqrt(pow(Ay, 2)+pow(-Ax, 2)) );
		//float denominator = ( sqrt( pow((Ax*Mx), 2) + pow((Ay * My), 2) + pow((Az * Mz), 2) ) * sqrt(pow(Az, 2) ));
		
		headingCorrectedLocal = (acos(counter/denominator)* (180.0 /M_PI)) * filterFactor + (headingCorrectedLocal * (1.0 - filterFactor));
		
		headingCorrected = headingCorrectedLocal; 
  
	}
		
  // we're going to use/show the 16 common cardinal and intercadinal compass points; the idea is we 
  // split the difference between intercardinal points.  For example between north and east is northeast.  
  // Between North and NorthEast and NorthEast and East are two more divisions, NorthNorthEast and EastNorthEast.
  // North -> East = 90 deg; North -> NorthEast and NorthEast -> East = 45deg, North -> NorthNorthEast -- 22.5deg.  
  //
  // In order to have a smooth transition between the intercardinal points, you need to plit the distance yet again, 
  // making an 11.25 degree split.  In essesnce you are declaring north to be 11.5 deg to the left or right of true north; 
  // ditto to the other 3 cardinal points;  To be able to get all of the 16 common compass points to display you need to 
  // do the same for each of N, NNE, NE, ENE, E ESE, SE SSE, S, SSW, SW, WSW W, WNW, NW NNW.
  
  //N.B.: North is a special case since the way we're normalizing it, it lies left of 359.99deg as well as < 11.25deg
  
	
	//heading = heading + 15.0;	
	if (heading > 337.5 + kOne32ndCompassDivision && heading < 359.99 || heading > 0.00 && heading < kOne32ndCompassDivision){   
		ordinalPoint = @"(N)"; headingGlobal=0; //forcedHeading=1;
	}else if (heading > kOne32ndCompassDivision && heading < (22.5 - kOne32ndCompassDivision)){
		ordinalPoint = @"(NNE)"; headingGlobal=0; //forcedHeading=1;
	}else if (heading > (22.5 - kOne32ndCompassDivision) && heading < (45 + kOne32ndCompassDivision)){
		ordinalPoint = @"(NE)"; headingGlobal=0; //forcedHeading=1;
}else if (heading > (45.0 - kOne32ndCompassDivision) && heading < (67.5 + kOne32ndCompassDivision)){
    ordinalPoint = @"(ENE)"; headingGlobal=90; //forcedHeading=2;  
  
}else if (heading > (90.0 - kOne32ndCompassDivision) && heading < (90.0 + kOne32ndCompassDivision)){
    ordinalPoint = @"(E)"; headingGlobal=90; //forcedHeading=3;
}else if (heading > (112.5 - kOne32ndCompassDivision) && heading < (112.5 + kOne32ndCompassDivision)){
    ordinalPoint = @"(ESE)"; headingGlobal=90; //forcedHeading=3;
}else if (heading > (135.0 - kOne32ndCompassDivision) && heading < (135.0 + kOne32ndCompassDivision)){
    ordinalPoint = @"(SSE)"; headingGlobal=90; //forcedHeading=3;
}else if (heading > (157.5 - kOne32ndCompassDivision) && heading < (157.5 + kOne32ndCompassDivision)){
    ordinalPoint = @"(SSE)"; headingGlobal=180; //forcedHeading=4;
  
}else if (heading > (180.0 - kOne32ndCompassDivision) && heading < (180.0 + kOne32ndCompassDivision)){
    ordinalPoint = @"(S)"; headingGlobal=180; //forcedHeading=5;
}else if (heading > (202.6 - kOne32ndCompassDivision) && heading < (202.5 + kOne32ndCompassDivision)){
    ordinalPoint = @"(SSW)"; headingGlobal=180; //forcedHeading=5;
}else if (heading > (202.5 - kOne32ndCompassDivision) && heading < (225.0 + kOne32ndCompassDivision)){
    ordinalPoint = @"(SE)"; headingGlobal=180; //forcedHeading=5;
}else if (heading > (202.5 - kOne32ndCompassDivision) && heading < (247.7 + kOne32ndCompassDivision)){
    ordinalPoint = @"(WSW)"; headingGlobal=270; //forcedHeading=6;
  
}else if (heading > (270.0 - kOne32ndCompassDivision) && heading < (270.0 + kOne32ndCompassDivision)){
    ordinalPoint = @"(W)"; headingGlobal=270; //forcedHeading=7;
}else if (heading > (292/5 - kOne32ndCompassDivision) && heading < (292.5 + kOne32ndCompassDivision)){
    ordinalPoint = @"(NWN)"; headingGlobal=270; //forcedHeading=7;
}else if (heading > (315.0 - kOne32ndCompassDivision) && heading < (315.0 + kOne32ndCompassDivision)){
    ordinalPoint = @"(NW)";  headingGlobal=270; //forcedHeading=7;
}else if (heading > (337.5 - kOne32ndCompassDivision) && heading < (337.5 + kOne32ndCompassDivision)){
    ordinalPoint = @"(NNW)"; headingGlobal=0; //forcedHeading=8; 
}
  
	headingGlobal = heading;
	

	if(headingDevice == 0){
	
		float compGyro1 = zeroGyroHeading + 22.5;
		float compGyro2 = zeroGyroHeading + 67.5;
		float compGyro3 = zeroGyroHeading + 112.5;
		float compGyro4 = zeroGyroHeading + 157.5;
		float compGyro5 = zeroGyroHeading + 202.5;
		float compGyro6 = zeroGyroHeading + 247.5;
		float compGyro7 = zeroGyroHeading + 292.5;
		float compGyro8 = zeroGyroHeading + 337.5;
		
		if (compGyro1 >= 360) {
			compGyro1 = compGyro1 - 360;
		}
		
		if (compGyro2 > 360) {
			compGyro2 = compGyro2 - 360;
		}
		
		if (compGyro3 > 360) {
			compGyro3 = compGyro3 - 360;
		}
		
		if (compGyro4 > 360) {
			compGyro4 = compGyro4 - 360;
		}
		
		if (compGyro5 >= 360) {
			compGyro5 = compGyro5 - 360;
		}
		
		if (compGyro6 > 360) {
			compGyro6 = compGyro6 - 360;
		}
		
		if (compGyro7 > 360) {
			compGyro7 = compGyro7 - 360;
		}
		
		if (compGyro8 > 360) {
			compGyro8 = compGyro8 - 360;
		}
		
		
		/*if (compGyro1 >= 720) {
			compGyro1 = compGyro1 - 720;
		}
		
		if (compGyro2 > 720) {
			compGyro2 = compGyro2 - 720;
		}
		
		if (compGyro3 > 720) {
			compGyro3 = compGyro3 - 720;
		}
		
		if (compGyro4 > 720) {
			compGyro4 = compGyro4 - 720;
		}
		
		if (compGyro5 >= 720) {
			compGyro5 = compGyro5 - 720;
		}
		
		if (compGyro6 > 720) {
			compGyro6 = compGyro6 - 720;
		}
		
		if (compGyro7 > 720) {
			compGyro7 = compGyro7 - 720;
		}
		
		if (compGyro8 > 720) {
			compGyro8 = compGyro8 - 720;
		}
		
		*/
		
		
    if ((gyroHeadingGlobal >= compGyro8 && gyroHeadingGlobal <= zeroGyroHeading) || (gyroHeadingGlobal >= zeroGyroHeading && gyroHeadingGlobal <= compGyro1)){
	forcedHeading=1;
    }else if (gyroHeadingGlobal > compGyro1 && gyroHeadingGlobal < compGyro2){
	forcedHeading=2;
	
    }else if (gyroHeadingGlobal >= compGyro2 && gyroHeadingGlobal <= compGyro3){
	forcedHeading=3;
    }else if (gyroHeadingGlobal > compGyro3 && gyroHeadingGlobal < compGyro4){
	forcedHeading=4;
	}else if ((gyroHeadingGlobal >= compGyro4 && gyroHeadingGlobal <= 360) || (gyroHeadingGlobal >= 0 && gyroHeadingGlobal <= compGyro5)){   
		forcedHeading=5;
	}else if (gyroHeadingGlobal > compGyro5 && gyroHeadingGlobal < compGyro6){
		forcedHeading=6;
	}else if (gyroHeadingGlobal >= compGyro6 && gyroHeadingGlobal <= compGyro7){
		forcedHeading=7;
	}else if (gyroHeadingGlobal > compGyro7 && gyroHeadingGlobal < compGyro8){
		forcedHeading=8;
	
	}else {
		//forcedHeading=forcedHeading;
	}
		
	}
	
	
	if(headingDevice == 1){
		
		float compMag1 = zeroMagneticHeading + 22.5;
		float compMag2 = zeroMagneticHeading + 67.5;
		float compMag3 = zeroMagneticHeading + 112.5;
		float compMag4 = zeroMagneticHeading + 157.5;
		float compMag5 = zeroMagneticHeading + 202.5;
		float compMag6 = zeroMagneticHeading + 247.5;
		float compMag7 = zeroMagneticHeading + 292.5;
		float compMag8 = zeroMagneticHeading + 337.5;
		
		if (compMag1 > 360) {
			compMag1 = compMag1 - 360;
		}
		
		if (compMag2 > 360) {
			compMag2 = compMag2 - 360;
		}
		
		if (compMag3 > 360) {
			compMag3 = compMag3 - 360;
		}
		
		if (compMag4 > 360) {
			compMag4 = compMag4 - 360;
		}
		
		if (compMag5 > 360) {
			compMag5 = compMag5 - 360;
		}
		
		if (compMag6 > 360) {
			compMag6 = compMag6 - 360;
		}
		
		if (compMag7 > 360) {
			compMag7 = compMag7 - 360;
		}
		
		if (compMag8 > 360) {
			compMag8 = compMag8 - 360;
		}
		
		
		
	if ((heading >= 337.5 && heading <= zeroMagneticHeading) || (heading >= zeroMagneticHeading && heading <= compMag1)){
		forcedHeading=1;
    }else if (heading > compMag1 && heading < compMag2){
		forcedHeading=2;
    }else if (heading >= compMag2 && heading <= compMag3){
		forcedHeading=3;
    }else if (heading > compMag3 && heading < compMag4){
		forcedHeading=4;
	}else if (heading >= compMag4 && heading <= compMag5){   
		forcedHeading=5;
	}else if (heading > compMag5 && heading < compMag6){
		forcedHeading=6;
	}else if (heading >= compMag6 && heading <= compMag7){
		forcedHeading=7;
	}else if (heading > compMag7 && heading < compMag8){
		forcedHeading=8;
		
	}else {
		//forcedHeading=forcedHeading;
	}
	}
	
	
	if(headingDevice == 2){
		
		float compMag1 = zeroMagneticHeading + 22.5;
		float compMag2 = zeroMagneticHeading + 67.5;
		float compMag3 = zeroMagneticHeading + 112.5;
		float compMag4 = zeroMagneticHeading + 157.5;
		float compMag5 = zeroMagneticHeading + 202.5;
		float compMag6 = zeroMagneticHeading + 247.5;
		float compMag7 = zeroMagneticHeading + 292.5;
		float compMag8 = zeroMagneticHeading + 337.5;
		
		if (compMag1 > 360) {
			compMag1 = compMag1 - 360;
		}
		
		if (compMag2 > 360) {
			compMag2 = compMag2 - 360;
		}
		
		if (compMag3 > 360) {
			compMag3 = compMag3 - 360;
		}
		
		if (compMag4 > 360) {
			compMag4 = compMag4 - 360;
		}
		
		if (compMag5 > 360) {
			compMag5 = compMag5 - 360;
		}
		
		if (compMag6 > 360) {
			compMag6 = compMag6 - 360;
		}
		
		if (compMag7 > 360) {
			compMag7 = compMag7 - 360;
		}
		
		if (compMag8 > 360) {
			compMag8 = compMag8 - 360;
		}
		
		
		/*
		// A negative value means that the reported heading is invalid, which can occur when the device
		// is uncalibrated or there is strong interference from local magnetic fields. If newHeading.headingAccuracy < 0, then the
		 variance ("covariance matrix") for the compass is large (100 º), else it is small (30 º)
		if(newHeading.headingAccuracy < 0)
			return;
		
		// A negative value indicates that the heading could not be determined.
		if(newHeading.trueHeading < 0)
			return;
		 */
		
		
		if ((heading >= 337.5 && heading <= zeroMagneticHeading) || (heading >= zeroMagneticHeading && heading <= compMag1)){
			forcedHeading=1;
		}else if (heading > compMag1 && heading < compMag2){
			forcedHeading=2;
		}else if (heading >= compMag2 && heading <= compMag3){
			forcedHeading=3;
		}else if (heading > compMag3 && heading < compMag4){
			forcedHeading=4;
		}else if (heading >= compMag4 && heading <= compMag5){   
			forcedHeading=5;
		}else if (heading > compMag5 && heading < compMag6){
			forcedHeading=6;
		}else if (heading >= compMag6 && heading <= compMag7){
			forcedHeading=7;
		}else if (heading > compMag7 && heading < compMag8){
			forcedHeading=8;
			
		}else {
			//forcedHeading=forcedHeading;
		}
	}
	
	
  //  NSLog(@"Heading: %f", [newHeading magneticHeading]);
  
  currentHeading.text = heading < 0 ?  @" - " : [NSString stringWithFormat:@"%3.1fº %@", heading, ordinalPoint];
  currentHeading2.text = heading < 0 ?  @" - " : [NSString stringWithFormat:@"%3.1fº %@", heading, ordinalPoint];
	
  currentHeadingCorrected.text = headingCorrectedLocal < 0 ?  @" - " : [NSString stringWithFormat:@"%3.1fº %@", headingCorrectedLocal
																	, ordinalPoint];
	
	if(forcedHeading == 1){
		
		degImage=0;
	
		
	}else if (forcedHeading == 2) {
		degImage=45;
	
		
	}else if (forcedHeading == 3) {
		degImage=90;
		
		
	}else if (forcedHeading == 4) {
		degImage=135;
		
		
	}else if (forcedHeading == 5) {
		degImage=180;
		
		
	}else if (forcedHeading == 6) {
		degImage=225;
	
	}else if (forcedHeading == 7) {
		degImage=270;
		
		
	}else if (forcedHeading == 8) {
		degImage=315;
		
		
	}else{
		degImage=degImage; 
	}
	
	
	
	headingGlobal = heading;
	
	
	NSString *heightString=@"1.70";
	NSString *genderString=@"male";
	
	
	
	/*if((accelerationValues[2] > -0.9) && ((accelerationValues[1]>0.1) || ((accelerationValues[1]< -0.1))) && 
	   ((accelerationValues[0]>0.1) || ((accelerationValues[0]< -0.1)))) {*/
	
	//accelerationValues[2] = deviceMotion.userAcceleration.z;
    
    /* float dot = (px * xx) + (py * yy) + (pz * zz);
     float a = ABS(sqrt(px * px + py * py + pz * pz));
     float b = ABS(sqrt(xx * xx + yy * yy + zz * zz));
     
     dot /= (a * b);
     
     if (dot < sensitivity) // bounce
     {
     if (!isChange)
     {
     isChange = YES;
     // count increases and all work done here
     } else {
     isChange = NO;
     }
     px = xx; py = yy; pz = zz;
     } */ // this is a pedometer algorithm from O'reilly blog by Erica Sadun [http://blogs.oreilly.com/iphone/2008/06/iphone-as-pedometer.html, june 2008]
    
    
    float dot = (accelerationValuesPrev[0] * accelerationValues[0]) + (accelerationValuesPrev[1] * accelerationValues[1]) + (accelerationValuesPrev[2] * accelerationValues[2]); 
    
    float a = ABS(sqrt(accelerationValuesPrev[0] * accelerationValuesPrev[0] + accelerationValuesPrev[1] * accelerationValuesPrev[1] + 
                       accelerationValuesPrev[2] * accelerationValuesPrev[2]));
    float b = ABS(sqrt(accelerationValues[0] * accelerationValues[0] + accelerationValues[1] * accelerationValues[1] + accelerationValues[2] * accelerationValues[2]));
    
    dot /= (a * b);
    
   // mTextSend.text= [NSString stringWithFormat:@"%.2f", dot];
        
    //save the previous acceleration vector to calculate the two successive acceleration vectors angle, dot product
    accelerationValuesPrev[0]=accelerationValues[0];
    accelerationValuesPrev[1]=accelerationValues[1];
    accelerationValuesPrev[2]=accelerationValues[2];
    
    
    
    if(dot < 0.98){ //using accelerometer raw data, including gravity
    //if(accelerationValues[2] > -0.9){ //using accelerometer raw data including gravity
        
    //if(dot < -0.5){ //using userAcceleration
    //if(accelerationValues[2] > 0.1){ //using userAcceleration
	
		if(flag == 1){
		steps=steps + 1;
		stepsLabel.text= [NSString stringWithFormat:@"%.3d", steps];
		stepsLabel2.text= [NSString stringWithFormat:@"%.3d", steps];
			
			flag=3;
			
			
			heightString = heightTextField.text;
			//[heightTextField resignFirstResponder];
			
			float heightFloat = [heightString floatValue];
			
	
			
			
		
			
			//genderString = genderTextField.text;
			//[genderTextField resignFirstResponder];
			
			/*if([genderString isEqualToString:@"male"]){
			
				kGender = 0.415;
				
			} else if ([genderString isEqualToString:@"female"]) {
			    kGender = 0.413;
			}else {
				kGender = 0.415;
			}*/

			
			
			stride= ((heightFloat/0.0254)*(kGender)*(0.0254));
			
			pos = pos + ((1)* ((heightFloat/0.0254)*(kGender)*(0.0254))); //distance fused
            posPDRTOFUSED = posPDRTOFUSED + ((1)* ((heightFloat/0.0254)*(kGender)*(0.0254))); //distance FusedPDR
			//[secondPosition setCenter:CGPointMake(pos, 240)];
			//[initialPosition setCenter:CGPointMake(pos, 240)];
			posLabel.text = [NSString stringWithFormat:@"%.2f", pos];
			posLabel2.text = [NSString stringWithFormat:@"%.2f", pos];
			
			
			if(steps == 0){
			
			[initialPosition setCenter:CGPointMake(xStart, yStart)];
			
				
					
					/*for (int i=0; i<100; i++) {
						posArr[2*i] = 270.0;
						posArr[(2*i)+1] = 397.0;
					}*/
				
			
			}else {
			
				/*if((headingGlobal > 50) && (headingGlobal < 200)){
					stride = -stride;
				}else{
				
					stride = stride;
				}
				 */
				
				//xIm= acos(headingGlobal)*stride;
				//yIm=asin(headingGlobal)*stride;
			
				float dx=0;
				float dy=0;
				
				//dx= cos(newHeading.magneticHeading)*stride;
				//dy= sin(newHeading.magneticHeading)*stride; 
				
				//dx= cos(headingGlobal)*stride;
				//dy= sin(headingGlobal)*stride; 
		
				if(forcedHeading == 1){
					
					degImage=0;
					dx=dx;
					dy=(-1*stride);
				
				}else if (forcedHeading == 2) {
				    degImage=45;
					dx=(0.7071*stride); // cos 45= 0.7071 sin 45 = 0.7071  
					dy=(-0.7071*stride);
					
				}else if (forcedHeading == 3) {
					degImage=90;
					dx=stride;
					dy=dy;
					
				}else if (forcedHeading == 4) {
					degImage=135;
					dx=(0.7071*stride);
					dy=(0.7071*stride);
					
				}else if (forcedHeading == 5) {
					degImage=180;
					dx=dx;
					dy=(stride);
					
				}else if (forcedHeading == 6) {
					degImage=225;
					dx=(-0.7071*stride);
					dy=(0.7071*stride);
					
				}else if (forcedHeading == 7) {
					degImage=270;
					dx=(-1*stride);
					dy=dy;
					
				}else if (forcedHeading == 8) {
					degImage=315;
					dx=(-0.7071*stride);
					dy=(-0.7071*stride);
					
				}else{
					dx=dx;
				dy=dy;	 
			}
			
				
				
				x=x+dx;
				fusedx=fusedx+dx;
				y=y+dy;
				fusedy=fusedy+dy;
				
				xx= (xStart + (x*PixXMeter));
				yy= (yStart + (y*PixXMeter)); // m/pix (72/570) = 1/9.9166  m*pix/m=pix 1 m = 7.9166 pix
                
            
				
				
				
				if(((steps%5)==0)){
				
				
					
					
				}
				
				
				NSLog(@"2. Send\n");
				//if(tcp) [tcp sendData: @"<CR>002001010000<26F6><CR>\n"]; //ASCII request to M9 UHF RFID reader
			    //if(tcp) [tcp sendData: @"<CR>000001010000<CR>"]; //Select tag
				//if(tcp) [tcp sendData: @"<CR>000000102000000000000<CR>"]; //read tag
				//if(tcp) [tcp sendData: @"<CR>[0002][0101][8200]<CR>"]; //inventory tags (reads all tags in the field
				//if(tcp) [tcp sendData: @"<02>0008002001010000<F81A>\n"]; //Binary request to M9 UHF RFID reader
				//if(tcp) [tcp sendData: @"\n"];
			
				
				//Using Alert View string comparison examples
				
				/*NSString *str1 = @"Apple";;
				NSString *str2 = @"Orange";
				if([str1 isEqualToString: str2]){
					UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"Both strings are equal." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
					[alert show];
					[alert release];  
				}else{
					UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"Strings are not equal" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
					[alert show];
					[alert release];
				}*/
				
				
				NSString *RFIDString=@"1";
				
				
				RFIDString = RFIDTextField.text;
				[RFIDTextField resignFirstResponder];
				
                float K1x=0.5;
                float K2x=0.5;
                float K1y=0.5;
                float K2y=0.5;
                
                float errorRFIDx=1;
                float errorRFIDy=1;
                float errorPDRx;
                float errorPDRy;
                
                float xStartFused;
                float yStartFused;
                
                float xFusedCalc; 
                float yFusedCalc;
		
				
				//testLabel.text=subword;
				
			    //int RFIDStringInt = [RFIDString intValue];
				//testLabel.text= [NSString stringWithFormat:@"%.10d", RFIDStringInt];
				
				
				//float RFIDFloat = [RFIDString floatValue];
				
				
				// Comienza if para seleecionar el RFIDReader=0 utilizado M9
				
				
			
				
				//if(flag10==0){
				
                //***if(tcp) [tcp sendData: mTextSend.text];
				
                //[mTextSend resignFirstResponder];
					flag10=1;
				//}else{}
						
				RFIDString = RFIDTextField.text;
				[RFIDTextField resignFirstResponder];
                
                
                NSString *searchZero = @"40000CE";
				NSRange rangeZero = [RFIDString rangeOfString : searchZero];
				
				NSString *searchOne = @"E0000D9";
			    NSRange rangeOne = [RFIDString rangeOfString : searchOne];
				
				NSString *searchTwo = @"10000000000000000000002";//0002
				NSRange rangeTwo = [RFIDString rangeOfString : searchTwo];
				
				NSString *searchThree = @"4000083";
				NSRange rangeThree = [RFIDString rangeOfString : searchThree];
                
				NSString *searchFour = @"800009D";
				NSRange rangeFour = [RFIDString rangeOfString : searchFour];
                
				NSString *searchFive = @"0000030";
				NSRange rangeFive = [RFIDString rangeOfString : searchFive];
                
				NSString *searchSix = @"100000000000000000000022";
				NSRange rangeSix = [RFIDString rangeOfString : searchSix];
                
				NSString *searchSeven = @"100000000000000000000003";
				NSRange rangeSeven = [RFIDString rangeOfString : searchSeven];
                
				NSString *searchEight = @"5052535";
				NSRange rangeEight = [RFIDString rangeOfString : searchEight];
                
				NSString *searchNine = @"000105F";
				NSRange rangeNine = [RFIDString rangeOfString : searchNine];
                
				NSString *searchTen = @"0000D23";
				NSRange rangeTen = [RFIDString rangeOfString : searchTen];
                
				NSString *searchEleven = @"0000F93";
				NSRange rangeEleven = [RFIDString rangeOfString : searchEleven];
                
				NSString *searchTwelve = @"0000D90";
				NSRange rangeTwelve = [RFIDString rangeOfString : searchTwelve];
                
				NSString *searchThirteen = @"000104C";
				NSRange rangeThirteen = [RFIDString rangeOfString : searchThirteen];
                
				NSString *searchFourteen = @"0001100";
				NSRange rangeFourteen = [RFIDString rangeOfString : searchFourteen];
                
				NSString *searchFifteen = @"0000D34";
				NSRange rangeFifteen = [RFIDString rangeOfString : searchFifteen];
                
				NSString *searchSixteen = @"0000D9B";
				NSRange rangeSixteen = [RFIDString rangeOfString : searchSixteen];
                
				NSString *searchSeventeen = @"0002CFB";
				NSRange rangeSeventeen = [RFIDString rangeOfString : searchSeventeen];
                
				NSString *searchEighteen = @"0002D2C";
				NSRange rangeEighteen = [RFIDString rangeOfString : searchEighteen];
                
				NSString *searchNineteen = @"0000E50";
				NSRange rangeNineteen = [RFIDString rangeOfString : searchNineteen];
                
				NSString *searchTwenty = @"00010C0";
				NSRange rangeTwenty = [RFIDString rangeOfString : searchTwenty];
                
				NSString *searchTwentyone = @"0000F58";
				NSRange rangeTwentyone = [RFIDString rangeOfString : searchTwentyone];
                
				NSString *searchTwentytwo = @"0000F10";
				NSRange rangeTwentytwo = [RFIDString rangeOfString : searchTwentytwo];
                
				NSString *searchTwentythree = @"00007E8";
				NSRange rangeTwentythree = [RFIDString rangeOfString : searchTwentythree];
                
				NSString *searchTwentyfour = @"0000ED7";
				NSRange rangeTwentyfour = [RFIDString rangeOfString : searchTwentyfour];
                
				NSString *searchTwentyfive = @"000065A";
				NSRange rangeTwentyfive = [RFIDString rangeOfString : searchTwentyfive];
                
				NSString *searchTwentysix = @"00010E4";
				NSRange rangeTwentysix = [RFIDString rangeOfString : searchTwentysix];
                
				NSString *searchTwentyseven = @"0000F64";
				NSRange rangeTwentyseven = [RFIDString rangeOfString : searchTwentyseven];
                
				NSString *searchTwentyeight = @"0000E43";
				NSRange rangeTwentyeight = [RFIDString rangeOfString : searchTwentyeight];
                
				NSString *searchTwentynine = @"0000E2B";
				NSRange rangeTwentynine = [RFIDString rangeOfString : searchTwentynine];
                
                
                if(RFIDReader == 0){	
                
                    searchZero = @"40000CE";
                    rangeZero = [RFIDString rangeOfString : searchZero];
                    
                    searchOne = @"E0000D9";
                    rangeOne = [RFIDString rangeOfString : searchOne];
                    
                    //searchTwo = @"10000000000000000000002";//0002
                    searchTwo = @"FFFFFFFFFFFFFFFFFFF";//0002
                    rangeTwo = [RFIDString rangeOfString : searchTwo];
                    
                    searchThree = @"4000083";
                    rangeThree = [RFIDString rangeOfString : searchThree];
                    
                    searchFour = @"800009D";
                    rangeFour = [RFIDString rangeOfString : searchFour];
                    
                    searchFive = @"0000030";
                    rangeFive = [RFIDString rangeOfString : searchFive];
                    
                    searchSix = @"100000000000000000000022";
                    rangeSix = [RFIDString rangeOfString : searchSix];
                    
                    searchSeven = @"100000000000000000000003";
                    rangeSeven = [RFIDString rangeOfString : searchSeven];                    
                    searchEight = @"5052535";
                    rangeEight = [RFIDString rangeOfString : searchEight];
                    
                    searchNine = @"000105F";
                    rangeNine = [RFIDString rangeOfString : searchNine];
                    
                    searchTen = @"0000D23";
                    rangeTen = [RFIDString rangeOfString : searchTen];
                    
                    searchEleven = @"0000F93";
                    rangeEleven = [RFIDString rangeOfString : searchEleven];
                    
                    searchTwelve = @"0000D90";
                    rangeTwelve = [RFIDString rangeOfString : searchTwelve];
                    
                    searchThirteen = @"000104C";
                    rangeThirteen = [RFIDString rangeOfString : searchThirteen];
                    
                    searchFourteen = @"0001100";
                    rangeFourteen = [RFIDString rangeOfString : searchFourteen];
                    
                    searchFifteen = @"0000D34";
                    rangeFifteen = [RFIDString rangeOfString : searchFifteen];
                    
                    searchSixteen = @"0000D9B";
                    rangeSixteen = [RFIDString rangeOfString : searchSixteen];
                    
                    searchSeventeen = @"0002CFB";
                    rangeSeventeen = [RFIDString rangeOfString : searchSeventeen];
                    
                    searchEighteen = @"0002D2C";
                    rangeEighteen = [RFIDString rangeOfString : searchEighteen];
                    
                    searchNineteen = @"0000E50";
                    rangeNineteen = [RFIDString rangeOfString : searchNineteen];
                    
                    searchTwenty = @"00010C0";
                    rangeTwenty = [RFIDString rangeOfString : searchTwenty];
                    
                    searchTwentyone = @"0000F58";
                    rangeTwentyone = [RFIDString rangeOfString : searchTwentyone];
                    
                    searchTwentytwo = @"0000F10";
                    rangeTwentytwo = [RFIDString rangeOfString : searchTwentytwo];
                    
                    searchTwentythree = @"00007E8";
                    rangeTwentythree = [RFIDString rangeOfString : searchTwentythree];
                    
                    searchTwentyfour = @"0000ED7";
                    rangeTwentyfour = [RFIDString rangeOfString : searchTwentyfour];
                    
                    searchTwentyfive = @"000065A";
                    rangeTwentyfive = [RFIDString rangeOfString : searchTwentyfive];
                    
                    searchTwentysix = @"00010E4";
                    rangeTwentysix = [RFIDString rangeOfString : searchTwentysix];
                    
                    searchTwentyseven = @"0000F64";
                    rangeTwentyseven = [RFIDString rangeOfString : searchTwentyseven];
                    
                    searchTwentyeight = @"0000E43";
                    rangeTwentyeight = [RFIDString rangeOfString : searchTwentyeight];
                    
                    searchTwentynine = @"0000E2B";
                    rangeTwentynine = [RFIDString rangeOfString : searchTwentynine];
                    



                } // end of RFID reader Skyetek M9
                
                if (RFIDReader == 1) {
                    
                    searchZero = @"00000001";
                    rangeZero = [RFIDString rangeOfString : searchZero];
                    
                    
                    
                    searchSeven = @"00000002";
                    rangeSeven = [RFIDString rangeOfString : searchSeven];
                    
                    searchEight = @"00000003";
                    rangeEight = [RFIDString rangeOfString : searchEight];
                    
                    searchThirteen = @"00000004";
                    rangeThirteen = [RFIDString rangeOfString : searchThirteen];
                    
                    searchFourteen = @"00000005";
                    rangeFourteen = [RFIDString rangeOfString : searchFourteen];
                    
                    
                    searchSeventeen = @"00000006";
                    rangeSeventeen = [RFIDString rangeOfString : searchSeventeen];
                    
                    searchEighteen = @"00000007";
                    rangeEighteen = [RFIDString rangeOfString : searchEighteen];
                    
                    
                    searchTwentyfive = @"00000008";
                    rangeTwentyfive = [RFIDString rangeOfString : searchTwentyfive];
                    
                    searchTwentysix = @"00000009";
                    rangeTwentysix = [RFIDString rangeOfString : searchTwentysix];
                    
                    searchTwentyseven = @"0000000A";
                    rangeTwentyseven = [RFIDString rangeOfString : searchTwentyseven];
                    
                    searchTwentyeight = @"000E0586";
                    rangeTwentyeight = [RFIDString rangeOfString : searchTwentyeight];
                    
                    /* searchTwentynine = @"0000E2B";
                     rangeTwentynine = [RFIDString rangeOfString : searchTwentynine];*/
                    
            
                 
                } //end of RFID reader LR-X30
                
			
					
					if (rangeZero.location != NSNotFound)  {
						NSLog(@"I found something $00$.", rangeZero.location);
						
						currentTag=1;
						
						RFIDxx = 512;
						RFIDyy = 393;
						
						[RFIDinitialPosition setCenter:CGPointMake(RFIDxx, RFIDyy)];
						
						/*fusedxx=(RFIDxx*1) + ((RFIDxx+(x*7.9166))*0);
						fusedyy=(RFIDyy*1) + ((RFIDyy+(y*7.9166))*0);*/
						
						if(currentTag != prevTag){
							fusedx=0;
							fusedy=0;
							//flag11=2;
                            posPDRTOFUSED=0;
                        }
						
                        
                        if(filteringMethod == 0){
                        
                            errorRFIDx=1;
                            errorRFIDy=1;
                            errorPDRx=0.05*posPDRTOFUSED;
                            errorPDRy=0.05*posPDRTOFUSED;
                            
                            K1x=(errorPDRx/(errorPDRx+errorRFIDx));
                            K2x=(errorRFIDx/(errorPDRx+errorRFIDx));
                            
                            K1y=(errorPDRy/(errorPDRy+errorRFIDy));
                            K2y=(errorRFIDy/(errorPDRy+errorRFIDy));
                            
                            //use K1 and K2 to calculate the fused (RFID + PDR) position
                            
                            xStartFused = RFIDxx;
                             yStartFused = RFIDyy;
                             
                             xFusedCalc = xStartFused + (fusedx*PixXMeter);
                             yFusedCalc = yStartFused + (fusedy*PixXMeter);
                             
                             fusedxx=((RFIDxx*K1x+(xFusedCalc*K2x)));
                             fusedyy=((RFIDyy*K1y+(yFusedCalc*K2y)));

                        
                        }
                                                
                        
                        if (filteringMethod == 1) {
                            fusedxx=((RFIDxx*1+(fusedx*PixXMeter*1)));
                            fusedyy=((RFIDyy*1+(fusedy*PixXMeter*1)));  
                        }
                        
                        
                        if (filteringMethod == 2) {
                        
                            fusedxx=((RFIDxx*1+(fusedx*PixXMeter*1)));
                            fusedyy=((RFIDyy*1+(fusedy*PixXMeter*1)));
                        }
                        
                        
						[fusedinitialPosition setCenter:CGPointMake(fusedxx, fusedyy)];
					
						prevTag=currentTag;
						
					}else if (rangeOne.location != NSNotFound) {
						NSLog(@"I found something $01$.", rangeOne.location);
						
						currentTag=2;
						
						RFIDxx = 459;
						RFIDyy = 392;
						
						[RFIDinitialPosition setCenter:CGPointMake(RFIDxx, RFIDyy)];
						
						/*fusedxx=(RFIDxx*1) + ((RFIDxx+(x*7.9166))*0);
						fusedyy=(RFIDyy*1) + ((RFIDyy+(y*7.9166))*0);*/
						
						if(currentTag != prevTag){
							fusedx=0;
							fusedy=0;
							//flag11=2;
                            posPDRTOFUSED=0;
						}
						
						
                        
                        if(filteringMethod == 0){
                            
                            errorRFIDx=1;
                            errorRFIDy=1;
                            errorPDRx=0.05*posPDRTOFUSED;
                            errorPDRy=0.05*posPDRTOFUSED;
                            
                            K1x=(errorPDRx/(errorPDRx+errorRFIDx));
                            K2x=(errorRFIDx/(errorPDRx+errorRFIDx));
                            
                            K1y=(errorPDRy/(errorPDRy+errorRFIDy));
                            K2y=(errorRFIDy/(errorPDRy+errorRFIDy));
                            
                            //use K1 and K2 to calculate the fused (RFID + PDR) position
                            
                            xStartFused = RFIDxx;
                            yStartFused = RFIDyy;
                            
                            xFusedCalc = xStartFused + (fusedx*PixXMeter);
                            yFusedCalc = yStartFused + (fusedy*PixXMeter);
                            
                            fusedxx=((RFIDxx*K1x+(xFusedCalc*K2x)));
                            fusedyy=((RFIDyy*K1y+(yFusedCalc*K2y)));
                            
                            
                        }
                        
                        
                        if (filteringMethod == 1) {
                            fusedxx=((RFIDxx*1+(fusedx*PixXMeter*1)));
                            fusedyy=((RFIDyy*1+(fusedy*PixXMeter*1)));  
                        }
                        
                        
                        if (filteringMethod == 2) {
                            
                            fusedxx=((RFIDxx*1+(fusedx*PixXMeter*1)));
                            fusedyy=((RFIDyy*1+(fusedy*PixXMeter*1)));
                        }
                        
						
						[fusedinitialPosition setCenter:CGPointMake(fusedxx, fusedyy)];
						
						prevTag=currentTag;
						
					}else if (rangeTwo.location != NSNotFound) {
							NSLog(@"I found something $02$.", rangeTwo.location);
						
						currentTag=3;
						
							RFIDxx = 427;
							RFIDyy = 393;
						
						[RFIDinitialPosition setCenter:CGPointMake(RFIDxx, RFIDyy)];
							
						/*fusedxx=(RFIDxx*1) + ((RFIDxx+(x*7.9166))*0);
						fusedyy=(RFIDyy*1) + ((RFIDyy+(y*7.9166))*0);*/
						
						if(currentTag != prevTag){
							fusedx=0;
							fusedy=0;
							//flag11=2;
                            posPDRTOFUSED=0;
						}
                        
                        
                        if(filteringMethod == 0){
                            
                            errorRFIDx=1;
                            errorRFIDy=1;
                            errorPDRx=0.05*posPDRTOFUSED;
                            errorPDRy=0.05*posPDRTOFUSED;
                            
                            K1x=(errorPDRx/(errorPDRx+errorRFIDx));
                            K2x=(errorRFIDx/(errorPDRx+errorRFIDx));
                            
                            K1y=(errorPDRy/(errorPDRy+errorRFIDy));
                            K2y=(errorRFIDy/(errorPDRy+errorRFIDy));
                            
                            //use K1 and K2 to calculate the fused (RFID + PDR) position
                            
                            xStartFused = RFIDxx;
                            yStartFused = RFIDyy;
                            
                            xFusedCalc = xStartFused + (fusedx*PixXMeter);
                            yFusedCalc = yStartFused + (fusedy*PixXMeter);
                            
                            fusedxx=((RFIDxx*K1x+(xFusedCalc*K2x)));
                            fusedyy=((RFIDyy*K1y+(yFusedCalc*K2y)));
                            
                            
                        }
                        
                        
                        if (filteringMethod == 1) {
                            fusedxx=((RFIDxx*1+(fusedx*PixXMeter*1)));
                            fusedyy=((RFIDyy*1+(fusedy*PixXMeter*1)));  
                        }
                        
                        
                        if (filteringMethod == 2) {
                            
                            fusedxx=((RFIDxx*1+(fusedx*PixXMeter*1)));
                            fusedyy=((RFIDyy*1+(fusedy*PixXMeter*1)));
                        }
                        
						
                        
                        [fusedinitialPosition setCenter:CGPointMake(fusedxx, fusedyy)];
						prevTag=currentTag;
						
					}else if (rangeThree.location != NSNotFound) {
						NSLog(@"I found something $03$.", rangeThree.location);
						currentTag=4;
						RFIDxx = 389;
						RFIDyy = 393;
						
						[RFIDinitialPosition setCenter:CGPointMake(RFIDxx, RFIDyy)];
						
						/*fusedxx=(RFIDxx*1) + ((RFIDxx+(x*7.9166))*0);
						 fusedyy=(RFIDyy*1) + ((RFIDyy+(y*7.9166))*0);*/
						
						
						
						if(currentTag != prevTag){
							fusedx=0;
							fusedy=0;
							//flag11=2;
                            posPDRTOFUSED=0;
						}
						
						
                        
                        if(filteringMethod == 0){
                            
                            errorRFIDx=1;
                            errorRFIDy=1;
                            errorPDRx=0.05*posPDRTOFUSED;
                            errorPDRy=0.05*posPDRTOFUSED;
                            
                            K1x=(errorPDRx/(errorPDRx+errorRFIDx));
                            K2x=(errorRFIDx/(errorPDRx+errorRFIDx));
                            
                            K1y=(errorPDRy/(errorPDRy+errorRFIDy));
                            K2y=(errorRFIDy/(errorPDRy+errorRFIDy));
                            
                            //use K1 and K2 to calculate the fused (RFID + PDR) position
                            
                            xStartFused = RFIDxx;
                            yStartFused = RFIDyy;
                            
                            xFusedCalc = xStartFused + (fusedx*PixXMeter);
                            yFusedCalc = yStartFused + (fusedy*PixXMeter);
                            
                            fusedxx=((RFIDxx*K1x+(xFusedCalc*K2x)));
                            fusedyy=((RFIDyy*K1y+(yFusedCalc*K2y)));
                            
                            
                        }
                        
                        
                        if (filteringMethod == 1) {
                            fusedxx=((RFIDxx*1+(fusedx*PixXMeter*1)));
                            fusedyy=((RFIDyy*1+(fusedy*PixXMeter*1)));  
                        }
                        
                        
                        if (filteringMethod == 2) {
                            
                            fusedxx=((RFIDxx*1+(fusedx*PixXMeter*1)));
                            fusedyy=((RFIDyy*1+(fusedy*PixXMeter*1)));
                        }
                        
                        
                        
						[fusedinitialPosition setCenter:CGPointMake(fusedxx, fusedyy)];
						prevTag=currentTag;	
					}else if (rangeFour.location != NSNotFound) {
						NSLog(@"I found something $04$.", rangeFour.location);
						currentTag=5;
						
						RFIDxx = 314;
						RFIDyy = 393;
						
						[RFIDinitialPosition setCenter:CGPointMake(RFIDxx, RFIDyy)];
						
						/*fusedxx=(RFIDxx*1) + ((RFIDxx+(x*7.9166))*0);
						 fusedyy=(RFIDyy*1) + ((RFIDyy+(y*7.9166))*0);*/
						
					    if(currentTag != prevTag){
							fusedx=0;
							fusedy=0;
							//flag11=2;
                            posPDRTOFUSED=0;
						}
						
						
						
                        
                        if(filteringMethod == 0){
                            
                            errorRFIDx=1;
                            errorRFIDy=1;
                            errorPDRx=0.05*posPDRTOFUSED;
                            errorPDRy=0.05*posPDRTOFUSED;
                            
                            K1x=(errorPDRx/(errorPDRx+errorRFIDx));
                            K2x=(errorRFIDx/(errorPDRx+errorRFIDx));
                            
                            K1y=(errorPDRy/(errorPDRy+errorRFIDy));
                            K2y=(errorRFIDy/(errorPDRy+errorRFIDy));
                            
                            //use K1 and K2 to calculate the fused (RFID + PDR) position
                            
                            xStartFused = RFIDxx;
                            yStartFused = RFIDyy;
                            
                            xFusedCalc = xStartFused + (fusedx*PixXMeter);
                            yFusedCalc = yStartFused + (fusedy*PixXMeter);
                            
                            fusedxx=((RFIDxx*K1x+(xFusedCalc*K2x)));
                            fusedyy=((RFIDyy*K1y+(yFusedCalc*K2y)));
                            
                            
                        }
                        
                        
                        if (filteringMethod == 1) {
                            fusedxx=((RFIDxx*1+(fusedx*PixXMeter*1)));
                            fusedyy=((RFIDyy*1+(fusedy*PixXMeter*1)));  
                        }
                        
                        
                        if (filteringMethod == 2) {
                            
                            fusedxx=((RFIDxx*1+(fusedx*PixXMeter*1)));
                            fusedyy=((RFIDyy*1+(fusedy*PixXMeter*1)));
                        }
                        
                        
                        
						[fusedinitialPosition setCenter:CGPointMake(fusedxx, fusedyy)];
						prevTag=currentTag;
						
					}else if (rangeFive.location != NSNotFound)  {
						NSLog(@"I found something $05$.", rangeFive.location);
						currentTag=6;
						RFIDxx = 217;
						RFIDyy = 393;
						
						[RFIDinitialPosition setCenter:CGPointMake(RFIDxx, RFIDyy)];
						
						/*fusedxx=(RFIDxx*1) + ((RFIDxx+(x*7.9166))*0);
						 fusedyy=(RFIDyy*1) + ((RFIDyy+(y*7.9166))*0);*/
						
					    if(currentTag != prevTag){
							fusedx=0;
							fusedy=0;
							//flag11=2;
                            posPDRTOFUSED=0;
						}
						
					
                        
                        if(filteringMethod == 0){
                            
                            errorRFIDx=1;
                            errorRFIDy=1;
                            errorPDRx=0.05*posPDRTOFUSED;
                            errorPDRy=0.05*posPDRTOFUSED;
                            
                            K1x=(errorPDRx/(errorPDRx+errorRFIDx));
                            K2x=(errorRFIDx/(errorPDRx+errorRFIDx));
                            
                            K1y=(errorPDRy/(errorPDRy+errorRFIDy));
                            K2y=(errorRFIDy/(errorPDRy+errorRFIDy));
                            
                            //use K1 and K2 to calculate the fused (RFID + PDR) position
                            
                            xStartFused = RFIDxx;
                            yStartFused = RFIDyy;
                            
                            xFusedCalc = xStartFused + (fusedx*PixXMeter);
                            yFusedCalc = yStartFused + (fusedy*PixXMeter);
                            
                            fusedxx=((RFIDxx*K1x+(xFusedCalc*K2x)));
                            fusedyy=((RFIDyy*K1y+(yFusedCalc*K2y)));
                            
                            
                        }
                        
                        
                        if (filteringMethod == 1) {
                            fusedxx=((RFIDxx*1+(fusedx*PixXMeter*1)));
                            fusedyy=((RFIDyy*1+(fusedy*PixXMeter*1)));  
                        }
                        
                        
                        if (filteringMethod == 2) {
                            
                            fusedxx=((RFIDxx*1+(fusedx*PixXMeter*1)));
                            fusedyy=((RFIDyy*1+(fusedy*PixXMeter*1)));
                        }
                        
                        
						[fusedinitialPosition setCenter:CGPointMake(fusedxx, fusedyy)];
						prevTag=currentTag;
						
					}else if (rangeSix.location != NSNotFound) {
						NSLog(@"I found something $06$.", rangeSix.location);
						currentTag=7;
						RFIDxx = 170;
						RFIDyy = 393;
						
						[RFIDinitialPosition setCenter:CGPointMake(RFIDxx, RFIDyy)];
						
						/*fusedxx=(RFIDxx*1) + ((RFIDxx+(x*7.9166))*0);
						 fusedyy=(RFIDyy*1) + ((RFIDyy+(y*7.9166))*0);*/
						
						if(currentTag != prevTag){
							fusedx=0;
							fusedy=0;
							//flag11=2;
                            posPDRTOFUSED=0;
						}
						
                        
                        if(filteringMethod == 0){
                            
                            errorRFIDx=1;
                            errorRFIDy=1;
                            errorPDRx=0.05*posPDRTOFUSED;
                            errorPDRy=0.05*posPDRTOFUSED;
                            
                            K1x=(errorPDRx/(errorPDRx+errorRFIDx));
                            K2x=(errorRFIDx/(errorPDRx+errorRFIDx));
                            
                            K1y=(errorPDRy/(errorPDRy+errorRFIDy));
                            K2y=(errorRFIDy/(errorPDRy+errorRFIDy));
                            
                            //use K1 and K2 to calculate the fused (RFID + PDR) position
                            
                            xStartFused = RFIDxx;
                            yStartFused = RFIDyy;
                            
                            xFusedCalc = xStartFused + (fusedx*PixXMeter);
                            yFusedCalc = yStartFused + (fusedy*PixXMeter);
                            
                            fusedxx=((RFIDxx*K1x+(xFusedCalc*K2x)));
                            fusedyy=((RFIDyy*K1y+(yFusedCalc*K2y)));
                            
                            
                        }
                        
                        
                        if (filteringMethod == 1) {
                            fusedxx=((RFIDxx*1+(fusedx*PixXMeter*1)));
                            fusedyy=((RFIDyy*1+(fusedy*PixXMeter*1)));  
                        }
                        
                        
                        if (filteringMethod == 2) {
                            
                            fusedxx=((RFIDxx*1+(fusedx*PixXMeter*1)));
                            fusedyy=((RFIDyy*1+(fusedy*PixXMeter*1)));
                        }
                        
                        
						[fusedinitialPosition setCenter:CGPointMake(fusedxx, fusedyy)];
						prevTag=currentTag;
					}else if (rangeSeven.location != NSNotFound) {
						NSLog(@"I found something $07$.", rangeSeven.location);
						currentTag=8;
						RFIDxx = 138;
						RFIDyy = 393;
						
						[RFIDinitialPosition setCenter:CGPointMake(RFIDxx, RFIDyy)];
						
						/*fusedxx=(RFIDxx*1) + ((RFIDxx+(x*7.9166))*0);
						 fusedyy=(RFIDyy*1) + ((RFIDyy+(y*7.9166))*0);*/
						
						
						if(currentTag != prevTag){
							fusedx=0;
							fusedy=0;
							//flag11=2;
                            posPDRTOFUSED=0;
						}
						
						
                        
                        if(filteringMethod == 0){
                            
                            errorRFIDx=1;
                            errorRFIDy=1;
                            errorPDRx=0.05*posPDRTOFUSED;
                            errorPDRy=0.05*posPDRTOFUSED;
                            
                            K1x=(errorPDRx/(errorPDRx+errorRFIDx));
                            K2x=(errorRFIDx/(errorPDRx+errorRFIDx));
                            
                            K1y=(errorPDRy/(errorPDRy+errorRFIDy));
                            K2y=(errorRFIDy/(errorPDRy+errorRFIDy));
                            
                            //use K1 and K2 to calculate the fused (RFID + PDR) position
                            
                            xStartFused = RFIDxx;
                            yStartFused = RFIDyy;
                            
                            xFusedCalc = xStartFused + (fusedx*PixXMeter);
                            yFusedCalc = yStartFused + (fusedy*PixXMeter);
                            
                            
                            fusedxx=((RFIDxx*K1x+(xFusedCalc*K2x)));
                            fusedyy=((RFIDyy*K1y+(yFusedCalc*K2y)));
                            
                            
                        }
                        
                        
                        if (filteringMethod == 1) {
                            fusedxx=((RFIDxx*1+(fusedx*PixXMeter*1)));
                            fusedyy=((RFIDyy*1+(fusedy*PixXMeter*1)));  
                        }
                        
                        
                        if (filteringMethod == 2) {
                            
                            fusedxx=((RFIDxx*1+(fusedx*PixXMeter*1)));
                            fusedyy=((RFIDyy*1+(fusedy*PixXMeter*1)));
                        }
                        
                        
						[fusedinitialPosition setCenter:CGPointMake(fusedxx, fusedyy)];
						prevTag=currentTag;
						
					}else if (rangeEight.location != NSNotFound) {
						NSLog(@"I found something $08$.", rangeEight.location);
						currentTag=9;
						RFIDxx = 94;
						RFIDyy = 453;
						
						[RFIDinitialPosition setCenter:CGPointMake(RFIDxx, RFIDyy)];
						
						/*fusedxx=(RFIDxx*1) + ((RFIDxx+(x*7.9166))*0);
						 fusedyy=(RFIDyy*1) + ((RFIDyy+(y*7.9166))*0);*/
						
						if(currentTag != prevTag){
							fusedx=0;
							fusedy=0;
							//flag11=2;
                            posPDRTOFUSED=0;
						}
					
                        
                        if(filteringMethod == 0){
                            
                            errorRFIDx=1;
                            errorRFIDy=1;
                            errorPDRx=0.05*posPDRTOFUSED;
                            errorPDRy=0.05*posPDRTOFUSED;
                            
                            K1x=(errorPDRx/(errorPDRx+errorRFIDx));
                            K2x=(errorRFIDx/(errorPDRx+errorRFIDx));
                            
                            K1y=(errorPDRy/(errorPDRy+errorRFIDy));
                            K2y=(errorRFIDy/(errorPDRy+errorRFIDy));
                            
                            //use K1 and K2 to calculate the fused (RFID + PDR) position
                            
                            xStartFused = RFIDxx;
                            yStartFused = RFIDyy;
                            
                            xFusedCalc = xStartFused + (fusedx*PixXMeter);
                            yFusedCalc = yStartFused + (fusedy*PixXMeter);
                            
                            fusedxx=((RFIDxx*K1x+(xFusedCalc*K2x)));
                            fusedyy=((RFIDyy*K1y+(yFusedCalc*K2y)));
                            
                            
                        }
                        
                        
                        if (filteringMethod == 1) {
                            fusedxx=((RFIDxx*1+(fusedx*PixXMeter*1)));
                            fusedyy=((RFIDyy*1+(fusedy*PixXMeter*1)));  
                        }
                        
                        
                        if (filteringMethod == 2) {
                            
                            fusedxx=((RFIDxx*1+(fusedx*PixXMeter*1)));
                            fusedyy=((RFIDyy*1+(fusedy*PixXMeter*1)));
                        }
                        
                        
						[fusedinitialPosition setCenter:CGPointMake(fusedxx, fusedyy)];
						prevTag=currentTag;
					}else if (rangeNine.location != NSNotFound) {
						NSLog(@"I found something $09$.", rangeNine.location);
						currentTag=10;
						RFIDxx = 94;
						RFIDyy = 429;
						
						[RFIDinitialPosition setCenter:CGPointMake(RFIDxx, RFIDyy)];
						
						/*fusedxx=(RFIDxx*1) + ((RFIDxx+(x*7.9166))*0);
						 fusedyy=(RFIDyy*1) + ((RFIDyy+(y*7.9166))*0);*/
						
						
						
						if(currentTag != prevTag){
							fusedx=0;
							fusedy=0;
							//flag11=2;
                            posPDRTOFUSED=0;
						}
						
					
                        
                        if(filteringMethod == 0){
                            
                            errorRFIDx=1;
                            errorRFIDy=1;
                            errorPDRx=0.05*posPDRTOFUSED;
                            errorPDRy=0.05*posPDRTOFUSED;
                            
                            K1x=(errorPDRx/(errorPDRx+errorRFIDx));
                            K2x=(errorRFIDx/(errorPDRx+errorRFIDx));
                            
                            K1y=(errorPDRy/(errorPDRy+errorRFIDy));
                            K2y=(errorRFIDy/(errorPDRy+errorRFIDy));
                            
                            //use K1 and K2 to calculate the fused (RFID + PDR) position
                            
                            xStartFused = RFIDxx;
                            yStartFused = RFIDyy;
                            
                            xFusedCalc = xStartFused + (fusedx*PixXMeter);
                            yFusedCalc = yStartFused + (fusedy*PixXMeter);
                            
                            fusedxx=((RFIDxx*K1x+(xFusedCalc*K2x)));
                            fusedyy=((RFIDyy*K1y+(yFusedCalc*K2y)));
                            
                            
                        }
                        
                        
                        if (filteringMethod == 1) {
                            fusedxx=((RFIDxx*1+(fusedx*PixXMeter*1)));
                            fusedyy=((RFIDyy*1+(fusedy*PixXMeter*1)));  
                        }
                        
                        
                        if (filteringMethod == 2) {
                            
                            fusedxx=((RFIDxx*1+(fusedx*PixXMeter*1)));
                            fusedyy=((RFIDyy*1+(fusedy*PixXMeter*1)));
                        }
                        
                        
						[fusedinitialPosition setCenter:CGPointMake(fusedxx, fusedyy)];
						prevTag=currentTag;
					}else if (rangeTen.location != NSNotFound) {
						NSLog(@"I found something $10$.", rangeTen.location);
						currentTag=11;
						RFIDxx = 94;
						RFIDyy = 393;
						
						[RFIDinitialPosition setCenter:CGPointMake(RFIDxx, RFIDyy)];
						
						/*fusedxx=(RFIDxx*1) + ((RFIDxx+(x*7.9166))*0);
						 fusedyy=(RFIDyy*1) + ((RFIDyy+(y*7.9166))*0);*/
						
						
						if(currentTag != prevTag){
							fusedx=0;
							fusedy=0;
							//flag11=2;
                            posPDRTOFUSED=0;
						}
						
					
                        
                        if(filteringMethod == 0){
                            
                            errorRFIDx=1;
                            errorRFIDy=1;
                            errorPDRx=0.05*posPDRTOFUSED;
                            errorPDRy=0.05*posPDRTOFUSED;
                            
                            K1x=(errorPDRx/(errorPDRx+errorRFIDx));
                            K2x=(errorRFIDx/(errorPDRx+errorRFIDx));
                            
                            K1y=(errorPDRy/(errorPDRy+errorRFIDy));
                            K2y=(errorRFIDy/(errorPDRy+errorRFIDy));
                            
                            //use K1 and K2 to calculate the fused (RFID + PDR) position
                            
                            xStartFused = RFIDxx;
                            yStartFused = RFIDyy;
                            
                            xFusedCalc = xStartFused + (fusedx*PixXMeter);
                            yFusedCalc = yStartFused + (fusedy*PixXMeter);
                            
                            fusedxx=((RFIDxx*K1x+(xFusedCalc*K2x)));
                            fusedyy=((RFIDyy*K1y+(yFusedCalc*K2y)));
                            
                            
                        }
                        
                        
                        if (filteringMethod == 1) {
                            fusedxx=((RFIDxx*1+(fusedx*PixXMeter*1)));
                            fusedyy=((RFIDyy*1+(fusedy*PixXMeter*1)));  
                        }
                        
                        
                        if (filteringMethod == 2) {
                            
                            fusedxx=((RFIDxx*1+(fusedx*PixXMeter*1)));
                            fusedyy=((RFIDyy*1+(fusedy*PixXMeter*1)));
                        }
                        
                        
						[fusedinitialPosition setCenter:CGPointMake(fusedxx, fusedyy)];
					    prevTag=currentTag;	
					}else if (rangeEleven.location != NSNotFound) {
						NSLog(@"I found something $11$.", rangeEleven.location);
						currentTag=12;
						RFIDxx = 94;
						RFIDyy = 360;
						
						[RFIDinitialPosition setCenter:CGPointMake(RFIDxx, RFIDyy)];
						
						/*fusedxx=(RFIDxx*1) + ((RFIDxx+(x*7.9166))*0);
						 fusedyy=(RFIDyy*1) + ((RFIDyy+(y*7.9166))*0);*/
						
						if(currentTag != prevTag){
							fusedx=0;
							fusedy=0;
							//flag11=2;
                            posPDRTOFUSED=0;
						}
						
				
                        
                        if(filteringMethod == 0){
                            
                            errorRFIDx=1;
                            errorRFIDy=1;
                            errorPDRx=0.05*posPDRTOFUSED;
                            errorPDRy=0.05*posPDRTOFUSED;
                            
                            K1x=(errorPDRx/(errorPDRx+errorRFIDx));
                            K2x=(errorRFIDx/(errorPDRx+errorRFIDx));
                            
                            K1y=(errorPDRy/(errorPDRy+errorRFIDy));
                            K2y=(errorRFIDy/(errorPDRy+errorRFIDy));
                            
                            //use K1 and K2 to calculate the fused (RFID + PDR) position
                            
                            xStartFused = RFIDxx;
                            yStartFused = RFIDyy;
                            
                            xFusedCalc = xStartFused + (fusedx*PixXMeter);
                            yFusedCalc = yStartFused + (fusedy*PixXMeter);
                            
                            fusedxx=((RFIDxx*K1x+(xFusedCalc*K2x)));
                            fusedyy=((RFIDyy*K1y+(yFusedCalc*K2y)));
                            
                            
                        }
                        
                        
                        if (filteringMethod == 1) {
                            fusedxx=((RFIDxx*1+(fusedx*PixXMeter*1)));
                            fusedyy=((RFIDyy*1+(fusedy*PixXMeter*1)));  
                        }
                        
                        
                        if (filteringMethod == 2) {
                            
                            fusedxx=((RFIDxx*1+(fusedx*PixXMeter*1)));
                            fusedyy=((RFIDyy*1+(fusedy*PixXMeter*1)));
                        }
                        
                        
						[fusedinitialPosition setCenter:CGPointMake(fusedxx, fusedyy)];
					    prevTag=currentTag;	
					}else if (rangeTwelve.location != NSNotFound) {
						NSLog(@"I found something $12$.", rangeTwelve.location);
						currentTag=13;
						RFIDxx = 94;
						RFIDyy = 331;
						
						[RFIDinitialPosition setCenter:CGPointMake(RFIDxx, RFIDyy)];
						
						/*fusedxx=(RFIDxx*1) + ((RFIDxx+(x*7.9166))*0);
						 fusedyy=(RFIDyy*1) + ((RFIDyy+(y*7.9166))*0);*/
						
						if(currentTag != prevTag){
							fusedx=0;
							fusedy=0;
							//flag11=2;
                            posPDRTOFUSED=0;
						}
						
						
                        
                        
                        if(filteringMethod == 0){
                            
                            errorRFIDx=1;
                            errorRFIDy=1;
                            errorPDRx=0.05*posPDRTOFUSED;
                            errorPDRy=0.05*posPDRTOFUSED;
                            
                            K1x=(errorPDRx/(errorPDRx+errorRFIDx));
                            K2x=(errorRFIDx/(errorPDRx+errorRFIDx));
                            
                            K1y=(errorPDRy/(errorPDRy+errorRFIDy));
                            K2y=(errorRFIDy/(errorPDRy+errorRFIDy));
                            
                            //use K1 and K2 to calculate the fused (RFID + PDR) position
                            
                            xStartFused = RFIDxx;
                            yStartFused = RFIDyy;
                            
                            xFusedCalc = xStartFused + (fusedx*PixXMeter);
                            yFusedCalc = yStartFused + (fusedy*PixXMeter);
                            
                            fusedxx=((RFIDxx*K1x+(xFusedCalc*K2x)));
                            fusedyy=((RFIDyy*K1y+(yFusedCalc*K2y)));
                            
                            
                        }
                        
                        
                        if (filteringMethod == 1) {
                            fusedxx=((RFIDxx*1+(fusedx*PixXMeter*1)));
                            fusedyy=((RFIDyy*1+(fusedy*PixXMeter*1)));  
                        }
                        
                        
                        if (filteringMethod == 2) {
                            
                            fusedxx=((RFIDxx*1+(fusedx*PixXMeter*1)));
                            fusedyy=((RFIDyy*1+(fusedy*PixXMeter*1)));
                        }
                        
                        
						[fusedinitialPosition setCenter:CGPointMake(fusedxx, fusedyy)];
					    prevTag=currentTag;	
					}else if (rangeThirteen.location != NSNotFound) {
						NSLog(@"I found something $13$.", rangeThirteen.location);
						currentTag=14;
						RFIDxx = 84;
						RFIDyy = 252;
						
						[RFIDinitialPosition setCenter:CGPointMake(RFIDxx, RFIDyy)];
						
						/*fusedxx=(RFIDxx*1) + ((RFIDxx+(x*7.9166))*0);
						 fusedyy=(RFIDyy*1) + ((RFIDyy+(y*7.9166))*0);*/
						
						
						if(currentTag != prevTag){
							fusedx=0;
							fusedy=0;
							//flag11=2;
                            posPDRTOFUSED=0;
						}
						
						
					
                        
                        if(filteringMethod == 0){
                            
                            errorRFIDx=1;
                            errorRFIDy=1;
                            errorPDRx=0.05*posPDRTOFUSED;
                            errorPDRy=0.05*posPDRTOFUSED;
                            
                            K1x=(errorPDRx/(errorPDRx+errorRFIDx));
                            K2x=(errorRFIDx/(errorPDRx+errorRFIDx));
                            
                            K1y=(errorPDRy/(errorPDRy+errorRFIDy));
                            K2y=(errorRFIDy/(errorPDRy+errorRFIDy));
                            
                            //use K1 and K2 to calculate the fused (RFID + PDR) position
                            
                            xStartFused = RFIDxx;
                            yStartFused = RFIDyy;
                            
                            xFusedCalc = xStartFused + (fusedx*PixXMeter);
                            yFusedCalc = yStartFused + (fusedy*PixXMeter);
                            
                            fusedxx=((RFIDxx*K1x+(xFusedCalc*K2x)));
                            fusedyy=((RFIDyy*K1y+(yFusedCalc*K2y)));
                            
                            
                        }
                        
                        
                        if (filteringMethod == 1) {
                            fusedxx=((RFIDxx*1+(fusedx*PixXMeter*1)));
                            fusedyy=((RFIDyy*1+(fusedy*PixXMeter*1)));  
                        }
                        
                        
                        if (filteringMethod == 2) {
                            
                            fusedxx=((RFIDxx*1+(fusedx*PixXMeter*1)));
                            fusedyy=((RFIDyy*1+(fusedy*PixXMeter*1)));
                        }
                        
                        
						[fusedinitialPosition setCenter:CGPointMake(fusedxx, fusedyy)];
					    prevTag=currentTag;	
					}else if (rangeFourteen.location != NSNotFound) {
						NSLog(@"I found something $14$.", rangeFourteen.location);
						currentTag=15;
						RFIDxx = 94;
						RFIDyy = 188;
						
						[RFIDinitialPosition setCenter:CGPointMake(RFIDxx, RFIDyy)];
						
						/*fusedxx=(RFIDxx*1) + ((RFIDxx+(x*7.9166))*0);
						 fusedyy=(RFIDyy*1) + ((RFIDyy+(y*7.9166))*0);*/
						
						
						if(currentTag != prevTag){
							fusedx=0;
							fusedy=0;
							//flag11=2;
                            posPDRTOFUSED=0;
						}
						
						
                        
                        if(filteringMethod == 0){
                            
                            errorRFIDx=1;
                            errorRFIDy=1;
                            errorPDRx=0.05*posPDRTOFUSED;
                            errorPDRy=0.05*posPDRTOFUSED;
                            
                            K1x=(errorPDRx/(errorPDRx+errorRFIDx));
                            K2x=(errorRFIDx/(errorPDRx+errorRFIDx));
                            
                            K1y=(errorPDRy/(errorPDRy+errorRFIDy));
                            K2y=(errorRFIDy/(errorPDRy+errorRFIDy));
                            
                            //use K1 and K2 to calculate the fused (RFID + PDR) position
                            
                            xStartFused = RFIDxx;
                            yStartFused = RFIDyy;
                            
                            xFusedCalc = xStartFused + (fusedx*PixXMeter);
                            yFusedCalc = yStartFused + (fusedy*PixXMeter);
                            
                            fusedxx=((RFIDxx*K1x+(xFusedCalc*K2x)));
                            fusedyy=((RFIDyy*K1y+(yFusedCalc*K2y)));
                            
                            
                        }
                        
                        
                        if (filteringMethod == 1) {
                            fusedxx=((RFIDxx*1+(fusedx*PixXMeter*1)));
                            fusedyy=((RFIDyy*1+(fusedy*PixXMeter*1)));  
                        }
                        
                        
                        if (filteringMethod == 2) {
                            
                            fusedxx=((RFIDxx*1+(fusedx*PixXMeter*1)));
                            fusedyy=((RFIDyy*1+(fusedy*PixXMeter*1)));
                        }
                        
                        
						[fusedinitialPosition setCenter:CGPointMake(fusedxx, fusedyy)];
					    prevTag=currentTag;	
					}else if (rangeFifteen.location != NSNotFound) {
						NSLog(@"I found something $15$.", rangeFifteen.location);
						currentTag=16;
						RFIDxx = 94;
						RFIDyy = 120;
						
						[RFIDinitialPosition setCenter:CGPointMake(RFIDxx, RFIDyy)];
						
						/*fusedxx=(RFIDxx*1) + ((RFIDxx+(x*7.9166))*0);
						 fusedyy=(RFIDyy*1) + ((RFIDyy+(y*7.9166))*0);*/
						
						if(currentTag != prevTag){
							fusedx=0;
							fusedy=0;
							//flag11=2;
                            posPDRTOFUSED=0;
						}
						
                        
                        if(filteringMethod == 0){
                            
                            errorRFIDx=1;
                            errorRFIDy=1;
                            errorPDRx=0.05*posPDRTOFUSED;
                            errorPDRy=0.05*posPDRTOFUSED;
                            
                            K1x=(errorPDRx/(errorPDRx+errorRFIDx));
                            K2x=(errorRFIDx/(errorPDRx+errorRFIDx));
                            
                            K1y=(errorPDRy/(errorPDRy+errorRFIDy));
                            K2y=(errorRFIDy/(errorPDRy+errorRFIDy));
                            
                            //use K1 and K2 to calculate the fused (RFID + PDR) position
                            
                            xStartFused = RFIDxx;
                            yStartFused = RFIDyy;
                            
                            xFusedCalc = xStartFused + (fusedx*PixXMeter);
                            yFusedCalc = yStartFused + (fusedy*PixXMeter);
                            
                            fusedxx=((RFIDxx*K1x+(xFusedCalc*K2x)));
                            fusedyy=((RFIDyy*K1y+(yFusedCalc*K2y)));
                            
                            
                        }
                        
                        
                        if (filteringMethod == 1) {
                            fusedxx=((RFIDxx*1+(fusedx*PixXMeter*1)));
                            fusedyy=((RFIDyy*1+(fusedy*PixXMeter*1)));  
                        }
                        
                        
                        if (filteringMethod == 2) {
                            
                            fusedxx=((RFIDxx*1+(fusedx*PixXMeter*1)));
                            fusedyy=((RFIDyy*1+(fusedy*PixXMeter*1)));
                        }
                        
						[fusedinitialPosition setCenter:CGPointMake(fusedxx, fusedyy)];
					    prevTag=currentTag;	
					}else if (rangeSixteen.location != NSNotFound) {
						NSLog(@"I found something $16$.", rangeSixteen.location);
						currentTag=17;
						RFIDxx = 93;
						RFIDyy = 78;
						
						[RFIDinitialPosition setCenter:CGPointMake(RFIDxx, RFIDyy)];
						
						/*fusedxx=(RFIDxx*1) + ((RFIDxx+(x*7.9166))*0);
						 fusedyy=(RFIDyy*1) + ((RFIDyy+(y*7.9166))*0);*/
						
						
						if(currentTag != prevTag){
							fusedx=0;
							fusedy=0;
							//flag11=2;
                            posPDRTOFUSED=0;
						}
						
                        
                        if(filteringMethod == 0){
                            
                            errorRFIDx=1;
                            errorRFIDy=1;
                            errorPDRx=0.05*posPDRTOFUSED;
                            errorPDRy=0.05*posPDRTOFUSED;
                            
                            K1x=(errorPDRx/(errorPDRx+errorRFIDx));
                            K2x=(errorRFIDx/(errorPDRx+errorRFIDx));
                            
                            K1y=(errorPDRy/(errorPDRy+errorRFIDy));
                            K2y=(errorRFIDy/(errorPDRy+errorRFIDy));
                            
                            //use K1 and K2 to calculate the fused (RFID + PDR) position
                            
                            xStartFused = RFIDxx;
                            yStartFused = RFIDyy;
                            
                            xFusedCalc = xStartFused + (fusedx*PixXMeter);
                            yFusedCalc = yStartFused + (fusedy*PixXMeter);
                            
                            fusedxx=((RFIDxx*K1x+(xFusedCalc*K2x)));
                            fusedyy=((RFIDyy*K1y+(yFusedCalc*K2y)));
                            
                            
                        }
                        
                        
                        if (filteringMethod == 1) {
                            fusedxx=((RFIDxx*1+(fusedx*PixXMeter*1)));
                            fusedyy=((RFIDyy*1+(fusedy*PixXMeter*1)));  
                        }
                        
                        
                        if (filteringMethod == 2) {
                            
                            fusedxx=((RFIDxx*1+(fusedx*PixXMeter*1)));
                            fusedyy=((RFIDyy*1+(fusedy*PixXMeter*1)));
                        }
                        
						[fusedinitialPosition setCenter:CGPointMake(fusedxx, fusedyy)];
					    prevTag=currentTag;	
					}else if (rangeSeventeen.location != NSNotFound) {
						NSLog(@"I found something $17$.", rangeSeventeen.location);
						currentTag=18;
						RFIDxx = 93;
						RFIDyy = 55;
						
						[RFIDinitialPosition setCenter:CGPointMake(RFIDxx, RFIDyy)];
						
						/*fusedxx=(RFIDxx*1) + ((RFIDxx+(x*7.9166))*0);
						 fusedyy=(RFIDyy*1) + ((RFIDyy+(y*7.9166))*0);*/
						
						if(currentTag != prevTag){
							fusedx=0;
							fusedy=0;
							//flag11=2;
                            posPDRTOFUSED=0;
						}
						
                        
                        if(filteringMethod == 0){
                            
                            errorRFIDx=1;
                            errorRFIDy=1;
                            errorPDRx=0.05*posPDRTOFUSED;
                            errorPDRy=0.05*posPDRTOFUSED;
                            
                            K1x=(errorPDRx/(errorPDRx+errorRFIDx));
                            K2x=(errorRFIDx/(errorPDRx+errorRFIDx));
                            
                            K1y=(errorPDRy/(errorPDRy+errorRFIDy));
                            K2y=(errorRFIDy/(errorPDRy+errorRFIDy));
                            
                            //use K1 and K2 to calculate the fused (RFID + PDR) position
                            
                            xStartFused = RFIDxx;
                            yStartFused = RFIDyy;
                            
                            xFusedCalc = xStartFused + (fusedx*PixXMeter);
                            yFusedCalc = yStartFused + (fusedy*PixXMeter);
                            
                            fusedxx=((RFIDxx*K1x+(xFusedCalc*K2x)));
                            fusedyy=((RFIDyy*K1y+(yFusedCalc*K2y)));
                            
                            
                        }
                        
                        
                        if (filteringMethod == 1) {
                            fusedxx=((RFIDxx*1+(fusedx*PixXMeter*1)));
                            fusedyy=((RFIDyy*1+(fusedy*PixXMeter*1)));  
                        }
                        
                        
                        if (filteringMethod == 2) {
                            
                            fusedxx=((RFIDxx*1+(fusedx*PixXMeter*1)));
                            fusedyy=((RFIDyy*1+(fusedy*PixXMeter*1)));
                        }
                        
						[fusedinitialPosition setCenter:CGPointMake(fusedxx, fusedyy)];
					    prevTag=currentTag;	
					}else if (rangeEighteen.location != NSNotFound) {
						NSLog(@"I found something $18$.", rangeEighteen.location);
						currentTag=19;
						RFIDxx = 138;
						RFIDyy = 120;
						
						[RFIDinitialPosition setCenter:CGPointMake(RFIDxx, RFIDyy)];
						
						/*fusedxx=(RFIDxx*1) + ((RFIDxx+(x*7.9166))*0);
						 fusedyy=(RFIDyy*1) + ((RFIDyy+(y*7.9166))*0);*/
						
						if(currentTag != prevTag){
							fusedx=0;
							fusedy=0;
							//flag11=2;
                            posPDRTOFUSED=0;
						}
						
                        
                        if(filteringMethod == 0){
                            
                            errorRFIDx=1;
                            errorRFIDy=1;
                            errorPDRx=0.05*posPDRTOFUSED;
                            errorPDRy=0.05*posPDRTOFUSED;
                            
                            K1x=(errorPDRx/(errorPDRx+errorRFIDx));
                            K2x=(errorRFIDx/(errorPDRx+errorRFIDx));
                            
                            K1y=(errorPDRy/(errorPDRy+errorRFIDy));
                            K2y=(errorRFIDy/(errorPDRy+errorRFIDy));
                            
                            //use K1 and K2 to calculate the fused (RFID + PDR) position
                            
                            xStartFused = RFIDxx;
                            yStartFused = RFIDyy;
                            
                            xFusedCalc = xStartFused + (fusedx*PixXMeter);
                            yFusedCalc = yStartFused + (fusedy*PixXMeter);
                            
                            fusedxx=((RFIDxx*K1x+(xFusedCalc*K2x)));
                            fusedyy=((RFIDyy*K1y+(yFusedCalc*K2y)));
                            
                            
                        }
                        
                        
                        if (filteringMethod == 1) {
                            fusedxx=((RFIDxx*1+(fusedx*PixXMeter*1)));
                            fusedyy=((RFIDyy*1+(fusedy*PixXMeter*1)));  
                        }
                        
                        
                        if (filteringMethod == 2) {
                            
                            fusedxx=((RFIDxx*1+(fusedx*PixXMeter*1)));
                            fusedyy=((RFIDyy*1+(fusedy*PixXMeter*1)));
                        }
                        
						[fusedinitialPosition setCenter:CGPointMake(fusedxx, fusedyy)];
					    prevTag=currentTag;	
					}else if (rangeNineteen.location != NSNotFound) {
						NSLog(@"I found something $19$.", rangeNineteen.location);
						currentTag=20;
						RFIDxx = 166;
						RFIDyy = 120;
						
						[RFIDinitialPosition setCenter:CGPointMake(RFIDxx, RFIDyy)];
						
						/*fusedxx=(RFIDxx*1) + ((RFIDxx+(x*7.9166))*0);
						 fusedyy=(RFIDyy*1) + ((RFIDyy+(y*7.9166))*0);*/
						
						if(currentTag != prevTag){
							fusedx=0;
							fusedy=0;
							//flag11=2;
                            posPDRTOFUSED=0;
						}
						
                        
                        if(filteringMethod == 0){
                            
                            errorRFIDx=1;
                            errorRFIDy=1;
                            errorPDRx=0.05*posPDRTOFUSED;
                            errorPDRy=0.05*posPDRTOFUSED;
                            
                            K1x=(errorPDRx/(errorPDRx+errorRFIDx));
                            K2x=(errorRFIDx/(errorPDRx+errorRFIDx));
                            
                            K1y=(errorPDRy/(errorPDRy+errorRFIDy));
                            K2y=(errorRFIDy/(errorPDRy+errorRFIDy));
                            
                            //use K1 and K2 to calculate the fused (RFID + PDR) position
                            
                            xStartFused = RFIDxx;
                            yStartFused = RFIDyy;
                            
                            xFusedCalc = xStartFused + (fusedx*PixXMeter);
                            yFusedCalc = yStartFused + (fusedy*PixXMeter);
                        
                            
                            fusedxx=((RFIDxx*K1x+(xFusedCalc*K2x)));
                            fusedyy=((RFIDyy*K1y+(yFusedCalc*K2y)));
                            
                            
                        }
                        
                        
                        if (filteringMethod == 1) {
                            fusedxx=((RFIDxx*1+(fusedx*PixXMeter*1)));
                            fusedyy=((RFIDyy*1+(fusedy*PixXMeter*1)));  
                        }
                        
                        
                        if (filteringMethod == 2) {
                            
                            fusedxx=((RFIDxx*1+(fusedx*PixXMeter*1)));
                            fusedyy=((RFIDyy*1+(fusedy*PixXMeter*1)));
                        }

						
                        
						[fusedinitialPosition setCenter:CGPointMake(fusedxx, fusedyy)];
						prevTag=currentTag;
					}else if (rangeTwenty.location != NSNotFound) {
						NSLog(@"I found something $20$.", rangeTwenty.location);
						currentTag=21;
						RFIDxx = 216;
						RFIDyy = 120;
						
						[RFIDinitialPosition setCenter:CGPointMake(RFIDxx, RFIDyy)];
						
						/*fusedxx=(RFIDxx*1) + ((RFIDxx+(x*7.9166))*0);
						 fusedyy=(RFIDyy*1) + ((RFIDyy+(y*7.9166))*0);*/
						
                        if(currentTag != prevTag){
							fusedx=0;
							fusedy=0;
							//flag11=2;
                            posPDRTOFUSED=0;
						}
						
                        
                        if(filteringMethod == 0){
                            
                            errorRFIDx=1;
                            errorRFIDy=1;
                            errorPDRx=0.05*posPDRTOFUSED;
                            errorPDRy=0.05*posPDRTOFUSED;
                            
                            K1x=(errorPDRx/(errorPDRx+errorRFIDx));
                            K2x=(errorRFIDx/(errorPDRx+errorRFIDx));
                            
                            K1y=(errorPDRy/(errorPDRy+errorRFIDy));
                            K2y=(errorRFIDy/(errorPDRy+errorRFIDy));
                            
                            //use K1 and K2 to calculate the fused (RFID + PDR) position
                            
                            xStartFused = RFIDxx;
                            yStartFused = RFIDyy;
                            
                            xFusedCalc = xStartFused + (fusedx*PixXMeter);
                            yFusedCalc = yStartFused + (fusedy*PixXMeter);
                            
                            fusedxx=((RFIDxx*K1x+(xFusedCalc*K2x)));
                            fusedyy=((RFIDyy*K1y+(yFusedCalc*K2y)));
                            
                            
                        }
                        
                        
                        if (filteringMethod == 1) {
                            fusedxx=((RFIDxx*1+(fusedx*PixXMeter*1)));
                            fusedyy=((RFIDyy*1+(fusedy*PixXMeter*1)));  
                        }
                        
                        
                        if (filteringMethod == 2) {
                            
                            fusedxx=((RFIDxx*1+(fusedx*PixXMeter*1)));
                            fusedyy=((RFIDyy*1+(fusedy*PixXMeter*1)));
                        }

                        
						[fusedinitialPosition setCenter:CGPointMake(fusedxx, fusedyy)];
					    prevTag=currentTag;	
					}else if (rangeTwentyone.location != NSNotFound) {
						NSLog(@"I found something $21$.", rangeTwentyone.location);
						currentTag=22;
						RFIDxx = 314;
						RFIDyy = 120;
						
						[RFIDinitialPosition setCenter:CGPointMake(RFIDxx, RFIDyy)];
						
						/*fusedxx=(RFIDxx*1) + ((RFIDxx+(x*7.9166))*0);
						 fusedyy=(RFIDyy*1) + ((RFIDyy+(y*7.9166))*0);*/
						
						
                        if(currentTag != prevTag){
							fusedx=0;
							fusedy=0;
							//flag11=2;
                            posPDRTOFUSED=0;
						}
						
                        
                        if(filteringMethod == 0){
                            
                            errorRFIDx=1;
                            errorRFIDy=1;
                            errorPDRx=0.05*posPDRTOFUSED;
                            errorPDRy=0.05*posPDRTOFUSED;
                            
                            K1x=(errorPDRx/(errorPDRx+errorRFIDx));
                            K2x=(errorRFIDx/(errorPDRx+errorRFIDx));
                            
                            K1y=(errorPDRy/(errorPDRy+errorRFIDy));
                            K2y=(errorRFIDy/(errorPDRy+errorRFIDy));
                            
                            //use K1 and K2 to calculate the fused (RFID + PDR) position
                            
                            xStartFused = RFIDxx;
                            yStartFused = RFIDyy;
                            
                            xFusedCalc = xStartFused + (fusedx*PixXMeter);
                            yFusedCalc = yStartFused + (fusedy*PixXMeter);
                            
                            fusedxx=((RFIDxx*K1x+(xFusedCalc*K2x)));
                            fusedyy=((RFIDyy*K1y+(yFusedCalc*K2y)));
                            
                            
                        }
                        
                        
                        if (filteringMethod == 1) {
                            fusedxx=((RFIDxx*1+(fusedx*PixXMeter*1)));
                            fusedyy=((RFIDyy*1+(fusedy*PixXMeter*1)));  
                        }
                        
                        
                        if (filteringMethod == 2) {
                            
                            fusedxx=((RFIDxx*1+(fusedx*PixXMeter*1)));
                            fusedyy=((RFIDyy*1+(fusedy*PixXMeter*1)));
                        }

                        
						[fusedinitialPosition setCenter:CGPointMake(fusedxx, fusedyy)];
					    prevTag=currentTag;
					}else if (rangeTwentytwo.location != NSNotFound) {
						NSLog(@"I found something $22$.", rangeTwentytwo.location);
						currentTag=23;
						RFIDxx = 410;
						RFIDyy = 120;
						
						[RFIDinitialPosition setCenter:CGPointMake(RFIDxx, RFIDyy)];
						
						/*fusedxx=(RFIDxx*1) + ((RFIDxx+(x*7.9166))*0);
						 fusedyy=(RFIDyy*1) + ((RFIDyy+(y*7.9166))*0);*/
						
						
						if(currentTag != prevTag){
							fusedx=0;
							fusedy=0;
							//flag11=2;
                            posPDRTOFUSED=0;
						}
						
                        
                        if(filteringMethod == 0){
                            
                            errorRFIDx=1;
                            errorRFIDy=1;
                            errorPDRx=0.05*posPDRTOFUSED;
                            errorPDRy=0.05*posPDRTOFUSED;
                            
                            K1x=(errorPDRx/(errorPDRx+errorRFIDx));
                            K2x=(errorRFIDx/(errorPDRx+errorRFIDx));
                            
                            K1y=(errorPDRy/(errorPDRy+errorRFIDy));
                            K2y=(errorRFIDy/(errorPDRy+errorRFIDy));
                            
                            //use K1 and K2 to calculate the fused (RFID + PDR) position
                            
                            xStartFused = RFIDxx;
                            yStartFused = RFIDyy;
                            
                            xFusedCalc = xStartFused + (fusedx*PixXMeter);
                            yFusedCalc = yStartFused + (fusedy*PixXMeter);
                            
                            fusedxx=((RFIDxx*K1x+(xFusedCalc*K2x)));
                            fusedyy=((RFIDyy*K1y+(yFusedCalc*K2y)));
                            
                            
                        }
                        
                        
                        if (filteringMethod == 1) {
                            fusedxx=((RFIDxx*1+(fusedx*PixXMeter*1)));
                            fusedyy=((RFIDyy*1+(fusedy*PixXMeter*1)));  
                        }
                        
                        
                        if (filteringMethod == 2) {
                            
                            fusedxx=((RFIDxx*1+(fusedx*PixXMeter*1)));
                            fusedyy=((RFIDyy*1+(fusedy*PixXMeter*1)));
                        }

                        
                        
						[fusedinitialPosition setCenter:CGPointMake(fusedxx, fusedyy)];
						prevTag=currentTag;
					}else if (rangeTwentythree.location != NSNotFound) {
						NSLog(@"I found something $23$.", rangeTwentythree.location);
						currentTag=24;
						RFIDxx = 456;
						RFIDyy = 120;
						
						[RFIDinitialPosition setCenter:CGPointMake(RFIDxx, RFIDyy)];
						
						/*fusedxx=(RFIDxx*1) + ((RFIDxx+(x*7.9166))*0);
						 fusedyy=(RFIDyy*1) + ((RFIDyy+(y*7.9166))*0);*/
						
						if(currentTag != prevTag){
							fusedx=0;
							fusedy=0;
							//flag11=2;
                            posPDRTOFUSED=0;
						}
						
                        
                        if(filteringMethod == 0){
                            
                            errorRFIDx=1;
                            errorRFIDy=1;
                            errorPDRx=0.05*posPDRTOFUSED;
                            errorPDRy=0.05*posPDRTOFUSED;
                            
                            K1x=(errorPDRx/(errorPDRx+errorRFIDx));
                            K2x=(errorRFIDx/(errorPDRx+errorRFIDx));
                            
                            K1y=(errorPDRy/(errorPDRy+errorRFIDy));
                            K2y=(errorRFIDy/(errorPDRy+errorRFIDy));
                            
                            //use K1 and K2 to calculate the fused (RFID + PDR) position
                            
                            xStartFused = RFIDxx;
                            yStartFused = RFIDyy;
                            
                            xFusedCalc = xStartFused + (fusedx*PixXMeter);
                            yFusedCalc = yStartFused + (fusedy*PixXMeter);
                            
                            fusedxx=((RFIDxx*K1x+(xFusedCalc*K2x)));
                            fusedyy=((RFIDyy*K1y+(yFusedCalc*K2y)));
                            
                            
                        }
                        
                        
                        if (filteringMethod == 1) {
                            fusedxx=((RFIDxx*1+(fusedx*PixXMeter*1)));
                            fusedyy=((RFIDyy*1+(fusedy*PixXMeter*1)));  
                        }
                        
                        
                        if (filteringMethod == 2) {
                            
                            fusedxx=((RFIDxx*1+(fusedx*PixXMeter*1)));
                            fusedyy=((RFIDyy*1+(fusedy*PixXMeter*1)));
                        }

                        
                        
						[fusedinitialPosition setCenter:CGPointMake(fusedxx, fusedyy)];
						prevTag=currentTag;
					}else if (rangeTwentyfour.location != NSNotFound) {
						NSLog(@"I found something $24$.", rangeTwentyfour.location);
						currentTag=25;
						RFIDxx = 502;
						RFIDyy = 120;
						
						[RFIDinitialPosition setCenter:CGPointMake(RFIDxx, RFIDyy)];
						
						/*fusedxx=(RFIDxx*1) + ((RFIDxx+(x*7.9166))*0);
						 fusedyy=(RFIDyy*1) + ((RFIDyy+(y*7.9166))*0);*/
						
						if(currentTag != prevTag){
							fusedx=0;
							fusedy=0;
							//flag11=2;
                            posPDRTOFUSED=0;
						}
						
                        
                        if(filteringMethod == 0){
                            
                            errorRFIDx=1;
                            errorRFIDy=1;
                            errorPDRx=0.05*posPDRTOFUSED;
                            errorPDRy=0.05*posPDRTOFUSED;
                            
                            K1x=(errorPDRx/(errorPDRx+errorRFIDx));
                            K2x=(errorRFIDx/(errorPDRx+errorRFIDx));
                            
                            K1y=(errorPDRy/(errorPDRy+errorRFIDy));
                            K2y=(errorRFIDy/(errorPDRy+errorRFIDy));
                            
                            //use K1 and K2 to calculate the fused (RFID + PDR) position
                            
                            xStartFused = RFIDxx;
                            yStartFused = RFIDyy;
                            
                            xFusedCalc = xStartFused + (fusedx*PixXMeter);
                            yFusedCalc = yStartFused + (fusedy*PixXMeter);
                            
                            fusedxx=((RFIDxx*K1x+(xFusedCalc*K2x)));
                            fusedyy=((RFIDyy*K1y+(yFusedCalc*K2y)));
                            
                            
                        }
                        
                        
                        if (filteringMethod == 1) {
                            fusedxx=((RFIDxx*1+(fusedx*PixXMeter*1)));
                            fusedyy=((RFIDyy*1+(fusedy*PixXMeter*1)));  
                        }
                        
                        
                        if (filteringMethod == 2) {
                            
                            fusedxx=((RFIDxx*1+(fusedx*PixXMeter*1)));
                            fusedyy=((RFIDyy*1+(fusedy*PixXMeter*1)));
                        }

                        
                        
						[fusedinitialPosition setCenter:CGPointMake(fusedxx, fusedyy)];
					    prevTag=currentTag;	
					}else if (rangeTwentyfive.location != NSNotFound) {
						NSLog(@"I found something $25$.", rangeTwentyfive.location);
						currentTag=26;
						RFIDxx = 550;
						RFIDyy = 121;
						
						[RFIDinitialPosition setCenter:CGPointMake(RFIDxx, RFIDyy)];
						
						/*fusedxx=(RFIDxx*1) + ((RFIDxx+(x*7.9166))*0);
						 fusedyy=(RFIDyy*1) + ((RFIDyy+(y*7.9166))*0);*/
						
						if(currentTag != prevTag){
							fusedx=0;
							fusedy=0;
							//flag11=2;
                            posPDRTOFUSED=0;
						}
						
                        
                        if(filteringMethod == 0){
                            
                            errorRFIDx=1;
                            errorRFIDy=1;
                            errorPDRx=0.05*posPDRTOFUSED;
                            errorPDRy=0.05*posPDRTOFUSED;
                            
                            K1x=(errorPDRx/(errorPDRx+errorRFIDx));
                            K2x=(errorRFIDx/(errorPDRx+errorRFIDx));
                            
                            K1y=(errorPDRy/(errorPDRy+errorRFIDy));
                            K2y=(errorRFIDy/(errorPDRy+errorRFIDy));
                            
                            //use K1 and K2 to calculate the fused (RFID + PDR) position
                            
                            xStartFused = RFIDxx;
                            yStartFused = RFIDyy;
                            
                            xFusedCalc = xStartFused + (fusedx*PixXMeter);
                            yFusedCalc = yStartFused + (fusedy*PixXMeter);
                            
                            fusedxx=((RFIDxx*K1x+(xFusedCalc*K2x)));
                            fusedyy=((RFIDyy*K1y+(yFusedCalc*K2y)));
                            
                            
                        }
                        
                        
                        if (filteringMethod == 1) {
                            fusedxx=((RFIDxx*1+(fusedx*PixXMeter*1)));
                            fusedyy=((RFIDyy*1+(fusedy*PixXMeter*1)));  
                        }
                        
                        
                        if (filteringMethod == 2) {
                            
                            fusedxx=((RFIDxx*1+(fusedx*PixXMeter*1)));
                            fusedyy=((RFIDyy*1+(fusedy*PixXMeter*1)));
                        }

						
                        [fusedinitialPosition setCenter:CGPointMake(fusedxx, fusedyy)];
					    prevTag=currentTag;	
					}else if (rangeTwentysix.location != NSNotFound) {
						NSLog(@"I found something $26$.", rangeTwentysix.location);
						currentTag=27;
						RFIDxx = 104;
						RFIDyy = 281;
						
						[RFIDinitialPosition setCenter:CGPointMake(RFIDxx, RFIDyy)];
						
						/*fusedxx=(RFIDxx*1) + ((RFIDxx+(x*7.9166))*0);
						 fusedyy=(RFIDyy*1) + ((RFIDyy+(y*7.9166))*0);*/
						
						
						if(currentTag != prevTag){
							fusedx=0;
							fusedy=0;
							//flag11=2;
                            posPDRTOFUSED=0;
						}
						
                        
                        if(filteringMethod == 0){
                            
                            errorRFIDx=1;
                            errorRFIDy=1;
                            errorPDRx=0.05*posPDRTOFUSED;
                            errorPDRy=0.05*posPDRTOFUSED;
                            
                            K1x=(errorPDRx/(errorPDRx+errorRFIDx));
                            K2x=(errorRFIDx/(errorPDRx+errorRFIDx));
                            
                            K1y=(errorPDRy/(errorPDRy+errorRFIDy));
                            K2y=(errorRFIDy/(errorPDRy+errorRFIDy));
                            
                            //use K1 and K2 to calculate the fused (RFID + PDR) position
                            
                            xStartFused = RFIDxx;
                            yStartFused = RFIDyy;
                            
                            xFusedCalc = xStartFused + (fusedx*PixXMeter);
                            yFusedCalc = yStartFused + (fusedy*PixXMeter);
                            
                            fusedxx=((RFIDxx*K1x+(xFusedCalc*K2x)));
                            fusedyy=((RFIDyy*K1y+(yFusedCalc*K2y)));
                            
                            
                        }
                        
                        
                        if (filteringMethod == 1) {
                            fusedxx=((RFIDxx*1+(fusedx*PixXMeter*1)));
                            fusedyy=((RFIDyy*1+(fusedy*PixXMeter*1)));  
                        }
                        
                        
                        if (filteringMethod == 2) {
                            
                            fusedxx=((RFIDxx*1+(fusedx*PixXMeter*1)));
                            fusedyy=((RFIDyy*1+(fusedy*PixXMeter*1)));
                        }

                        
                        
						[fusedinitialPosition setCenter:CGPointMake(fusedxx, fusedyy)];
					    prevTag=currentTag;	
					}else if (rangeTwentyseven.location != NSNotFound) {
						NSLog(@"I found something $27$.", rangeTwentyseven.location);
						currentTag=28;
						RFIDxx = 104;
						RFIDyy = 233;
						
						[RFIDinitialPosition setCenter:CGPointMake(RFIDxx, RFIDyy)];
						
						/*fusedxx=(RFIDxx*1) + ((RFIDxx+(x*7.9166))*0);
						 fusedyy=(RFIDyy*1) + ((RFIDyy+(y*7.9166))*0);*/
						
						
                        if(currentTag != prevTag){
							fusedx=0;
							fusedy=0;
							//flag11=2;
                            posPDRTOFUSED=0;
						}
						
                        
                        if(filteringMethod == 0){
                            
                            errorRFIDx=1;
                            errorRFIDy=1;
                            errorPDRx=0.05*posPDRTOFUSED;
                            errorPDRy=0.05*posPDRTOFUSED;
                            
                            K1x=(errorPDRx/(errorPDRx+errorRFIDx));
                            K2x=(errorRFIDx/(errorPDRx+errorRFIDx));
                            
                            K1y=(errorPDRy/(errorPDRy+errorRFIDy));
                            K2y=(errorRFIDy/(errorPDRy+errorRFIDy));
                            
                            //use K1 and K2 to calculate the fused (RFID + PDR) position
                            
                            xStartFused = RFIDxx;
                            yStartFused = RFIDyy;
                            
                            xFusedCalc = xStartFused + (fusedx*PixXMeter);
                            yFusedCalc = yStartFused + (fusedy*PixXMeter);
                            
                            fusedxx=((RFIDxx*K1x+(xFusedCalc*K2x)));
                            fusedyy=((RFIDyy*K1y+(yFusedCalc*K2y)));
                            
                            
                        }
                        
                        
                        if (filteringMethod == 1) {
                            fusedxx=((RFIDxx*1+(fusedx*PixXMeter*1)));
                            fusedyy=((RFIDyy*1+(fusedy*PixXMeter*1)));  
                        }
                        
                        
                        if (filteringMethod == 2) {
                            
                            fusedxx=((RFIDxx*1+(fusedx*PixXMeter*1)));
                            fusedyy=((RFIDyy*1+(fusedy*PixXMeter*1)));
                        }

                        
						[fusedinitialPosition setCenter:CGPointMake(fusedxx, fusedyy)];
					    prevTag=currentTag;	
					}else if (rangeTwentyeight.location != NSNotFound) {
						NSLog(@"I found something $28$.", rangeTwentyeight.location);
						currentTag=29;
						RFIDxx = 444;
						RFIDyy = 154;
						
						[RFIDinitialPosition setCenter:CGPointMake(RFIDxx, RFIDyy)];
						
						/*fusedxx=(RFIDxx*1) + ((RFIDxx+(x*7.9166))*0);
						 fusedyy=(RFIDyy*1) + ((RFIDyy+(y*7.9166))*0);*/
						
                        if(currentTag != prevTag){
							fusedx=0;
							fusedy=0;
							//flag11=2;
                            posPDRTOFUSED=0;
						}
						
                        
                        if(filteringMethod == 0){
                            
                            errorRFIDx=1;
                            errorRFIDy=1;
                            errorPDRx=0.05*posPDRTOFUSED;
                            errorPDRy=0.05*posPDRTOFUSED;
                            
                            K1x=(errorPDRx/(errorPDRx+errorRFIDx));
                            K2x=(errorRFIDx/(errorPDRx+errorRFIDx));
                            
                            K1y=(errorPDRy/(errorPDRy+errorRFIDy));
                            K2y=(errorRFIDy/(errorPDRy+errorRFIDy));
                            
                            //use K1 and K2 to calculate the fused (RFID + PDR) position
                            
                            xStartFused = RFIDxx;
                            yStartFused = RFIDyy;
                            
                            xFusedCalc = xStartFused + (fusedx*PixXMeter);
                            yFusedCalc = yStartFused + (fusedy*PixXMeter);
                            
                            fusedxx=((RFIDxx*K1x+(xFusedCalc*K2x)));
                            fusedyy=((RFIDyy*K1y+(yFusedCalc*K2y)));
                            
                            
                        }
                        
                        
                        if (filteringMethod == 1) {
                            fusedxx=((RFIDxx*1+(fusedx*PixXMeter*1)));
                            fusedyy=((RFIDyy*1+(fusedy*PixXMeter*1)));  
                        }
                        
                        
                        if (filteringMethod == 2) {
                            
                            fusedxx=((RFIDxx*1+(fusedx*PixXMeter*1)));
                            fusedyy=((RFIDyy*1+(fusedy*PixXMeter*1)));
                        }

						
						
                        [fusedinitialPosition setCenter:CGPointMake(fusedxx, fusedyy)];
					    prevTag=currentTag;  	
					}else if (rangeTwentynine.location != NSNotFound) {
						NSLog(@"I found something $29$.", rangeTwentynine.location);
						currentTag=30;
						RFIDxx = 464;
						RFIDyy = 156;
						
						[RFIDinitialPosition setCenter:CGPointMake(RFIDxx, RFIDyy)];
						
						/*fusedxx=(RFIDxx*1) + ((RFIDxx+(x*7.9166))*0);
						 fusedyy=(RFIDyy*1) + ((RFIDyy+(y*7.9166))*0);*/
						
						
                        if(currentTag != prevTag){
							fusedx=0;
							fusedy=0;
							//flag11=2;
                            posPDRTOFUSED=0;
						}
						
                        
                        if(filteringMethod == 0){
                            
                            errorRFIDx=1;
                            errorRFIDy=1;
                            errorPDRx=0.05*posPDRTOFUSED;
                            errorPDRy=0.05*posPDRTOFUSED;
                            
                            K1x=(errorPDRx/(errorPDRx+errorRFIDx));
                            K2x=(errorRFIDx/(errorPDRx+errorRFIDx));
                            
                            K1y=(errorPDRy/(errorPDRy+errorRFIDy));
                            K2y=(errorRFIDy/(errorPDRy+errorRFIDy));
                            
                            //use K1 and K2 to calculate the fused (RFID + PDR) position
                            
                            xStartFused = RFIDxx;
                            yStartFused = RFIDyy;
                            
                            xFusedCalc = xStartFused + (fusedx*PixXMeter);
                            yFusedCalc = yStartFused + (fusedy*PixXMeter);
                            
                            fusedxx=((RFIDxx*K1x+(xFusedCalc*K2x)));
                            fusedyy=((RFIDyy*K1y+(yFusedCalc*K2y)));
                            
                            
                        }
                        
                        
                        if (filteringMethod == 1) {
                            fusedxx=((RFIDxx*1+(fusedx*PixXMeter*1)));
                            fusedyy=((RFIDyy*1+(fusedy*PixXMeter*1)));  
                        }
                        
                        
                        if (filteringMethod == 2) {
                            
                            fusedxx=((RFIDxx*1+(fusedx*PixXMeter*1)));
                            fusedyy=((RFIDyy*1+(fusedy*PixXMeter*1)));
                        }

                        
						[fusedinitialPosition setCenter:CGPointMake(fusedxx, fusedyy)];
						prevTag=currentTag;
				
						
					}else{
							
							
						/*fusedxx=(RFIDxx*0) + ((RFIDxx+(x*7.9166))*1);
						fusedyy=(RFIDyy*0) + ((RFIDyy+(y*7.9166))*1);*/
						
                        
                        /*xStartFused = RFIDxx;
                        yStartFused = RFIDyy;
                        
                        xFusedCalc = xStartFused + fusedx;
                        yFusedCalc = yStartFused + fusedy;*/
                        
						//fusedxx=(((RFIDxx)+(fusedx*7.9166)));
						//fusedyy=(((RFIDyy)+(fusedy*7.9166)));
                        
                      
						
                        
                        if(filteringMethod == 0){
                            
                            errorRFIDx=1;
                            errorRFIDy=1;
                            errorPDRx=0.05*posPDRTOFUSED;
                            errorPDRy=0.05*posPDRTOFUSED;
                            
                            K1x=(errorPDRx/(errorPDRx+errorRFIDx));
                            K2x=(errorRFIDx/(errorPDRx+errorRFIDx));
                            
                            K1y=(errorPDRy/(errorPDRy+errorRFIDy));
                            K2y=(errorRFIDy/(errorPDRy+errorRFIDy));
                            
                            //use K1 and K2 to calculate the fused (RFID + PDR) position
                            
                            xStartFused = RFIDxx;
                            yStartFused = RFIDyy;
                            
                            xFusedCalc = xStartFused + (fusedx*PixXMeter);
                            yFusedCalc = yStartFused + (fusedy*PixXMeter);
                            
                            fusedxx=((RFIDxx*K1x+(xFusedCalc*K2x)));
                            fusedyy=((RFIDyy*K1y+(yFusedCalc*K2y)));
                            
                            
                        }
                        
                        
                        if (filteringMethod == 1) {
                            fusedxx=((RFIDxx*1+(fusedx*PixXMeter*1)));
                            fusedyy=((RFIDyy*1+(fusedy*PixXMeter*1)));  
                        }
                        
                        
                        if (filteringMethod == 2) {
                            
                            fusedxx=((RFIDxx*1+(fusedx*PixXMeter*1)));
                            fusedyy=((RFIDyy*1+(fusedy*PixXMeter*1)));
                        }

                        
                        
						[fusedinitialPosition setCenter:CGPointMake(fusedxx, fusedyy)];
						
						}
					
					tagLabel.text= [NSString stringWithFormat:@"%.2d", currentTag];
	

						/*NSString *searchZero = @"O";
						NSRange rangeZero = [RFIDString rangeOfString : searchZero];
						
						NSString *searchOne = @"3";
						NSRange rangeOne = [RFIDString rangeOfString : searchOne];
						
						NSString *searchTwo = @"ÿ";
						NSRange rangeTwo = [RFIDString rangeOfString : searchTwo];
					
					    NSString *searchThree = @"A";
					    NSRange rangeThree = [RFIDString rangeOfString : searchThree];
					
					    NSString *searchThree = @"¤";
					    NSRange rangeThree = [RFIDString rangeOfString : searchThree];*/
					
					
                    /*int ARFID;
                    
                    ARFID = [RFIDString intValue];
                    
                    mTextSend.text= [NSString stringWithFormat:@"%.3d", ARFID];*/
                    
                    
                    /*+(NSString*)intToHexString:(NSInteger)value
                    {
                        return [[NSString alloc] initWithFormat:@"%lX", value];
                    }
                Using:
                    NSLog([MyClass intToHexString:0x7282]);
                Output:
                    7282*/ // this is a function to convert a hex to string
                    
                    //RFIDString = [[NSString alloc] initWithFormat:@"%lX", ARFID];
                    
               
		
						
							
			
				//RFIDTextField.text=@"Tag";
								
				
		
				
				/*if([RFIDString isEqualToString:@"$00$"]){
					
					RFIDxx = 200;
					RFIDyy = 200;
					
				} else if ([RFIDString isEqualToString:@"$01$"]) {
					RFIDxx = 300;
					RFIDyy = 300;
					
				} else if ([RFIDString isEqualToString:@"$03$"]) {
					RFIDxx = 400;
					RFIDyy = 400;
					
				}else {
					RFIDxx = 0;
					RFIDyy = 0;
				}*/
				
				//[fusedinitialPosition setCenter:CGPointMake(((RFIDxx*0.7)+(xx*0.3)), ((RFIDyy*0.7)+(yy*0.3)) )];
				
				[RFIDinitialPosition setCenter:CGPointMake(RFIDxx, RFIDyy)];
				
				
				//if((xx>-10) && (xx<330) && (yy>170) && (yy<470)){
					[initialPosition setCenter:CGPointMake(xx, 
														   yy)];
					
					
				//}
				
			
				ratioZoomX = (scroll.contentSize.width/imageViewRect.size.width);
				ratioZoomY = (scroll.contentSize.height/imageViewRect.size.height);
				
				if (FUSEDSwitch.on) {
					//center scroll in fusedinitialPosition
					//[scroll setCenter:CGPointMake(fusedinitialPosition.center.x, fusedinitialPosition.center.y)];
				    [scroll setContentOffset:CGPointMake(-159*1 + (fusedinitialPosition.center.x*ratioZoomX), -120 + (fusedinitialPosition.center.y*ratioZoomY)) animated:YES];
			        
					
					
				}else if(PDRSwitch.on){
				    //center scroll in initalPosition
					//[scroll setCenter:CGPointMake(initialPosition.center.x, initialPosition.center.y)];
				[scroll setContentOffset:CGPointMake(-159*1 + (initialPosition.center.x*ratioZoomX), -120 + (initialPosition.center.y*ratioZoomY)) animated:YES];
                   
				}else if(RFIDSwitch.on){
				    //center scroll in RFIDinitialPosition
					//[scroll setCenter:CGPointMake(RFIDinitialPosition.center.x, RFIDinitialPosition.center.y)];
					[scroll setContentOffset:CGPointMake(-159*1 + (RFIDinitialPosition.center.x*ratioZoomX), -120 + (RFIDinitialPosition.center.y*ratioZoomY)) animated:YES];
                  
				} /*else{
				
					// if nothing is selected use fusedinitialPosition to center the scroll
					//[scroll setCenter:CGPointMake(fusedinitialPosition.center.x, fusedinitialPosition.center.y)];
					[scroll setContentOffset:CGPointMake(-159*1 + fusedinitialPosition.center.x, -101.5*1 + fusedinitialPosition.center.y) animated:YES];

				}*/
				
	
					
				
                if (PrevPosSwitch.on) {
                    [m_cadView setVal1:xStart - offsetImagePixelsX setVal2:yStart - offsetImagePixelsY setVal3:initialPosition.center.x - offsetImagePixelsX setVal4:initialPosition.center.y - offsetImagePixelsY setVal5:RFIDinitialPosition.center.x - offsetImagePixelsX setVal6:RFIDinitialPosition.center.y - offsetImagePixelsY setVal7:fusedinitialPosition.center.x - offsetImagePixelsX setVal8:fusedinitialPosition.center.y - offsetImagePixelsY setVal9:steps setVal10:initialBOOL setVal11:RFIDBOOL setVal12:fusedBOOL setVal13:degImage];
                    
                    
                    
                    [m_cadView setNeedsDisplay];
                }
                
          
				
				initialPositionLabel.text = [NSString stringWithFormat:@"%.2f", ((initialPosition.center.x)/(PixXMeter))];
				secondPositionLabel.text = [NSString stringWithFormat:@"%.2f", ((initialPosition.center.y)/(PixXMeter))];
				
				RFIDinitialPositionLabel.text = [NSString stringWithFormat:@"%.2f", ((RFIDinitialPosition.center.x)/(PixXMeter))];
				RFIDsecondPositionLabel.text = [NSString stringWithFormat:@"%.2f", ((RFIDinitialPosition.center.y)/(PixXMeter))];
				
				fusedinitialPositionLabel.text = [NSString stringWithFormat:@"%.2f", ((fusedinitialPosition.center.x)/(PixXMeter))];
				fusedsecondPositionLabel.text = [NSString stringWithFormat:@"%.2f", ((fusedinitialPosition.center.y)/(PixXMeter))];
				
				
				
				
			/*	if((xx>-10) && (xx<330) && (yy>170) && (yy<470)){
			[initialPosition setCenter:CGPointMake(xx, 
												   yy)];
					
					/*[secondPosition setCenter:CGPointMake(posArr[0], posArr[1])];
					
					[tPosition setCenter:CGPointMake(posArr[2], posArr[3])];
					
					[fPosition setCenter:CGPointMake(posArr[4], posArr[5])];
					
					[fiPosition setCenter:CGPointMake(posArr[6], posArr[7])];
					
					[sPosition setCenter:CGPointMake(posArr[8], posArr[9])];
					
					[sePosition setCenter:CGPointMake(posArr[10], posArr[11])];
					
					[ePosition setCenter:CGPointMake(posArr[12], posArr[13])];
					
					[nPosition setCenter:CGPointMake(posArr[14], posArr[15])];
					
					[tePosition setCenter:CGPointMake(posArr[16], posArr[17])];
					
					[elPosition setCenter:CGPointMake(posArr[18], posArr[19])];
					
					
					/*[m_mainView setVal1:posArr[0] setVal2:posArr[1] setVal3:initialPosition.center.x setVal4:initialPosition.center.y setVal5:steps];
					[m_mainView setVal1:posArr[2] setVal2:posArr[3] setVal3:initialPosition.center.x setVal4:initialPosition.center.y setVal5:steps];
					[m_mainView setVal1:posArr[4] setVal2:posArr[5] setVal3:initialPosition.center.x setVal4:initialPosition.center.y setVal5:steps];
					[m_mainView setVal1:posArr[6] setVal2:posArr[7] setVal3:initialPosition.center.x setVal4:initialPosition.center.y setVal5:steps];
					[m_mainView setVal1:posArr[8] setVal2:posArr[9] setVal3:initialPosition.center.x setVal4:initialPosition.center.y setVal5:steps];
					[m_mainView setVal1:posArr[10] setVal2:posArr[11] setVal3:initialPosition.center.x setVal4:initialPosition.center.y setVal5:steps];
					[m_mainView setVal1:posArr[12] setVal2:posArr[13] setVal3:initialPosition.center.x setVal4:initialPosition.center.y setVal5:steps];
					[m_mainView setVal1:posArr[14] setVal2:posArr[15] setVal3:initialPosition.center.x setVal4:initialPosition.center.y setVal5:steps];
					[m_mainView setVal1:posArr[16] setVal2:posArr[17] setVal3:initialPosition.center.x setVal4:initialPosition.center.y setVal5:steps];
					[m_mainView setVal1:posArr[18] setVal2:posArr[19] setVal3:initialPosition.center.x setVal4:initialPosition.center.y setVal5:steps];
                    */
					
					/*}
				
				[m_cadView setVal1:xStart setVal2:yStart setVal3:initialPosition.center.x setVal4:initialPosition.center.y setVal5:steps];
			
				[m_cadView setNeedsDisplay];*/
												   
		    }
			
			//if(steps>10){
			
			//[m_mainView setVal1:posArr[(steps*2)-2] setVal2:posArr[((steps*2)+1)-2] setVal3:posArr[(steps*2)] setVal4:posArr[(steps*2)+1]];
			//[m_mainView setNeedsDisplay];
				
				//**[m_mainView setVal1:posArr[(steps*2)-2] setVal2:posArr[((steps*2)+1)-2] setVal3:initialPosition.center.x setVal4:initialPosition.center.y setVal5:steps];
				//**[m_mainView setNeedsDisplay];
			
				//[m_mainView setVal1:160 setVal2:260 setVal3:initialPosition.center.x setVal4:initialPosition.center.y];
				//[m_mainView setNeedsDisplay];	
				
			// }
				
				
			//[m_mainView setVal1:68.0 setVal2:409.0 setVal3:248.0 setVal4:393.0];
		    //[m_mainView setNeedsDisplay];
			
			/*
			if(steps == 1){
			
				[m_mainView setVal1:posArr[steps-1] setVal2:posArr[steps] setVal3:initialPosition.center.x setVal4:initialPosition.center.y];
				[m_mainView setNeedsDisplay];
			}
			
			
			if(steps == 5){
				
				[m_mainView setVal1:posArr[steps-1] setVal2:posArr[steps] setVal3:initialPosition.center.x setVal4:initialPosition.center.y];
				[m_mainView setNeedsDisplay];
			}
			
			if(steps == 10){
				
				[m_mainView setVal1:posArr[steps-1] setVal2:posArr[steps] setVal3:initialPosition.center.x setVal4:initialPosition.center.y];
				[m_mainView setNeedsDisplay];
			}
			/* 
			 
			 
			
			/*
			[m_mainView setVal1: posArr[((2*steps)- 2)] setVal2: posArr[(((2*steps)+1)-2)] setVal3: posArr[(2*steps)] setVal4:posArr[((2*steps)+1)]];
			
			[m_mainView setNeedsDisplay];
			
			/*CGContextRef context = UIGraphicsGetCurrentContext();
			CGContextSetRGBStrokeColor(context, 1.0, 0, 0, 1);
			CGContextSetLineWidth(context, 5.0);
			CGContextMoveToPoint(context, posArr[(2*steps)-(2*steps)], posArr[((2*steps)+1) - ((2*steps)+1)]);
			CGContextAddLineToPoint(context, (2*steps), ((2*steps)+1));
			CGContextStrokePath(context);*/
			
			
	
			
			
			/*[i12Position setCenter:CGPointMake(posArr[20], posArr[21])];
			
			[i13Position setCenter:CGPointMake(posArr[22], posArr[23])];
			
			[i14Position setCenter:CGPointMake(posArr[24], posArr[25])];
			
			[i15Position setCenter:CGPointMake(posArr[26], posArr[27])];
			
			[i16Position setCenter:CGPointMake(posArr[28], posArr[29])];
			
			[i17Position setCenter:CGPointMake(posArr[30], posArr[31])];
			
			[i18Position setCenter:CGPointMake(posArr[32], posArr[33])];
			
			[i19Position setCenter:CGPointMake(posArr[34], posArr[35])];
			
			[i20Position setCenter:CGPointMake(posArr[36], posArr[37])];
			
			[i21Position setCenter:CGPointMake(posArr[38], posArr[39])];
			
			[i22Position setCenter:CGPointMake(posArr[40], posArr[41])];
			
			[i23Position setCenter:CGPointMake(posArr[42], posArr[43])];
			
			[i24Position setCenter:CGPointMake(posArr[44], posArr[45])];
			
			[i25Position setCenter:CGPointMake(posArr[46], posArr[47])];
			
			[i26Position setCenter:CGPointMake(posArr[48], posArr[49])];
			
			[i27Position setCenter:CGPointMake(posArr[50], posArr[51])];
			
			[i28Position setCenter:CGPointMake(posArr[52], posArr[53])];
			
			[i29Position setCenter:CGPointMake(posArr[54], posArr[55])];
			
			[i30Position setCenter:CGPointMake(posArr[56], posArr[57])];
			
			/*[i31Position setCenter:CGPointMake(posArr[58], posArr[59])];
			
			[i32Position setCenter:CGPointMake(posArr[60], posArr[61])];
			
			[i33Position setCenter:CGPointMake(posArr[62], posArr[63])];
			
			[i34Position setCenter:CGPointMake(posArr[64], posArr[65])];
			
			[i35Position setCenter:CGPointMake(posArr[66], posArr[67])];
			
			[i36Position setCenter:CGPointMake(posArr[68], posArr[69])];
			
			[i37Position setCenter:CGPointMake(posArr[70], posArr[71])];
			
			[i38Position setCenter:CGPointMake(posArr[72], posArr[73])];
			
			[i39Position setCenter:CGPointMake(posArr[74], posArr[75])];
			
			[i40Position setCenter:CGPointMake(posArr[76], posArr[77])];
			
			[i41Position setCenter:CGPointMake(posArr[78], posArr[79])];
			
			[i42Position setCenter:CGPointMake(posArr[80], posArr[81])];
			
			[i43Position setCenter:CGPointMake(posArr[82], posArr[83])];
			
			[i44Position setCenter:CGPointMake(posArr[84], posArr[85])];
			
			[i45Position setCenter:CGPointMake(posArr[86], posArr[87])];
			
			[i46Position setCenter:CGPointMake(posArr[88], posArr[89])];
			
			[i47Position setCenter:CGPointMake(posArr[90], posArr[91])];
			
			[i48Position setCenter:CGPointMake(posArr[92], posArr[93])];
			
			[i49Position setCenter:CGPointMake(posArr[94], posArr[95])];
			
			[i50Position setCenter:CGPointMake(posArr[96], posArr[97])];
			
			[i51Position setCenter:CGPointMake(posArr[98], posArr[99])];
			
			/*[i52Position setCenter:CGPointMake(posArr[100], posArr[1])];
			
			[i53Position setCenter:CGPointMake(posArr[2], posArr[3])];
			
			[i54Position setCenter:CGPointMake(posArr[4], posArr[5])];
			
			[i55Position setCenter:CGPointMake(posArr[6], posArr[7])];
			
			[i56Position setCenter:CGPointMake(posArr[8], posArr[9])];
			
			[i57Position setCenter:CGPointMake(posArr[10], posArr[11])];
			
			[i58Position setCenter:CGPointMake(posArr[12], posArr[13])];
			
			[i59Position setCenter:CGPointMake(posArr[14], posArr[15])];
			
			[i60Position setCenter:CGPointMake(posArr[16], posArr[17])];
			
			[i61Position setCenter:CGPointMake(posArr[16], posArr[17])];
			
			[i62Position setCenter:CGPointMake(posArr[0], posArr[1])];
			
			[i63Position setCenter:CGPointMake(posArr[2], posArr[3])];
			
			[i64Position setCenter:CGPointMake(posArr[4], posArr[5])];
			
			[i65Position setCenter:CGPointMake(posArr[6], posArr[7])];
			
			[i66Position setCenter:CGPointMake(posArr[8], posArr[9])];
			
			[i67Position setCenter:CGPointMake(posArr[10], posArr[11])];
			
			[i68Position setCenter:CGPointMake(posArr[12], posArr[13])];
			
			[i69Position setCenter:CGPointMake(posArr[14], posArr[15])];
			
			[i70Position setCenter:CGPointMake(posArr[16], posArr[17])];
			
			[i71Position setCenter:CGPointMake(posArr[16], posArr[17])];
			
			[i72Position setCenter:CGPointMake(posArr[0], posArr[1])];
			
			[i73Position setCenter:CGPointMake(posArr[2], posArr[3])];
			
			[i74Position setCenter:CGPointMake(posArr[4], posArr[5])];
			
			[i75Position setCenter:CGPointMake(posArr[6], posArr[7])];
			
			[i76Position setCenter:CGPointMake(posArr[8], posArr[9])];
			
			[i77Position setCenter:CGPointMake(posArr[10], posArr[11])];
			
			[i78Position setCenter:CGPointMake(posArr[12], posArr[13])];
			
			[i79Position setCenter:CGPointMake(posArr[14], posArr[15])];
			
			[i80Position setCenter:CGPointMake(posArr[16], posArr[17])];
			
			[i81Position setCenter:CGPointMake(posArr[16], posArr[17])];
			
			[i82Position setCenter:CGPointMake(posArr[0], posArr[1])];
			
			[i83Position setCenter:CGPointMake(posArr[2], posArr[3])];
			
			[i84Position setCenter:CGPointMake(posArr[4], posArr[5])];
			
			[i85Position setCenter:CGPointMake(posArr[6], posArr[7])];
			
			[i86Position setCenter:CGPointMake(posArr[8], posArr[9])];
			
			[i87Position setCenter:CGPointMake(posArr[10], posArr[11])];
			
			[i88Position setCenter:CGPointMake(posArr[12], posArr[13])];
			
			[i89Position setCenter:CGPointMake(posArr[14], posArr[15])];
			
			[i90Position setCenter:CGPointMake(posArr[16], posArr[17])];
			
			[i91Position setCenter:CGPointMake(posArr[16], posArr[17])];
			
			[i92Position setCenter:CGPointMake(posArr[2], posArr[3])];
			
			[i93Position setCenter:CGPointMake(posArr[4], posArr[5])];
			
			[i94Position setCenter:CGPointMake(posArr[6], posArr[7])];
			
			[i95Position setCenter:CGPointMake(posArr[8], posArr[9])];
			
			[i96Position setCenter:CGPointMake(posArr[10], posArr[11])];
			
			[i97Position setCenter:CGPointMake(posArr[12], posArr[13])];
			
			[i98Position setCenter:CGPointMake(posArr[14], posArr[15])];
			
			[i99Position setCenter:CGPointMake(posArr[16], posArr[17])];
			
			[i100Position setCenter:CGPointMake(posArr[16], posArr[17])];
            */
			

		}
			
	} else {
		flag=1;
		steps=steps;
		stepsLabel.text= [NSString stringWithFormat:@"%.3d", steps];
	}
	
	
		
  
  // This will rotate the map as the compass heading changes. We need to put the map inside another view for
  // and deal with clipping regions I think for it to work sensibly.  Right now it spins the mapview on top 
  // of the main view which is both wrong and really ugly.
	if (rotateMap){
    [mapView setTransform:CGAffineTransformMakeRotation(-1 * newHeading.magneticHeading * 3.14159 / 180)];
	initialPosition.transform = CGAffineTransformMakeRotation(degImage * 3.14159 / 180);
	fusedinitialPosition.transform = CGAffineTransformMakeRotation(degImage * 3.14159 / 180);
	}else {
		
	}

	if (rotateMap2){
		[mapView2 setTransform:CGAffineTransformMakeRotation(-1 * newHeading.magneticHeading * 3.14159 / 180)];
		initialPosition.transform = CGAffineTransformMakeRotation(degImage * 3.14159 / 180);
		fusedinitialPosition.transform = CGAffineTransformMakeRotation(degImage * 3.14159 / 180);
	}else{
	
	}
}



#pragma mark Action Methods
- (IBAction)toggleCoreLocation{
  if (loc_service_active)
  {
    if ([locationManager headingAvailable])
      [locationManager stopUpdatingHeading];
    
    [locationManager stopUpdatingLocation];
    [currentLocation setTextColor:[UIColor redColor]];
    [currentElevation setTextColor:[UIColor redColor]];
    [currentSpeed setTextColor:[UIColor redColor]];
    [currentHeading setTextColor:[UIColor redColor]];
    loc_service_active = NO;
    NSLog(@"Stop updating Location");
    
  }
  else 
  {
    if ([locationManager headingAvailable])
      [locationManager startUpdatingHeading];
    
    [locationManager startUpdatingLocation];
    [currentLocation setTextColor:[UIColor whiteColor]];
    [currentElevation setTextColor:[UIColor whiteColor]];
    [currentSpeed setTextColor:[UIColor whiteColor]];
    [currentHeading setTextColor:[UIColor whiteColor]];
    loc_service_active = YES;
    NSLog(@"Start updating Location");    
  }
}


- (IBAction) showUserLocation
{
  MKUserLocation *annotation = mapView.userLocation;
  CLLocation *location = annotation.location;
  if (nil == location)
    return;
  
  CLLocationDistance distance = MAX(4 * location.horizontalAccuracy, 500); // meters
  MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, distance, distance);
  
  [mapView setRegion:region animated:YES];    
  [locationManager startUpdatingLocation];
}


- (IBAction) showUserLocation2
{
	MKUserLocation *annotation = mapView2.userLocation;
	CLLocation *location = annotation.location;
	if (nil == location)
		return;
	
	CLLocationDistance distance = MAX(4 * location.horizontalAccuracy, 500); // meters
	MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, distance, distance);
	
	[mapView2 setRegion:region animated:YES];    
	[locationManager startUpdatingLocation];
}



- (IBAction) toggleMapType
{
  if (mapView.mapType == MKMapTypeHybrid)
    mapView.mapType = MKMapTypeStandard;
  else
    mapView.mapType = MKMapTypeHybrid;
}


- (IBAction)toggleMapRotation 
{
  if (rotateMap){
    [mapView setTransform:CGAffineTransformMakeRotation(0)];    
	  initialPosition.transform = CGAffineTransformMakeRotation(0);
	  fusedinitialPosition.transform = CGAffineTransformMakeRotation(0);
	  rotateMap = NO;
	  

  }
  else 
    rotateMap = YES;
  NSLog(@"Changed rotateMap to %@", rotateMap ? @"YES" : @"NO");  
  
}



- (IBAction) toggleMapType2
{
	if (mapView2.mapType == MKMapTypeHybrid)
		mapView2.mapType = MKMapTypeStandard;
	else
		mapView2.mapType = MKMapTypeHybrid;
}


- (IBAction)toggleMapRotation2 
{
	if (rotateMap2){
		[mapView2 setTransform:CGAffineTransformMakeRotation(0)];  
		initialPosition.transform = CGAffineTransformMakeRotation(0);
		fusedinitialPosition.transform = CGAffineTransformMakeRotation(0);
		rotateMap2 = NO;
		
	}
	else 
		rotateMap2 = YES;
	NSLog(@"Changed rotateMap to %@", rotateMap2 ? @"YES" : @"NO");  
	
}


- (IBAction)toggleMapFollowsUser
{
  // this causes the map to follow the user around - This needs to be a toggle;
  // if it's on, the map will literally follow the user undoing any moves/drags/zooms
  // the user does.
  
  mapFollowsUser = !mapFollowsUser;
  
  if (mapFollowsUser) {    
    [mapView.userLocation addObserver:self forKeyPath:@"location" options:0 context:NULL];
    mapStatusText.text = @"Following user";
  }
  else {
    [mapView.userLocation removeObserver:self forKeyPath:@"location"];
    mapStatusText.text = @"Not following user";      
  }
  
  NSLog(@"Changed mapFollowsUser to %@", mapFollowsUser ? @"YES" : @"NO");
}

- (IBAction)resetDist {
	steps=0;
	pos=0;
	stepsLabel.text= [NSString stringWithFormat:@"%.3d", steps];
	
	posLabel.text = [NSString stringWithFormat:@"%.2f", pos];
	
	stepsLabel2.text= [NSString stringWithFormat:@"%.3d", steps];
	
	posLabel2.text = [NSString stringWithFormat:@"%.2f", pos];
	
	[initialPosition setCenter:CGPointMake(xStart, yStart)];
	x=0;
	y=0;
	fusedx=0;
	fusedy=0;
	
	/*posArr[0]= initialPosition.center.x;
	posArr[1]= initialPosition.center.y;
	posArr[2]= initialPosition.center.x;
	posArr[3]= initialPosition.center.y;
	posArr[4]= initialPosition.center.x;
	posArr[4]= initialPosition.center.y;
	posArr[6]= initialPosition.center.x;
	posArr[7]= initialPosition.center.y;
	posArr[8]= initialPosition.center.x;
	posArr[9]= initialPosition.center.y;*/
	
	
	
    
    if (PrevPosSwitch.on) {
     [m_cadView setVal1:xStart - offsetImagePixelsX setVal2:yStart - offsetImagePixelsY setVal3:initialPosition.center.x - offsetImagePixelsX setVal4:initialPosition.center.y - offsetImagePixelsY setVal5:RFIDinitialPosition.center.x - offsetImagePixelsX setVal6:RFIDinitialPosition.center.y - offsetImagePixelsY setVal7:fusedinitialPosition.center.x - offsetImagePixelsX setVal8:fusedinitialPosition.center.y - offsetImagePixelsY setVal9:steps setVal10:initialBOOL setVal11:RFIDBOOL setVal12:fusedBOOL setVal13:degImage];
        
        [m_cadView setNeedsDisplay];
    }
    
 
	
	//for(int i=0; i<100; i++) {
	//	posArr[i] = 0.0;
	//}
	

	
}

- (IBAction)resetDist2 {
	steps=0;
	pos=0;
	stepsLabel.text= [NSString stringWithFormat:@"%.3d", steps];
	
	posLabel.text = [NSString stringWithFormat:@"%.2f", pos];
	
	stepsLabel2.text= [NSString stringWithFormat:@"%.3d", steps];
	
	posLabel2.text = [NSString stringWithFormat:@"%.2f", pos];
	
	[initialPosition setCenter:CGPointMake(xStart, yStart)];
	x=0;
	y=0;
	fusedx=0;
	fusedy=0;
	
	/*for (int i=0; i<100; i++) {
		posArr[2*i] = 270.0;
		posArr[(2*i)+1] = 397.0;
	}*/
	 
	/*posArr[0]= initialPosition.center.x;
	posArr[1]= initialPosition.center.y;
	posArr[2]= initialPosition.center.x;
	posArr[3]= initialPosition.center.y;
	posArr[4]= initialPosition.center.x;
	posArr[4]= initialPosition.center.y;
	posArr[6]= initialPosition.center.x;
	posArr[7]= initialPosition.center.y;
	posArr[8]= initialPosition.center.x;
	posArr[9]= initialPosition.center.y;*/
	
	
    if (PrevPosSwitch.on) {
       [m_cadView setVal1:xStart - offsetImagePixelsX setVal2:yStart - offsetImagePixelsY setVal3:initialPosition.center.x - offsetImagePixelsX setVal4:initialPosition.center.y - offsetImagePixelsY setVal5:RFIDinitialPosition.center.x - offsetImagePixelsX setVal6:RFIDinitialPosition.center.y - offsetImagePixelsY setVal7:fusedinitialPosition.center.x - offsetImagePixelsX setVal8:fusedinitialPosition.center.y - offsetImagePixelsY setVal9:steps setVal10:initialBOOL setVal11:RFIDBOOL setVal12:fusedBOOL setVal13:degImage];
        
        [m_cadView setNeedsDisplay];
    }
    

	
}



-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [[event allTouches] anyObject];
	CGPoint locacion = [touch locationInView:touch.view];
	
	
	//if((locacion.x>-10) && (locacion.x<330) && (locacion.y>170) && (locacion.y<470)){
	locacion.x=locacion.x*2;
	locacion.y=locacion.y*2;
		initialPosition.center = locacion;	
	//}
	


	
}
 
 

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	[self touchesBegan:touches withEvent:event];
}



- (IBAction)setStart{
	
	xStart = initialPosition.center.x;
	yStart = initialPosition.center.y;
	
	
	/*posArr[0]= initialPosition.center.x;
	posArr[1]= initialPosition.center.y;
	posArr[2]= initialPosition.center.x;
	posArr[3]= initialPosition.center.y;
	posArr[4]= initialPosition.center.x;
	posArr[4]= initialPosition.center.y;
	posArr[6]= initialPosition.center.x;
	posArr[7]= initialPosition.center.y;
	posArr[8]= initialPosition.center.x;
	posArr[9]= initialPosition.center.y;*/
	
	
	if(PrevPosSwitch.on){
    
      [m_cadView setVal1:xStart - offsetImagePixelsX setVal2:yStart - offsetImagePixelsY setVal3:initialPosition.center.x - offsetImagePixelsX setVal4:initialPosition.center.y - offsetImagePixelsY setVal5:RFIDinitialPosition.center.x - offsetImagePixelsX setVal6:RFIDinitialPosition.center.y - offsetImagePixelsY setVal7:fusedinitialPosition.center.x - offsetImagePixelsX setVal8:fusedinitialPosition.center.y - offsetImagePixelsY setVal9:steps setVal10:initialBOOL setVal11:RFIDBOOL setVal12:fusedBOOL setVal13:degImage];
        
        
        [m_cadView setNeedsDisplay];
        
    }
    


	
}

- (IBAction)showImPos{
	
	initialPositionLabel.text = [NSString stringWithFormat:@"%.3f", initialPosition.center.x];
	secondPositionLabel.text = [NSString stringWithFormat:@"%.3f", initialPosition.center.y];

	
		/*CGContextRef	context = UIGraphicsGetCurrentContext();
		
		CGContextSetLineWidth(context, 5.0);
		CGContextMoveToPoint(context, 50, 100);
		CGContextAddLineToPoint(context, 200, 100);
		CGContextStrokePath(context);
		
		
		CGContextAddEllipseInRect(context, CGRectMake(70.0, 170.0, 50.0, 50.0));
		CGContextStrokePath(context);
		
		
		CGContextAddEllipseInRect(context, CGRectMake(150.0, 170.0, 50.0, 50.0));
		CGContextFillPath(context);
		
		
		CGContextSetRGBStrokeColor(context, 0.0, 1.0, 0.0, 1.0);
		CGContextSetRGBFillColor(context, 0.0, 0.0, 1.0, 1.0);
		CGContextAddRect(context, CGRectMake(30.0, 30.0, 60.0, 60.0));
		CGContextFillPath(context);
		
		
		CGContextAddArc(context, 260, 90, 40, 0.0*M_PI/180, 270*M_PI/180, 1);
		CGContextAddLineToPoint(context, 280, 350);
		CGContextStrokePath(context);
		
		CGContextMoveToPoint(context, 130, 300);
		CGContextAddLineToPoint(context, 80, 400);
		CGContextAddLineToPoint(context, 190, 400);
		CGContextAddLineToPoint(context, 130, 300);
		CGContextStrokePath(context);
		 */
	}

- (IBAction)centerImage{

	
	//[initialPosition setCenter:CGPointMake(headingCorrected, 240)];
	/*[initialPosition setCenter:CGPointMake(235, 240)];
	[initialPosition setCenter:CGPointMake(230, 240)];
	[initialPosition setCenter:CGPointMake(225, 240)];
	[initialPosition setCenter:CGPointMake(200, 240)];
	*/

}

- (IBAction)centerImage2{
	
	//[secondPosition setCenter:CGPointMake(headingCorrected, 240)];
	/*[secondPosition setCenter:CGPointMake(235, 240)];
	[secondPosition setCenter:CGPointMake(230, 240)];
	[secondPosition setCenter:CGPointMake(225, 240)];
	[secondPosition setCenter:CGPointMake(200, 240)];
	*/
}



-(IBAction) asClientClicked:(id)sender{
	NSLog(@"1. As client\n");
	if(tcp) {
		if([tcp respondsToSelector:@selector(setShouldKeepRunning:)])
			[(TCPServer *)tcp setShouldKeepRunning: NO];
		[tcp release];
		NSLog(@"2. As client\n");
	}
	tcp = [[TCPClient alloc] initWithDelegate: self];
	[(TCPClient *) tcp connectHost: @"169.254.1.1" port:2000];
	mTextView.text = @"Client Waiting";	
    mTextViewSettings.text = @"Client Waiting";
   
}

-(IBAction) asServerClicked:(id)sender{
	NSLog(@"1. As server\n");
	if(tcp) {
		if([tcp respondsToSelector:@selector(setShouldKeepRunning:)])
			[(TCPServer *)tcp setShouldKeepRunning: NO];
		NSLog(@"2. As server %@\n", tcp);
		[tcp release];
		NSLog(@"3. As server\n");
	}
	tcp = [[TCPServer alloc] initWithDelegate: self];
	NSLog(@"4. As server\n");
	mTextView.text = @"Server Waiting";
	mTextViewSettings.text = @"Server Waiting";
	[ (TCPServer *) tcp startServer: @"3000"];	
	NSLog(@"5. As server\n");
	
	NSLog(@"2. Send\n");
	//if(tcp) [tcp sendData: @"Hello world\n"];
	
}

-(IBAction) sendClicked:(id)sender{
	NSLog(@"2. Send\n");
	//if(tcp) [tcp sendData: @"Hello world\n"];
	if(tcp) [tcp sendData: mTextSend.text];
	[mTextSend resignFirstResponder];
	
}

-(void) receiveData: (NSString *) data {
	
	//testLabel.text = data;

    
    if(RFIDReader == 0){
        
        mTextView.text = data;
        mTextViewSettings.text = data;
        
        
        
    }else if(RFIDReader == 1){
        
        //int ARFID;
        
        //ARFID = [data intValue];
        
        //[MyClass intToHexString:0x7282]
        //NSString *dataString=[[NSString alloc] initWithFormat:@"%lX", data];
        
        mTextView.text = data;
        mTextViewSettings.text = data;
        
        //mTextView.text = dataString; // to display the data as hexadecimal values
        //mTextViewSettings.text = dataString;
        
        
    }
	
	NSLog(@"I receive from M9", data);
}

-(void) didConnectToHost {
	mTextView.text = @"Connected";
    mTextViewSettings.text = @"Connected";
}

-(void) didDisconnectFromHost {
	
	NSLog(@"didDisconnectFromHost");
	mTextView.text = @"Disconnected";
    mTextViewSettings.text = @"Disconnected";
	tcp = NULL;
}

-(IBAction) actionSeg{
	if (seg.selectedSegmentIndex==0) {
		kGender = 0.415;
		NSLog(@"Selected male");
		
	}
	
	if (seg.selectedSegmentIndex == 1) {
		kGender = 0.413;
		NSLog(@"Selected female");
	}

}

-(IBAction) actionSeg2{
	if (seg2.selectedSegmentIndex==0) {
		RFIDReader = 0;
		NSLog(@"Selected M9 UHF Passive RFID reader");
		
	}
	
	if (seg2.selectedSegmentIndex == 1) {
		RFIDReader=1;
		NSLog(@"Selected L-RX300 HF Passive RFID reader");
	}
	
}

-(IBAction) actionSeg3{
	if (seg3.selectedSegmentIndex == 0) {
		headingDevice = 0;
		NSLog(@"Selected Gyro for heading estimation");
		
	}
	
	if (seg3.selectedSegmentIndex == 1) {
		headingDevice = 1;
		NSLog(@"Selected Compass for heading estimation");
	}
	
	if (seg3.selectedSegmentIndex == 2) {
		headingDevice = 2;
		NSLog(@"Selected Gyro + Compass (Kalman Filter) for heading estimation");
	}
	
}

-(IBAction) actionSegFiltering{	
    
    if (segFiltering.selectedSegmentIndex == 0) {
    filteringMethod = 0;
    NSLog(@"Selected landmark PDR reset correction");
    
}
	
	if (segFiltering.selectedSegmentIndex == 1) {
		filteringMethod = 1;
		NSLog(@"Kalman Filtering position correction");
	}
	
	if (segFiltering.selectedSegmentIndex == 2) {
		filteringMethod = 2;
		NSLog(@"Other filter position correction");
	}
	
}




-(IBAction) actionSwitch1{
	
	if(PDR){
		PDR = FALSE;
	}else {
		PDR = TRUE;
	}

	
}

-(IBAction) actionSwitch2{
	if(RFID){
		RFID = FALSE;
	}else {
		RFID = TRUE;
	}
}

-(IBAction) actionSwitch3{
	if(FUSED){
		FUSED = FALSE;
	}else {
		FUSED = TRUE;
	}
}

- (IBAction)setUpMapAttitude{
	
	//CMDeviceMotion *deviceMotion = motionManager.deviceMotion;
	//CMAttitude *attitude = deviceMotion.attitude;
	//referenceAttitude = attitude;
	
	if (motionManager != nil) {
		CMDeviceMotion *dm = motionManager.deviceMotion;
		referenceAttitude = [dm.attitude retain];
        // 
        // referenceAttitude = [dm.attitude retain] - ;
	}
	
	zeroMagneticHeading = headingGlobal;
	
	//zeroGyroHeading = attitude.yaw*(180/M_PI);
	
	
}

-(IBAction) hideKeyboardHeightTextField{
[heightTextField resignFirstResponder];
    
}




@end
