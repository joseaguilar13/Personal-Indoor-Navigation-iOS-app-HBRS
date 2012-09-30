#include "TCP.h"

@interface TCPClient : TCP {}
-(TCPClient *) initWithDelegate: (id) delegate;
-(BOOL) connectHost: (NSString *) host port: (UInt16) port;
@end
