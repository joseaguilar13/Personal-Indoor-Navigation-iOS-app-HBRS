#import "TCPClient.h"

@implementation TCPClient : TCP

- (TCPClient *) initWithDelegate: (id) delegate
{
	self = [super init];	
	[self setTheDelegate: delegate];
	NSLog (@"Creating socket.");
	socket = [[AsyncSocket alloc] initWithDelegate:self];
	return self;
}

/*	Attempts connection, returns YES when host located and no errors detected but before connection made.
	-didConnectToHost called when connection made.
 */
-(BOOL) connectHost: (NSString *) host port: (UInt16) port
{
	@try
	{
		NSError *err;
		
		[socket connectToHost:host onPort:port error:&err];
		NSLog (@"Could not connect. Error domain %@, code %d (%@).",
			   [err domain], [err code], [err localizedDescription]);
		if( err == nil) {
			NSLog (@"Connecting to %@ port %u.", host, port);
			return YES;
		}
		else
			NSLog (@"Could not connect. Error domain %@, code %d (%@).",
					   [err domain], [err code], [err localizedDescription]);
	}
	@catch (NSException *exception)
	{
		NSLog ([exception reason]);
	}	
	return NO;
}

/*
 This method simply abstracts the read-from-server operation. It is called
 from -onSocket:didReadData:withTag: to set up another read operation. If it did
 not set up another read operation, AsyncSocket would not do anything with any
 further packets froma server.
 */
- (void)readFromServer
{
	NSData *newline = [@"\n" dataUsingEncoding:NSASCIIStringEncoding];
	[socket readDataToData:newline withTimeout:-1 tag:0];
}

#pragma mark AsyncSocket Delegate Methods

/*
 This method is called when connection to server. Immediately
 wait for incoming data from the server.
*/
-(void) onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port;
{
	NSLog (@"Connected to %@ %u.", host, port);
	if ([theDelegate respondsToSelector:@selector(didConnectToHost)])
		[theDelegate didConnectToHost];	
//	[self readFromServer];
	NSData *newline = [@"\n" dataUsingEncoding:NSASCIIStringEncoding];
	[socket readDataToData:newline withTimeout:-1 tag:0];
}
@end
