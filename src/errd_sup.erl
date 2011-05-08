%%%-------------------------------------------------------------------
%%% @doc Starts and supervises an errd_server process.
%%% The process is available under a registered name.
%%% Note however that if the process dies and is restarted,
%%% then there is a short period of time during which
%%% no process is registered and any gen_server:cast during
%%% that time will be discarded and any gen_server:call will fail.
%%% See http://stackoverflow.com/questions/4348040/registering-a-child-in-the-process-that-initiated-the-start-child-call
%%% for possible solutions.
%%%
%%% @end
%%% @author Geoff Cant <nem@lisp.geek.nz>
%%%-------------------------------------------------------------------
-module(errd_sup).

-behaviour(supervisor).
%%--------------------------------------------------------------------
%% Include files
%%--------------------------------------------------------------------

%%--------------------------------------------------------------------
%% External exports
%%--------------------------------------------------------------------
-export([start_link/0
        ]).

%%--------------------------------------------------------------------
%% Internal exports
%%--------------------------------------------------------------------
-export([init/1]).

%%--------------------------------------------------------------------
%% Macros
%%--------------------------------------------------------------------
-define(SERVER, ?MODULE).

%%--------------------------------------------------------------------
%% Records
%%--------------------------------------------------------------------

%%====================================================================
%% External functions
%%====================================================================
%%--------------------------------------------------------------------
%% @doc Starts the supervisor.
%% @spec start_link() -> {ok, pid()} | Error
%% @end
%%--------------------------------------------------------------------
start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%%====================================================================
%% Server functions
%%====================================================================
%%--------------------------------------------------------------------
%% Func: init/1
%% Returns: {ok,  {SupFlags,  [ChildSpec]}} |
%%          ignore                          |
%%          {error, Reason}   
%%--------------------------------------------------------------------
init([]) ->
    RestartStrategy    = one_for_one,
    MaxRestarts        = 1000,
    MaxTimeBetRestarts = 3600,
    
    SupFlags = {RestartStrategy, MaxRestarts, MaxTimeBetRestarts},
    
    ChildSpecs =
	[
	 {errd_server,
	  {errd_server, start_link, [errd_server]},
	  permanent,
	  10,
	  worker,
	  [errd_server]}
	 ],
    {ok,{SupFlags, ChildSpecs}}.

%%====================================================================
%% Internal functions
%%====================================================================

% vim: set ts=4 sw=4 expandtab:
