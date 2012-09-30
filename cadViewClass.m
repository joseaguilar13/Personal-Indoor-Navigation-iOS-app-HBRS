//
//  MainView.m
//  CoreLocationTest
//
//  Created by David HM Spector on 12/3/09.
//  Copyright Zeitgeist Information Systems 2009. All rights reserved.
//

#import "cadViewClass.h"

@implementation cadViewClass




-(void)setVal1:(float)val1 setVal2:(float)val2 setVal3:(float)val3 setVal4:(float)val4 setVal5:(float)val5 setVal6:(float)val6 setVal7:(float)val7 setVal8:(float)val8 setVal9:(int)val9 setVal10:(int)val10 setVal11:(int)val11 setVal12:(int)val12 setVal13:(float)val13{
	self-> posArrMV1 = val1;
	self-> posArrMV2 = val2;
	self-> posArrMV3 = val3;
	self-> posArrMV4 = val4;
	self-> posRFIDArrMV3 = val5;
	self-> posRFIDArrMV4 = val6;
	self-> posFusedArrMV3 = val7;
	self-> posFusedArrMV4 = val8;
	self-> stepsMV = val9;
	self-> initialBOOL = val10;
	self-> RFIDBOOL = val11;
	self-> fusedBOOL = val12;
	self-> angleMV = val13;
	
}



- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		
		
	}
    return self;
}


-(void)drawRect:(CGRect)rect {
    // Drawing code
	
	
	
	float x1 = self -> posArrMV1;
	float y1 = self -> posArrMV2;
	float x2= self -> posArrMV3;
	float y2= self -> posArrMV4;
	float RFIDx2= self -> posRFIDArrMV3;
	float RFIDy2= self -> posRFIDArrMV4;
	float fusedx2= self -> posFusedArrMV3;
	float fusedy2= self -> posFusedArrMV4;
	float angleLocal= self -> angleMV;
	
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
	
	
	if(stepsMVL == 0 ){
		
		for (int i = 0; i<=2000; i++) {
			posArr2[i]=0;
			posRFIDArr2[i]=0;
			posFusedArr2[i]=0;
			angleSent[i]=0;
			
		}
	}
	
	
	if(stepsMVL % 1 == 0){
		
		
		
		posArr2[2*stepsMVL/1] = x2;
		posArr2[2*stepsMVL/1+1] = y2;
		posRFIDArr2[2*stepsMVL/1] = RFIDx2;
		posRFIDArr2[2*stepsMVL/1+1] = RFIDy2;
		posFusedArr2[2*stepsMVL/1] = fusedx2;
		posFusedArr2[2*stepsMVL/1+1] = fusedy2;
		angleSent[stepsMVL] = angleLocal;
		
		
		
		for (int i=0; i <= (2*stepsMVL/1 +1); i++) {
			
			int temp3 = i * 2;
			int temp4 = i * 2 + 1;
			
			float temp1 = posArr2[temp3];
			float temp2 = posArr2[temp4];
			float RFIDtemp1 = posRFIDArr2[temp3];
			float RFIDtemp2 = posRFIDArr2[temp4];
			float fusedtemp1 = posFusedArr2[temp3];
			float fusedtemp2 = posFusedArr2[temp4];
			float angleRotation = angleSent[i];
			
			UIImage *imageRFID = [UIImage imageNamed:@"RFIDMarker.gif"];
			UIImage *imageFUSED = [UIImage imageNamed:@"FUSEDMarker.gif"];
			UIImage *imagePDR = [UIImage imageNamed:@"PDRMarker.gif"];
			
			
			if(angleRotation == 180){
		
				imageFUSED = [UIImage imageNamed:@"FUSED180.gif"];   
				imagePDR = [UIImage imageNamed:@"PDR180.gif"];
				
			}else if(angleRotation == 225){
				
				imageFUSED = [UIImage imageNamed:@"FUSED225.gif"];
				imagePDR = [UIImage imageNamed:@"PDR225.gif"];
				
			}else if(angleRotation == 270){
				
	            imageFUSED = [UIImage imageNamed:@"FUSED270.gif"];
				imagePDR = [UIImage imageNamed:@"PDR270.gif"];
			
			}else if(angleRotation == 315){
				
				imageFUSED = [UIImage imageNamed:@"FUSED315.gif"];
				imagePDR = [UIImage imageNamed:@"PDR315.gif"];
				
			}else if(angleRotation == 0){
				
				imageFUSED = [UIImage imageNamed:@"FUSED0.gif"];
				imagePDR = [UIImage imageNamed:@"PDR0.gif"];
				
			}else if(angleRotation == 45){
				
		        imageFUSED = [UIImage imageNamed:@"FUSED45.gif"];
				imagePDR = [UIImage imageNamed:@"PDR45.gif"];
				
			}else if(angleRotation == 90){
			
			    imageFUSED = [UIImage imageNamed:@"FUSED90.gif"];
		        imagePDR = [UIImage imageNamed:@"PDR90.gif"];
				
			}else if(angleRotation == 135){
			
				imageFUSED = [UIImage imageNamed:@"FUSED135.gif"];
			    
			    imagePDR = [UIImage imageNamed:@"PDR135.gif"];
				
			}else {
				
				
			}

			
			
			//PDRIV = [[UIImageView alloc] initWithImage:imagePDR];
			
			//PDRIV.transform = CGAffineTransformMakeRotation(angleRotation * 3.14159 / 180);
			
			//imagePDR = CGAffineTransformMakeRotation(angleRotation * 3.14159 / 180);
			
			//CGContextSetRGBFillColor(context, 1.0, 0.0, 0.0, 1.0);
			if(initialBOOL == 1){
			CGContextDrawImage(context, CGRectMake(temp1, temp2, 5, 5), imagePDR.CGImage);
			}else{}
			//CGContextAddRect(context, CGRectMake(temp1, temp2, 4.0, 4.0)); 
			CGContextFillPath(context);
			
			//CGContextSetRGBFillColor(context, 0.0, 0.5, 0.0, 1.0);
			if(RFIDBOOL == 1){
			CGContextDrawImage(context, CGRectMake(RFIDtemp1, RFIDtemp2, 5, 5), imageRFID.CGImage);
			}else {}
			

			//CGContextAddRect(context, CGRectMake(RFIDtemp1, RFIDtemp2, 7.0, 7.0)); 
			CGContextFillPath(context);
			
			//CGContextSetRGBFillColor(context, 0.0, 0.0, 0.7, 1.0);
			if(fusedBOOL==1){
	        CGContextDrawImage(context, CGRectMake(fusedtemp1, fusedtemp2, 5, 5), imageFUSED.CGImage);
			}else{}
				//CGContextAddRect(context, CGRectMake(fusedtemp1, fusedtemp2, 4.0, 4.0)); 
			
			CGContextFillPath(context);
			
			//CGContextMoveToPoint(context, temp1, temp2); //Start
			//CGContextAddLineToPoint(context, temp1, temp2); // InitialPosition.center 
			//CGContextAddLineToPoint(context, temp5, temp6); // InitialPosition.center
			//CGContextStrokePath(context);
		}		
		
		
		
		
		CGContextStrokePath(context);
		
		
	}	
	
	
}



- (void)dealloc {
    [super dealloc];
}

	@end
