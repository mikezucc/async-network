Async Network is a framework for socket networking on COCOA or iOS based on [https://github.com/robbiehanson/CocoaAsyncSocket AsyncSocket].

# Quick Start

To set up networking, create an `AsyncServer` on the server machine, and `AsyncClients` on all client machines. They will automatically discover and connect to the server if a `serviceName` is provided and the `serviceType` matches for both clients and servers.

1. Setup the Server
    AsyncServer *server = [AsyncServer new];
    server.serviceName = @"MyServer"; // the Bonjour Service name
    [server start]; // open the listening socket and publish the service via Bonjour

2. Setup the Client(s)

    AsyncClient *client [AsyncClient new];
    [client start]; // the client will automatically connect to all discovered servers

3. Communicate

    // assign and implement the server delegate
    - (void)server:(AsyncServer *)theServer didReceiveObject:(id)object tag:(uint32)tag {
        // respond to incoming messages here
    }

    // send an object from the client to the server
    [client sendObject:myObject tag:0];

    // optional: send a request
    [client sendObject:myObject responseHandler:^(id response, NSError *error) {
        if(error) ...
        // react to the response here
    }];

If you prefer not to use Bonjour, you can start the server without setting a serviceName and connect to it directly using an `AsyncConnection` object. This connection also supports a `delegate` for receiving objects and object sending with a tag or response handler (see client example above).

    // initiate a connection to a server at 192.168.0.1:12345
    AsyncConnection *connection = [AsyncConnection connectionWithHost:@"192.168.0.1" port:12345];
    [connection start];

Request based networking can be simplified using an `AsyncRequest`:

    AsyncRequest *request = [AsyncRequest requestWithHost:@"192.168.0.1" port:12345 completionPort];
    request.body = myRequestObject;
    [request fireWithCompletionBlock:^(id response, NSError *error) {
        if(error) ...
        // react to the response here
    }];

# Peer 2 Peer Networking

Async Network supports Peer 2 Peer networking by creating an `AsyncServer` and `AsyncClient` on every peer. This way, all peers will automatically connect to each other.

# Broadcasting

You may use the `AsyncBroadcaster` to send and listen to broadcast messages on a local subnet. The broadcaster supports a `delegate` for receiving broadcasts.

    AsyncBroadcaster *broadcaster = [AsyncBroadcaster new];
    [broadcaster start];
    [broadcaster broadcast:myData];

There are working examples included in the source code of Async Network.