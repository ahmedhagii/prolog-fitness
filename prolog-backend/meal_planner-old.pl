
merge([], Name, [(Name, 1)]).
merge([ (H, Count) | T], H, Ans) :- Count1 is Count + 1, append(T, [(H, Count1)], Ans).
merge([ (H, Count) | T], X, Ans) :- H \= X, merge(T, X, Ans1), append([(H, Count)], Ans1, Ans).


delete_zeros([], []).
delete_zeros([(_, Count) | T], Res) :- Count == 0, delete_zeros(T, Res).
delete_zeros([(Name, Count) | T], Res) :- Count \= 0, delete_zeros(T, Res1), append([(Name, Count)], Res1, Res).


build_meal([H], _, [H], []).
build_meal(NewDay, 0, [], NewDay).
build_meal([(Name, Count) | T], Avg, Res, NewDay) :-
												Avg > 0,
												min_list([Count, Avg], Min),
												random(0, Min, Portion),
												NewAvg is Avg - Portion,
												NewCount is Count - Portion,
												build_meal(T, NewAvg, Res1, NewDay1),
												append(NewDay1, [(Name, NewCount)] , NewDay),
												append(Res1, [(Name, Portion)], Res).

divide_meals(Day, 1, _, [Day]).
divide_meals(Day, Meals, Avg, Ans) :-
					Meals > 1,
					build_meal(Day, Avg, SingleMeal, NewDay),
					Meals1 is Meals - 1,
					divide_meals(NewDay, Meals1, Avg, Ans1),
					delete_zeros(SingleMeal, SingleMealFinal),
					append(Ans1, [SingleMealFinal], Ans).

sum([], 0).
sum([(_, Count) | T], Res) :- sum(T, Res1), Res is Res1 + Count.

called_first(DailyProtein, DailyCarbs, DailyFats, DailyCalories, Bulking, Meals, Ans) :-
			bagof(D, proteinSource(D), P),
			bagof(D, carbsSource(D), C),
			bagof(D, fatsSource(D), F),
			pick_food(P, C, F, DailyProtein, DailyCarbs, DailyFats, DailyCalories, Bulking, Day),
			length(Day, Len), Len >= 6,
			sum(Day, All),
			Avg is All // Len,
			divide_meals(Day, Meals, Avg, T),
			print_schedule(T, 1).


print_schedule([], _).
print_schedule([H|T], Day) :- write("Meal":Day), nl, print_list(H), nl, D1 is Day + 1, print_schedule(T, D1).

print_list([]).
print_list([(Name, Count) | T]) :- write("("), write(Name), write(", "), write(Count), write(" gram(s))"), nl, print_list(T).

pick_food(_, _, _, Protein, _, Fats, Calories, Bulking, []) :- Bulking == true, Protein >= -30, Protein =< 0, Fats >= -5, Fats =< 5, Calories >= -100, Calories =< 100.
pick_food(_, _, _, Protein, _, Fats, Calories, Bulking, []) :- Bulking == false, Protein >= -30, Protein =< 0, Fats >= -5, Fats =< 5, Calories =< 100, Calories >= 0.
pick_food(P, C, F, Protein, Carbs, Fats, Calories, Bulking, Ans) :-
		(Protein >= -30; Fats >= -5),
		((Protein >= Carbs, Protein >= Fats, random_member((Name, Pr, Ca, Fa, Cal), P)); (Carbs >= Protein, Carbs >= Fats, random_member((Name, Pr, Ca, Fa, Cal), C))
			; (Fats >= Protein, Fats >= Carbs, random_member((Name, Pr, Ca, Fa, Cal), F))),
			NewProtein is Protein - Pr,
			NewCarbs is Carbs - Ca,
			NewFats is Fats - Fa,
			NewCalories is Calories - Cal,
			pick_food(P, C, F, NewProtein, NewCarbs, NewFats, NewCalories, Bulking, Ans1),
			merge(Ans1, Name, Ans).

