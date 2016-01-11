
lbm(Weight, Fat, LBM) :- LBM is (Weight * (100 - Fat)/100).
bmr(Weight, Fat, BMR) :- lbm(Weight, Fat, LBM), BMR is 370 + (21.6 * LBM).



calculate_nutritions(Weight, Fat, ActivityLevel, Bulking, Protein, Carbs, Fats, Calories) :-
													lbm(Weight, Fat, LBM),
													bmr(Weight, Fat, BMR),
													TEE is BMR * ActivityLevel,
													(
														(Bulking == true, Calories is round(TEE + (TEE * 20 / 100)));
														(Bulking == false, Calories is round(TEE - (TEE * 20 / 100)))
													),
													Protein is round(2.2 * LBM * 1.5),
													Fats is round(0.6 * 2.2 * LBM),
													CaloriesLeft is Calories - ((Protein * 4) + (Fats * 9)),
													Carbs is CaloriesLeft // 4.

