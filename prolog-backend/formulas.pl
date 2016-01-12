
lbm(Weight, Fat, LBM) :- LBM is (Weight * (100 - Fat)/100).
%% bmr(Weight, Fat, BMR) :- lbm(Weight, Fat, LBM), BMR is 370 + (21.6 * LBM).
bmr(Weight, Fat, BMR) :-
			((Fat >= 10, Fat =< 14, Multiplier = 1.0);(Fat > 14, Fat =< 20, Multiplier = 0.95)
				;(Fat > 20, Fat =< 28, Multiplier = 0.90); (Fat > 28, Multiplier = 0.85)),
			BMR is 24 * Weight * Multiplier.


%% calculate_nutritions(Weight, Fat, ActivityLevel, Bulking, Protein, Carbs, Fats, Calories) :-
%% 													lbm(Weight, Fat, LBM),
%% 													bmr(Weight, Fat, BMR),
%% 													TEE is BMR * ActivityLevel,
%% 													(
%% 														(Bulking == true, Calories is round(TEE + (TEE * 20 / 100)));
%% 														(Bulking == false, Calories is round(TEE - (TEE * 20 / 100)))
%% 													),
%% 													Protein is round(2.2 * LBM * 1.5),
%% 													Fats is round(0.4 * 2.2 * LBM),
%% 													CaloriesLeft is Calories - ((Protein * 4) + (Fats * 9)),
%% 													Carbs is CaloriesLeft // 4.


calculate_nutritions(Weight, Fat, ActivityLevel, Bulking, Protein, Carbs, Fats, TotalCals) :-
													bmr(Weight, Fat, BMR),
													TotalCals is BMR*ActivityLevel,
													write(TotalCals), nl,
													(
														(Bulking == true, Protein is round(1 * 2.2 * Weight));
														(Bulking == false, Protein is round(2.2 * Weight * 0.65))
													),
													Fats is round(15*TotalCals/100/9),
													CaloriesLeft is TotalCals - ((Protein * 4) + (Fats * 9)),
													Carbs is round(CaloriesLeft / 4).

