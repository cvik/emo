%% -------------------------------------------------------------------
%%  @doc
%%    Erlang Mustache renderer
%%  Note: Doesnt yet support inverted section, tripple curlies or &,
%%        nor partials or set delimiters.
%% @copyright (C) 2013,  Christoffer Vikström (chvi77@gamil.com)
%% -------------------------------------------------------------------

-module(emo).
-export([render/2]).

%% -------------------------------------------------------------------

-spec render(Template::string(), Context::[{atom(), iolist()}]) -> iolist().
render(Template, Context) ->
    render(Template, Context, []).

%% -------------------------------------------------------------------

render([${,${|Rest], Context, Acc) ->
    {Tag, NewRest} = find_end(Rest),
    {FinalRest, NewAcc} = handle_tag(Tag, NewRest, Context),
    render(FinalRest, Context, [NewAcc|Acc]);
render([C|Rest], Context, Acc) ->
    render(Rest, Context, [C|Acc]);
render([], _, Acc) -> lists:reverse(Acc).

find_end(List) -> find_end(List, []).
find_end([$},$}|Rest], Tag) -> {lists:reverse(Tag), Rest};
find_end([C|Rest], Acc) -> find_end(Rest, [C|Acc]).

handle_tag([$!|_], Rest, _) -> {Rest, []};
handle_tag([$#|Tag], Rest, Context) ->
    {Section, NewRest} = find_end_section(Tag, Rest),
    SubContext = lookup(Tag, Context),
    {NewRest, render_section(Section, Context, SubContext)};
handle_tag([$^|Tag], Rest, Context) ->
    {Section, NewRest} = find_end_section(Tag, Rest),
    case lookup(Tag, Context) of
        <<"">> ->
            {NewRest, render_section(Section, Context, true)};
        _ ->
            {NewRest, <<"">>}
    end;
handle_tag(Tag, Rest, Context) ->
    case lookup(Tag, Context) of
        <<"">> ->
            {Rest, <<"">>};
        Value ->
            {Rest, Value}
    end.

find_end_section(Tag, Rest) -> find_end_section(Tag, Rest, []).
find_end_section(Tag, [${,${,$/|Rest], Acc) ->
    case find_end(Rest) of
        {Tag, NewRest} ->
            {lists:reverse(Acc), NewRest};
        {_, NewRest} ->
            find_end_section(Tag, NewRest)
    end;
find_end_section(Tag, [C|Rest], Acc) ->
    find_end_section(Tag, Rest, [C|Acc]).

render_section(_, _, SubContext) when is_binary(SubContext) -> SubContext;
render_section(Section, Context, true) -> render(Section, Context);
render_section(_, _, false) -> <<"">>;
render_section(_, _, []) -> <<"">>;
render_section(Section, _, SubContext) when is_list(SubContext) ->
    [ render(Section, C) || C <- SubContext ];
render_section(Section, Context, SubContext) when is_function(SubContext) ->
    SubContext(Section, Context).


lookup(Tag, Context) ->
    case lists:keyfind(list_to_atom(Tag), 1, Context) of
        false ->
            <<"">>;
        {_, Value} ->
            Value
    end.
