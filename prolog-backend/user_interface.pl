:- include('database.pl').
:- include('meal_planner.pl').
:- include('formulas.pl').

:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/json)).
:- use_module(library(http/json_convert)).
:- use_module(library(http/http_json)).
:- use_module(library(record)).
:- use_module(library(time)).
:- use_module(library(http/html_write)).

:- http_handler(root(hello_world), say_hi, []).		% (1)
:- http_handler(root(json_test), json_test, []).		% (1)
:- http_handler(root(reply), reply, []).		% (1)
:- use_module(library(http/http_client)).

server(Port) :-						% (2)
        http_server(http_dispatch, [port(Port)]).

reply(Request) :-
%%        member(method(post), Request), !,
		%% format(user_output, "I'm here~n",[]),
        %% format('Content-type: text/plain~n~n', []),
		http_read_json(Request, DictIn),
		%% json_read(Request, DictIn, []),
        %% http_read_data(Request, Data, []),
        %% Data = [weight=Weight1],
        DictIn = json([weight=Weight1, fat=Fat1, al=ActivityLevel1, bulking=Bulking, meals=Meals1]),
        %% write(Data), nl,
        %% S = json(DictIn),
        %% reply_json(DictIn).
  %%       %% write(Age), nl,
        atom_number(Weight1, Weight),
        atom_number(Fat1, Fat),
        atom_number(ActivityLevel1, ActivityLevel),
        atom_number(Meals1, Meals),
        calculate_nutritions(Weight, Fat, ActivityLevel, Bulking, DailyProtein, DailyCarbs, DailyFats, DailyCalories),
        call_with_time_limit(10, try(Weight, Fat, ActivityLevel, Bulking, Meals, Schedule)),
        S = json([schedule=Schedule]),
		reply_json_dict(S).

json_test(_Request) :-
	S = json([name = ['chicken', 'beef']]),
	reply_json_dict(S).


try(Weight, Fat, ActivityLevel, Bulking, Meals, Schedule) :-
		catch(call_with_time_limit(1, get_schedule(Weight, Fat, ActivityLevel, Bulking, Meals, Schedule)),
			E, 
			(
				A is random(500), set_random(seed(A)),
				try(Weight, Fat, ActivityLevel, Bulking, Meals, Schedule)
			)).


get_schedule(Weight, Fat, ActivityLevel, Bulking, Meals, Schedule) :-
											calculate_nutritions(Weight, Fat, ActivityLevel, Bulking, DailyProtein, DailyCarbs, DailyFats, DailyCalories),
											%% write(DailyProtein), nl, write(DailyCarbs), nl, write(DailyFats), nl, write(DailyCalories), nl,
											DailyProteinRight is round(DailyProtein + (DailyProtein*4/100))*100000,
											DailyProteinLeft is round(DailyProtein - (DailyProtein*4/100))*100000,

											DailyCarbsRight is round(DailyCarbs + (DailyCarbs*4/100))*100000,
											DailyCarbsLeft is round(DailyCarbs - (DailyCarbs*4/100))*100000,

											DailyFatsRight is round(DailyFats + (DailyFats*5/100))*100000,
											DailyFatsLeft is round(DailyFats - (DailyFats*5/100))*100000,

											DailyCaloriesRight is round(DailyCalories + (DailyCalories*5/100))*100000,
											DailyCaloriesLeft is round(DailyCalories - (DailyCalories*5/100))*100000,

											DPL is DailyProteinLeft//100000,
											DPR is DailyProteinRight//100000,
											DCL is DailyCarbsLeft//100000,
											DCR is DailyCarbsRight//100000,
											DFL is DailyFatsLeft//100000,
											DFR is DailyFatsRight//100000,
											DCalL is DailyCaloriesLeft//100000,
											DCalR is DailyCaloriesRight//100000,
											%% write('Protein needed ':DPL-DPR), nl,
											%% write('Carbs needed ':DCL-DCR), nl,
											%% write('Fats needed ':DFL-DFR), nl,
											%% write('Cals needed ':DCalL-DCalR), nl,
											first_call(DailyProtein, DailyCarbs, DailyFats, DailyCalories, Meals, Schedule).
											%% write(Schedule),nl,
											%% print_meal(1, Schedule).

get_full_helper(0, _, _, _, _, _, []).
get_full_helper(Day, DailyProtein, DailyCarbs, DailyFats, DailyCalories, Meals, Ans) :-
					Day > 0,
					Day1 is Day - 1,
					write('hena'), nl,
					first_call(DailyProtein, DailyCarbs, DailyFats, DailyCalories, Meals, Schedule), !,
					write(Schedule), nl,
					get_full_helper(Day1, DailyProtein, DailyCarbs, DailyFats, DailyCalories, Meals, Res1),
					write('-----------------------------'),nl,write(day:Day),nl,nl,
					length(Schedule, Len),
					print_meal(1, Schedule),nl,
					append(Res1, [(day:Day, Schedule)], Ans).

print_meal(_, []).
print_meal(MealNo, [[Protein, Carbs, Fats, Calories, Meal]|T]) :-
			Meal1 is MealNo + 1,
			write('Meal':MealNo),nl,
			P1 is Protein // 100000,
			write('Protein '), write(P1), nl,
			C1 is Carbs//100000,
			write('Carbs '), write(C1), nl,
			F1 is Fats//100000,
			write('Fats '), write(F1), nl,
			Cal1 is Calories//100000,
			write('Calories '), write(Cal1), nl,
			write(Meal), nl,
			print_meal(Meal1, T).
get_full_schedule(Weight, Fat, ActivityLevel, Bulking, Meals, Schedule) :-
											calculate_nutritions(Weight, Fat, ActivityLevel, Bulking, DailyProtein, DailyCarbs, DailyFats, DailyCalories),
											DailyProteinRight is round(DailyProtein + (DailyProtein*4/100))*100000,
											DailyProteinLeft is round(DailyProtein - (DailyProtein*4/100))*100000,

											DailyCarbsRight is round(DailyCarbs + (DailyCarbs*4/100))*100000,
											DailyCarbsLeft is round(DailyCarbs - (DailyCarbs*4/100))*100000,

											DailyFatsRight is round(DailyFats + (DailyFats*20/100))*100000,
											DailyFatsLeft is round(DailyFats - (DailyFats*20/100))*100000,

											DailyCaloriesRight is round(DailyCalories + (DailyCalories*4/100))*100000,
											DailyCaloriesLeft is round(DailyCalories - (DailyCalories*4/100))*100000,

											DPL is DailyProteinLeft//100000,
											DPR is DailyProteinRight//100000,
											DCL is DailyCarbsLeft//100000,
											DCR is DailyCarbsRight//100000,
											DFL is DailyFatsLeft//100000,
											DFR is DailyFatsRight//100000,
											DCalL is DailyCaloriesLeft//100000,
											DCalR is DailyCaloriesRight//100000,
											write('Protein needed ':DPL-DPR), nl,
											write('Carbs needed ':DCL-DCR), nl,
											write('Fats needed ':DFL-DFR), nl,
											write('Cals needed ':DCalL-DCalR), nl,
											%% write(DailyProtein), nl, write(DailyCarbs), nl, write(DailyFats), nl, write(DailyCalories), nl,
											get_full_helper(5, DailyProtein, DailyCarbs, DailyFats, DailyCalories, Meals, Schedule), Schedule = [].
											 %% first_call(DailyProtein, DailyCarbs, DailyFats, DailyCalories, Meals, Schedule).
