/** <module> knowrob_cloud_logger

  Copyright (C) 2017 Asil Kaan Bozcuoglu
  All rights reserved.

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
      * Redistributions of source code must retain the above copyright
        notice, this list of conditions and the following disclaimer.
      * Redistributions in binary form must reproduce the above copyright
        notice, this list of conditions and the following disclaimer in the
        documentation and/or other materials provided with the distribution.
      * Neither the name of the <organization> nor the
        names of its contributors may be used to endorse or promote products
        derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
  DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

  @author Asil Kaan Bozcuoglu
  @license BSD
*/

:- module(knowrob_cloud_logger,
    [
        cloud_interface/3,
        start_user_container/0,
        connect_to_user_container/0,
        send_prolog_query/3,
        send_next_solution/1,
        read_next_prolog_query/1,
        read_next_prolog_query/2
    ]).
:- use_module(library('semweb/rdf_db')).
:- use_module(library('semweb/rdfs')).
:- use_module(library('owl')).
:- use_module(library('rdfs_computable')).
:- use_module(library('owl_parser')).
:- use_module(library('comp_temporal')).
:- use_module(library('knowrob_cram')).
:- use_module(library('knowrob_temporal')).

:- rdf_db:rdf_register_ns(knowrob, 'http://knowrob.org/kb/knowrob.owl#',  [keep(true)]).
:- rdf_db:rdf_register_ns(knowrob_cram, 'http://knowrob.org/kb/knowrob_cram.owl#', [keep(true)]).



% define predicates as rdf_meta predicates
% (i.e. rdf namespaces are automatically expanded)
:-  rdf_meta
    cloud_interface(+,+,+),
    send_prolog_query(+,+,-),
    send_next_solution(+),
    read_next_prolog_query(-),
    read_next_prolog_query(+,-).

cloud_interface :-
    cloud_interface(_).

:- assert(cld_interface(fail)).
cloud_interface(Host, KeyPath, ApiToken) :-
    cld_interface(fail),
    jpl_new('org.knowrob.cloud_logger.LoggerClient', [ApiToken, Host, KeyPath], CL),
    retract(cld_interface(fail)),
    assert(cld_interface(CL)),!.

cloud_interface(CL) :-
    cld_interface(CL).

start_user_container :-
    cloud_interface(CL),
    jpl_call(CL, 'startUserContainer', [], _R).

connect_to_user_container :-
    cloud_interface(CL),
    jpl_call(CL, 'connectToUserContainer', [], _R).

send_prolog_query(Prolog, Incremental, Id) :-
    cloud_interface(CL),
    jpl_call(CL, 'sendPrologQuery', [Prolog, Incremental], Id).

send_next_solution(Id) :-
    cloud_interface(CL),
    jpl_call(CL, 'sendPrologNextSolution', [Id], _).

read_next_prolog_query(Result) :-
    cloud_interface(CL),
    jpl_call(CL, 'readPrologNextSolution', [], Result).

read_next_prolog_query(Field, Result) :-
    cloud_interface(CL),
    jpl_call(CL, 'readPrologNextSolution', [Field], Result).
