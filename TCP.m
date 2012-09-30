#import "TCP.h"

@implementation TCP : NSObject
@synthesize theDelegate;

/*
 Sends data to host connected to socket.
 */
-(void) sendData: (NSString *) nsData {
	//NSData *data = [nsData dataUsingEncoding:NSASCIIStringEncoding];
	
    
    NSData *data = [nsData dataUsingEncoding:NSASCIIStringEncoding];
	//NSData *data = [nsData dataUsingEncoding:NSUTF8StringEncoding];
	[socket writeData: data withTimeout:-1 tag:0];
}

/*
 Called on disconnect. Calls delegate method -didDisconnectFromHost and releases the 
 socket used for communicating with host.
 */
-(void) onSocketDidDisconnect: (AsyncSocket *)sock {
	NSLog (@"onSocketDidDisconnect.");
	if ([theDelegate respondsToSelector:@selector(didDisconnectFromHost)])	
		[theDelegate didDisconnectFromHost];
}

/*
 Called whenever AsyncSocket is about to disconnect due to an error. 
 Does not do anything other than report what went wrong (this delegate method
 is the only place to get that information), but in a more serious app, this is
 a good place to do disaster-recovery by getting partially-read data. This is
 not, however, a good place to do cleanup. The socket must still exist when this
 method returns.
 */
-(void) onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
	if (err != nil)
		NSLog (@"Socket will disconnect. Error domain %@, code %d (%@).",
			   [err domain], [err code], [err localizedDescription]);
	else
		NSLog (@"Socket will disconnect. No error.");
}

/*
 Called when has finished reading a data packet.
 Prints data, pasess to delegate -receiveData method, then
 calls -readDataToData, which will queue up a
 read operation, waiting for the next packet.
 */
-(void) onSocket:(AsyncSocket *)sock didReadData:(NSData*)data withTag:(long)tag
{
	//NSString *str = [[NSString alloc] initWithData:data encoding: NSASCIIStringEncoding];
	
    NSString *str = [[NSString alloc] initWithData:data encoding: NSASCIIStringEncoding];
	
    //NSString *str = [[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding];
	
    NSLog(@"%@", str );
	// Let the delegate know.
	if ([theDelegate respondsToSelector:@selector(receiveData:)])
		[theDelegate receiveData: str];	
	[str release];
	// Read more from this socket.
    //other type of encoding to try NSUTF16BigEndianStringEncoding for LRX300
    // NSUTF8StringEncoding
	//NSData *newline = [@"\n" dataUsingEncoding:NSASCIIStringEncoding];
	
    NSData *newline = [@"\n" dataUsingEncoding:NSASCIIStringEncoding];
	//NSData *newline = [@"\n" dataUsingEncoding:NSUTF8StringEncoding];
	[sock readDataToData:newline withTimeout:-1 tag:tag];
}	

/*
 Release allocated resources, including the socket. The socket will close
 any connection before releasing itself.
 */
- (void)dealloc
{
	NSLog(@"TCP dealloc");
	[socket release];
	NSLog(@"TCP dealloc");
	[super dealloc];
	NSLog(@"TCP dealloc");
}
@end