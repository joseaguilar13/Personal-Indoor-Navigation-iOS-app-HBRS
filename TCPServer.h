#import "TCP.h"

@interface TCPServer : TCP
{
	AsyncSocket *serverSocket;
	BOOL shouldKeepRunning; 
}
@property BOOL shouldKeepRunning;

-(void) dealloc;
-(TCPServer *) initWithDelegate: (id) delegate;
//-(void) acceptOnPortString:(NSString *)str;
-(void) onSocket:(AsyncSocket *)sock didAcceptNewSocket:(AsyncSocket *)newSocket;
-(void) onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port;
-(void) startServer: (NSString *) port;
@end
