:-use_module(library(clpfd)).

first_call(DailyProtein, DailyCarbs, DailyFats, DailyCalories, Meals, Schedule) :-
				DailyProteinRight is round(DailyProtein + (DailyProtein*5/100))*100000,
				DailyProteinLeft is round(DailyProtein - (DailyProtein*5/100))*100000,

				DailyCarbsRight is round(DailyCarbs + (DailyCarbs*5/100))*100000,
				DailyCarbsLeft is round(DailyCarbs - (DailyCarbs*5/100))*100000,

				DailyFatsRight is round(DailyFats + (DailyFats*10/100))*100000,
				DailyFatsLeft is round(DailyFats - (DailyFats*10/100))*100000,

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
				%% write(DailyCarbsLeft*DailyCarbsRight),nl,
				%% write(DailyProteinRight), nl, write(DailyCarbsRight), nl, write(DailyFatsRight), nl,
				generate_meals(Meals, (DailyProteinLeft, DailyCarbsLeft, DailyFatsLeft, DailyCaloriesLeft), (DailyProteinRight, DailyCarbsRight, DailyFatsRight, DailyCaloriesRight), Res),
				%% write('finish '), write(Res), nl,
				%% write('meal'), write(Meals), write('nutritions'), nl,
				%% write(P), nl, write(C), nl, write(F), nl, write(Cal),nl,
				%% write(Res), nl,
				%% (Prot, Car, Fa, Cal, L) = Res,
				%% write('r '), write(Res), nl,
				%% sum_nutritions(Res, (P, C, F, Cal)),

				%% write(Res),nl,
				%% (P #>= DailyProteinLeft, P #=< DailyProteinRight),
				%% (C #>= DailyCarbsLeft, C #=< DailyCarbsRight),
				%% (F #>= DailyFatsLeft, F #=< DailyFatsRight),
				%% (Cal #>= DailyCarbsLeft, Cal #=< DailyCaloriesRight),
				%% write(P*C*F),nl,

				%% labeling([], Nuts),
				%% write(Nuts),nl,
				%% write(Nuts), nl,
				%% write('xDD'),nl,
				%% (Cal #>= DailyCaloriesLeft, Cal #=< DailyCaloriesRight),
				Schedule = Res.

label_things([], [], []).
label_things([(Prot, Car, Fa, Cal, LL) | T], L, L2) :-
				label_things(T, L1, L23),
				append(L23, [Prot, Car, Fa, Cal], L2),
				append(LL, L1, L).


form_answer(Idx, _, [], []).
form_answer(Idx, Portions, [(_, Name, ID, _,_,_,_, _, _) | T], Res) :-
				Idx1 is Idx+1,
				element(Idx, Portions, H),
				H == 0,
				form_answer(Idx1, Portions, T, Res).
form_answer(Idx, Portions, [(_, Name, ID, _,_,_,_, _, _) | T], Res) :-
				Idx1 is Idx+1,
				element(Idx, Portions, H),
				H \= 0,
				form_answer(Idx1,Portions, T, Res1),
				append(Res1, [[Name, ID, H]], Res).


generate_meals(5, (DPL, DCL, DFL, DCalL), (DPR, DCR, DFR, DCalR), Answer) :-


				bagof((Y1, Z1),food(breakfast, Y1, Z1), AllFood1),
				random_permutation(AllFood1, AllFood11),
				create_Meal((DPR, DCR, DFR, DCalR), Protein1, Carbs1, Fats1, Calories1, SingleMeal1, AllFood11),


				bagof((Y2, Z2),food(breakfast-lunch, Y2, Z2), AllFood2),
				random_permutation(AllFood2, AllFood22),
				create_Meal((DPR, DCR, DFR, DCalR), Protein2, Carbs2, Fats2, Calories2, SingleMeal2, AllFood22),

				bagof((Y3, Z3),food(lunch, Y3, Z3), AllFood3),
				random_permutation(AllFood3, AllFood33),
				create_Meal((DPR, DCR, DFR, DCalR), Protein3, Carbs3, Fats3, Calories3, SingleMeal3, AllFood33),

				bagof((Y4, Z4),food(lunch-dinner, Y4, Z4), AllFood4),
				random_permutation(AllFood4, AllFood44),
				create_Meal((DPR, DCR, DFR, DCalR), Protein4, Carbs4, Fats4, Calories4, SingleMeal4, AllFood44),


				bagof((Y5, Z5),food(dinner, Y5, Z5), AllFood5),
				random_permutation(AllFood5, AllFood55),
				create_Meal((DPR, DCR, DFR, DCalR), Protein5, Carbs5, Fats5, Calories5, SingleMeal5, AllFood55),

				%% nutrition limits
				PS #= Protein1 + Protein2 + Protein3 + Protein4 + Protein5,
				PS #>= DPL, PS #=< DPR,

				CS #= Carbs1 + Carbs2 + Carbs3 + Carbs4 + Carbs5,
				CS #>= DCL, CS #=< DCR,

				FS #= Fats1 + Fats2 + Fats3 + Fats4 + Fats5,
				FS #>= DFL, FS #=< DFR,

				CalS #= Calories1 + Calories2 + Calories3 + Calories4 + Calories5,
				CalS #>= DCalL, CalS #=< DCalR,
				%% write('meal 4 '), write(SingleMeal4), nl,
				append([(Protein1, Carbs1, Fats1, Calories1, SingleMeal1)], [(Protein2, Carbs2, Fats2, Calories2, SingleMeal2)], SingleMeal12),
				append(SingleMeal12, [(Protein3, Carbs3, Fats3, Calories3, SingleMeal3)], SingleMeal123),
				append(SingleMeal123, [(Protein4, Carbs4, Fats4, Calories4, SingleMeal4)], SingleMeal1234),
				append(SingleMeal1234, [(Protein5, Carbs5, Fats5, Calories5, SingleMeal5)], Res),

				label_things(Res, R, Nuts),
				random_permutation(R, RLabel),
				labeling([], RLabel),
				label_things(Res, R, Nuts),

				length(AllFood11, Len1),
				form_answer(1, R, AllFood11, Meal1),

				FromIdx2 is Len1 + 1,
				length(AllFood22, Len2),
				Length2 is Len2 + Len1,
				form_answer(FromIdx2, R, AllFood22, Meal2),

				FromIdx3 is Length2 + 1,
				length(AllFood33, Len3),
				Length3 is Length2 + Len3,
				form_answer(FromIdx3, R, AllFood33, Meal3),

				FromIdx4 is Length3 + 1,
				length(AllFood44, Len4),
				Length4 is Length3 + Len4,
				form_answer(FromIdx4, R, AllFood44, Meal4),

				FromIdx5 is Length4 + 1,
				length(AllFood55, Len5),
				Length5 is Length4 + Len5,
				form_answer(FromIdx5, R, AllFood55, Meal5),

				append([[Protein1, Carbs1, Fats1, Calories1,Meal1]], [[Protein2, Carbs2, Fats2, Calories2, Meal2]], Meal12),
				append(Meal12, [[Protein3, Carbs3, Fats3, Calories3,Meal3]], Meal123),
				append(Meal123, [[Protein4, Carbs4, Fats4, Calories4,Meal4]], Meal1234),
				append(Meal1234, [[Protein5, Carbs5, Fats5, Calories5, Meal5]], Answer).

generate_meals(4, (DPL, DCL, DFL, DCalL), (DPR, DCR, DFR, DCalR), Answer) :-

				bagof((Y1, Z1),food(breakfast, Y1, Z1), AllFood11),
				random_permutation(AllFood11, AllFood1),!,
				create_Meal((DPR, DCR, DFR, DCalR), Protein1, Carbs1, Fats1, Calories1, SingleMeal1, AllFood1),
				labeling([], SingleMeal1),

				bagof((Y3, Z3),food(lunch, Y3, Z3), AllFood33),
				random_permutation(AllFood33, AllFood3),
				create_Meal((DPR, DCR, DFR, DCalR), Protein3, Carbs3, Fats3, Calories3, SingleMeal3, AllFood3),

				bagof((Y2, Z2),food(breakfast-lunch, Y2, Z2), AllFood22),
				random_permutation(AllFood22, AllFood2),!,
				create_Meal((DPR, DCR, DFR, DCalR), Protein2, Carbs2, Fats2, Calories2, SingleMeal2, AllFood2),

				bagof((Y4, Z4),food(dinner, Y4, Z4), AllFood44),
				random_permutation(AllFood44, AllFood4),
				create_Meal((DPR, DCR, DFR, DCalR), Protein4, Carbs4, Fats4, Calories4, SingleMeal4, AllFood4),

				PS #= Protein1 + Protein2 + Protein3 + Protein4,
				PS #>= DPL, PS #=< DPR,
				%% DPR - PS #>= 0,
				%% PS #>= DPL,

				CS #= Carbs1 + Carbs2 + Carbs3 + Carbs4,
				CS #>= DCL, CS #=< DCR,
				%% DCR - CS #>= 0,
				%% CS #>= DCL,

				FS #= Fats1 + Fats2 + Fats3 + Fats4,
				FS #>= DFL, FS #=< DFR,
				%% DFR - FS #>= 0,

				CalS #= Calories1 + Calories2 + Calories3 + Calories4,
				CalS #>= DCalL, CalS #=< DCalR,

				append([(Protein1, Carbs1, Fats1, Calories1, SingleMeal1)], [(Protein2, Carbs2, Fats2, Calories2, SingleMeal2)], SingleMeal12),
				append(SingleMeal12, [(Protein3, Carbs3, Fats3, Calories3, SingleMeal3)], SingleMeal123),
				append(SingleMeal123, [(Protein4, Carbs4, Fats4, Calories4, SingleMeal4)], Res),

				label_things(Res, R, Nuts),
				random_permutation(R, RLabel),
				labeling([], RLabel),
				label_things(Res, R, Nuts),

				length(AllFood1, Len1),
				form_answer(1, R, AllFood1, Meal1),

				FromIdx2 is Len1 + 1,
				length(AllFood2, Len2),
				Length2 is Len2 + Len1,
				form_answer(FromIdx2, R, AllFood2, Meal2),

				FromIdx3 is Length2 + 1,
				length(AllFood3, Len3),
				Length3 is Length2 + Len3,
				form_answer(FromIdx3, R, AllFood3, Meal3),

				FromIdx4 is Length3 + 1,
				length(AllFood4, Len4),
				Length4 is Length3 + Len4,
				form_answer(FromIdx4, R, AllFood4, Meal4),

				append([[Protein1, Carbs1, Fats1, Calories1, Meal1]], [[Protein2, Carbs2, Fats2, Calories2, Meal2]], Meal12),
				append(Meal12, [[Protein3, Carbs3, Fats3, Calories3, Meal3]], Meal123),
				append(Meal123, [[Protein4, Carbs4, Fats4, Calories4, Meal4]], Answer).

generate_meals(3, (DPL, DCL, DFL, DCalL), (DPR, DCR, DFR, DCalR), Answer) :-

				bagof((Y1, Z1),food(breakfast, Y1, Z1), AllFood11),
				random_permutation(AllFood11, AllFood1),
				create_Meal((DPR, DCR, DFR, DCalR), Protein1, Carbs1, Fats1, Calories1, SingleMeal1, AllFood1),

				bagof((Y2, Z2),food(lunch, Y2, Z2), AllFood22),
				random_permutation(AllFood22, AllFood2),
				create_Meal((DPR, DCR, DFR, DCalR), Protein2, Carbs2, Fats2, Calories2, SingleMeal2, AllFood2),

				bagof((Y3, Z3),food(dinner, Y3, Z3), AllFood33),
				random_permutation(AllFood33, AllFood3),
				create_Meal((DPR, DCR, DFR, DCalR), Protein3, Carbs3, Fats3, Calories3, SingleMeal3, AllFood3),


				%% nutrition limits
				PS #= Protein1 + Protein2 + Protein3,
				PS #>= DPL, PS #=< DPR,

				CS #= Carbs1 + Carbs2 + Carbs3,
				CS #>= DCL, CS #=< DCR,

				FS #= Fats1 + Fats2 + Fats3,
				FS #>= DFL, FS #=< DFR,


				CalS #= Calories1 + Calories2 + Calories3,
				CalS #>= DCalL, CalS #=< DCalR,

				append([(Protein1, Carbs1, Fats1, Calories1, SingleMeal1)], [(Protein2, Carbs2, Fats2, Calories2, SingleMeal2)], SingleMeal12),
				append(SingleMeal12, [(Protein3, Carbs3, Fats3, Calories3, SingleMeal3)], Res),

				label_things(Res, R, Nuts),
				random_permutation(R, RLabel),
				labeling([], RLabel),
				label_things(Res, R, Nuts),

				length(AllFood1, Len1),
				form_answer(1, R, AllFood1, Meal1),

				FromIdx2 is Len1 + 1,
				length(AllFood2, Len2),
				Length2 is Len2 + Len1,
				form_answer(FromIdx2, R, AllFood2, Meal2),

				FromIdx3 is Length2 + 1,
				length(AllFood3, Len3),
				Length3 is Length2 + Len3,
				form_answer(FromIdx3, R, AllFood3, Meal3),

				append([[Protein1, Carbs1, Fats1, Calories1, Meal1]], [[Protein2, Carbs2, Fats2, Calories2, Meal2]], Meal12),
				append(Meal12, [[Protein3, Carbs3, Fats3, Calories3, Meal3]], Answer).

generate_meals(1, (DPL, DCL, DFL, DCalL), (DPR, DCR, DFR, DCalR), Answer) :-
				DPR #>= 0,
				DCR #>= 0,
				DFR #>= 0,

				bagof((Y1, Z1),food(lunch, Y1, Z1), AllFood11),
				random_permutation(AllFood11, AllFood1),!,
				create_Meal((DPR, DCR, DFR, DCalR), Protein1, Carbs1, Fats1, Calories1, SingleMeal1, AllFood1),

				%% nutrition limits
				PS #= Protein1,
				PS #>= DPL, PS #=< DPR,

				CS #= Carbs1,
				CS #>= DCL, CS #=< DCR,

				FS #= Fats1,
				FS #>= DFL, FS #=< DFR,


				CalS #= Calories1,
				%% write('calss '*DCalL*DCalR),nl,
				%% CalS #>= DCalL, CalS #=< DCalR,

				%% append([(Protein1, Carbs1, Fats1, Calories1, SingleMeal1)], [(Protein2, Carbs2, Fats2, Calories2, SingleMeal2)], SingleMeal12),
				%% append(SingleMeal12, [(Protein3, Carbs3, Fats3, Calories3, SingleMeal3)], Res),
				R = SingleMeal1,
				label_things(Res, R, Nuts),

				write(R), nl,
				append(R, Nuts, XX),
				labeling([], XX),

				write(R), nl,
				%% write('Total Calories '), write(CalS), nl,

				length(AllFood1, Len1),
				form_answer(1, R, AllFood1, Meal1),
				Answer = [(Protein1, Carbs1, Fats1, Calories1, Meal1)].
				%% FromIdx2 is Len1 + 1,
				%% length(AllFood2, Len2),
				%% Length2 is Len2 + Len1,
				%% form_answer(FromIdx2, R, AllFood2, Meal2),

				%% FromIdx3 is Length2 + 1,
				%% length(AllFood3, Len3),
				%% Length3 is Length2 + Len3,
				%% form_answer(FromIdx3, R, AllFood3, Meal3),

				%% append([Meal1], [Meal2], Meal12),
				%% append(Meal12, [Meal3], Answer).

create_Meal((DP, DC, DF, DCal), Protein,Carbs, Fats, Calories,List, L) :-
				length(L, Size),
				length(List, Size),
				List ins 0..1000,

				Sum #= Protein + Carbs + Fats + Calories,
				Sum #\= 0,
				calculate7agat([], List, L, Protein, Carbs, Fats, Calories).


calculate7agat(_, [],_, 0, 0, 0, 0).
calculate7agat(TypesTaken, [Quant|T], [(Type, Name, ID,P,C,F,CC,Min,Max) | T2], Protein, Carbs, Fats, Calories):-
				(Quant #=< Max, Quant #>= Min, not(member(Type, TypesTaken)), append(TypesTaken, [Type], TypesTakenNew)),
				calculate7agat(TypesTakenNew, T,T2,Protein2,Carbs2,Fats2,Calories2),
				Protein #= Protein2 + (P*Quant),
				Carbs #= Carbs2 + (C*Quant),
				Fats #= Fats2 + (F*Quant),
				Calories #= Calories2 + (CC*Quant).
calculate7agat(TypesTaken, [Quant|T], [(Type, Name, ID, P,C,F,CC,Min,Max) | T2], Protein, Carbs, Fats, Calories):-
				Quant #= 0,
				calculate7agat(TypesTaken, T,T2,Protein,Carbs,Fats,Calories).
