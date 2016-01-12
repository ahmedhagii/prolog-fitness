:- include('user_interface.pl').

:- use_module(library(http/http_unix_daemon)).
:- initialization http_daemon.

:- [user_interface].