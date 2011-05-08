-module(errd).
%%% @doc Public API for the errd application
%%% @end
-export( [command/1, info/1] ).

command( Cmd ) ->
    errd_server:command( errd_server, Cmd ).

info( Filename ) ->
    errd_server:info( errd_server, Filename ).
