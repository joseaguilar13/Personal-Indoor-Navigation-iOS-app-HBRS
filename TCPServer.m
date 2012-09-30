#import "TCPServer.h"

@implementation TCPServer : TCP
@synthesize shouldKeepRunning;
/*
 Sets up the server accept socket, but does not actually start it.
 Once started, the accept socket accepts incoming connections and creates new
 instances of AsyncSocket to handle them.
 */
- (TCPServer *) initWithDelegate: (id) delegate {
	self = [super init];
	[self setTheDelegate: delegate];
	NSLog (@"Creating Server socket.");
	serverSocket = [[AsyncSocket alloc] initWithDelegate:self];
	shouldKeepRunning = YES;
	return self;
}

-(void) startServer: (NSString *) port {
	/* performSelector...afterDelay puts an action on the run-loop before
	   it starts running. That action will actually start the accept socket, and
	   AsyncSocket will then be able to create other activity on the run-loop.
	   No other opportunity to do so; the run-loop does not
	   give any way in, other than the AsyncSocket delegate methods.
	
	   Note cannot call AsyncSocket's -acceptOnPort:error: outside of the run-loop.
	 */
	
	[self performSelector:@selector(acceptOnPortString:) withObject:port afterDelay:1.0];
//	[[NSRunLoop currentRunLoop] run];

	NSRunLoop *theRL = [NSRunLoop currentRunLoop];
	while (shouldKeepRunning && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
}

/*
 This method actually starts the accept socket. It is the first thing called by
 the run-loop.
 */
- (void) acceptOnPortString:(NSString *)str
{
	// AsyncSocket requires a run-loop.
	NSAssert ([[NSRunLoop currentRunLoop] currentMode] != nil, @"Run loop is not running");
	
	UInt16 port = [str intValue];
	
	NSError *err = nil;
	if ([serverSocket acceptOnPort:port error:&err])
		NSLog (@"Waiting for connections on port %u.", port);
	else
	{
		// If you get a generic CFSocket error, you probably tried to use a port
		// number reserved by the operating system.
		
		NSLog (@"Cannot accept connections on port %u. Error domain %@ code %d (%@). Exiting.", port, [err domain], [err code], [err localizedDescription]);
		exit(1);
	}
}

/*
 A connection is accepted and a new socket is created.
 Good place to perform housekeeping and re-assignment -- assigning an
 controller for the new socket, or retaining it. Here, the new socket was
 assigned and retained. 
 
 However, the new socket has not yet connected and no information is
 available about the remote socket, so this is not a good place to screen incoming
 connections. Use onSocket:didConnectToHost:port: for that.
 */
-(void) onSocket:(AsyncSocket *)sock didAcceptNewSocket:(AsyncSocket *)newSocket
{
	NSLog (@"Server Socket accepting connection.");
	[newSocket retain];
	socket = newSocket;
}

/*
 At this point, the new socket is ready to use. This is where you can screen the
 remote socket or find its DNS name (the host parameter is just an IP address).
 This is also where you should set up your initial read or write request, unless
 you have a particular reason for delaying it.
 */
-(void) onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
	NSLog (@"Socket successfully accepted connection from %@ %u.", host, port);
	NSData *newline = [@"\n" dataUsingEncoding:NSASCIIStringEncoding];
	
	// Each packet consists of a line of text, delimited by "\n".
	// This is not a technique you should use. I do not know what "\n" actually
	// means in terms of bytes. It could be CR, LF, or CRLF.
	//
	// In your own networking protocols, you must be more explicit. AsyncSocket 
	// provides byte sequences for each line ending. These are CRData, LFData,
	// and CRLFData. You should use one of those instead of "\n".
	
	// Start reading.
	if ([theDelegate respondsToSelector:@selector(didConnectToHost)])
		[theDelegate didConnectToHost];	
	[sock readDataToData:newline withTimeout:-1 tag:0];
}

-(void) dealloc
{
	NSLog(@"4. dealloc server\n");
	// Releasing a socket will close it if it is connected or listening.
	[serverSocket release];
	[super dealloc];
}

@end
