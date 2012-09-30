#include "AsyncSocket.h"

@interface TCP : NSObject
{
	AsyncSocket *socket;
	id			theDelegate;
}

@property (readwrite, retain) id theDelegate;	

-(void) dealloc;
-(void) sendData: (NSString *) nsData;
-(void) onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err;
-(void) onSocket:(AsyncSocket *)sock didReadData:(NSData*)data withTag:(long)tag;
-(void) onSocketDidDisconnect: (AsyncSocket *)sock;
@end

@interface TCP (TCPDelegate) 
-(void) receiveData: (NSString *) data;
-(void) didConnectToHost;
-(void) didDisconnectFromHost;
@end