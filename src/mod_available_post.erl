%%%----------------------------------------------------------------------

%%% File    : mod_available_post.erl
%%% Author  : Adam Duke <adam.v.duke@gmail.com>
%%% Purpose : Forward presence notifications to a url
%%% Created : 12 Feb 2012 by Adam Duke <adam.duke@apprenaissance.com>
%%%
%%%
%%% Copyright (C) 2012   Adam Duke
%%%
%%% This program is free software; you can redistribute it and/or
%%% modify it under the terms of the GNU General Public License as
%%% published by the Free Software Foundation; either version 2 of the
%%% License, or (at your option) any later version.
%%%
%%% This program is distributed in the hope that it will be useful,
%%% but WITHOUT ANY WARRANTY; without even the implied warranty of
%%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%%% General Public License for more details.
%%%
%%% You should have received a copy of the GNU General Public License
%%% along with this program; if not, write to the Free Software
%%% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
%%% 02111-1307 USA
%%%
%%%----------------------------------------------------------------------

-module(mod_available_post).
-author('adam.v.duke@gmail.com').

-behaviour(gen_mod).

-export([start/2,
	 init/2,
	 stop/1,
	 send_available_notice/4]).

-define(PROCNAME, ?MODULE).

-include("ejabberd.hrl").
-include("jlib.hrl").
-import(http).

start(Host, Opts) ->
    ?INFO_MSG("Starting mod_available_post", [] ),
    register(?PROCNAME,spawn(?MODULE, init, [Host, Opts])),  
    ok.

%%% set_presence_hook(User, Server, Resource, Packet) -> none
init(Host, _Opts) ->
    inets:start(),
    ssl:start(),
    ejabberd_hooks:add(set_presence_hook, Host, ?MODULE, send_available_notice, 10),
    ok.

stop(Host) ->
    ?INFO_MSG("Stopping mod_available_post", [] ),
    ejabberd_hooks:delete(set_presence_hook, Host,
			  ?MODULE, send_available_notice, 10),
    ok.

send_available_notice(User, Server, _Resource, _Packet) ->
    Token = gen_mod:get_module_opt(Server, ?MODULE, auth_token, [] ),
    PostUrl = gen_mod:get_module_opt(Server, ?MODULE, post_url, [] ),
    if
	(Token /= "") ->
	  Sep = "&",
	  Post = [
	    "jabber_id=", User, Sep,
	    "access_token=", Token ],
	  ?INFO_MSG("Sending post request ~p~n",[Post] ),
	  http:request(post, {PostUrl, [], "application/x-www-form-urlencoded", list_to_binary(Post)},[],[]),
	  ok;
	true ->
	  ok
    end.

