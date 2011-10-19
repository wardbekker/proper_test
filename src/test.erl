-module(test).

-export([prop_ends_with_double_cons_is_true/0]).

-include_lib("proper/include/proper.hrl").

-define(VOWELS, [$a, $e, $i, $o, $u, $y]).

-spec prop_ends_with_double_cons_is_true() -> proper:test().
prop_ends_with_double_cons_is_true() ->
    ?FORALL(
       Drow,
       double_consonant_list(),
       collect( Drow, ends_with_double_cons(Drow))
).

-spec double_consonant_list() -> proper:test().
double_consonant_list() ->
    ?LET(
       List,
       ?SUCHTHAT(Drow, list(consonant()), begin io:format("~p~n", [Drow]), length(Drow) > 2 end),
       begin
	   [H | _T] = List,
	   [H] ++ List
       end
      ).

-spec consonant() -> proper:test().
consonant() ->
    ?SUCHTHAT(Char, char(), lists:all(fun(C) -> Char /= C end, ?VOWELS)).

%
% Implements *d - the stem ends with a double consonant.
%
ends_with_double_cons([C, C|_]) -> not is_vowel(C, true);
ends_with_double_cons(_)        -> false.

%
% Utility function to cut down on different sections code testing for vowels.
%
is_vowel(L, Y_is_vowel) ->
    case L of
        $a -> true;
        $e -> true;
        $i -> true;
        $o -> true;
        $u -> true;
        $y when Y_is_vowel -> true;
        _  -> false
    end.
