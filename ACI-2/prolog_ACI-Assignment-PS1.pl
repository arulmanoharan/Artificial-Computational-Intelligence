% Main rule to predict the water source
predict_water_source(WaterSource) :-
    prompt(lake_distance, LakeDistance),
    decide_lake(LakeDistance, WaterSource).
% Rule to decide based on lake distance
decide_lake(LakeDistance, WaterSource) :-
    LakeDistance < 10,
    WaterSource = 'lake'.
decide_lake(LakeDistance, WaterSource) :-
    LakeDistance >= 10,
    prompt(river_distance, RiverDistance),
    decide_river(RiverDistance, WaterSource, LakeDistance).
% Rule to decide based on river distance
decide_river(RiverDistance, WaterSource, LakeDistance) :-
    RiverDistance >= 8,
    prompt(rainfall_intensity, RainfallIntensity),
    decide_rain(RiverDistance, RainfallIntensity, WaterSource, LakeDistance).
decide_river(RiverDistance, WaterSource, _) :-
    RiverDistance < 8,
    prompt(rainfall_intensity, RainfallIntensity),
    (RainfallIntensity >= 200 ->
        WaterSource = 'rain';
        WaterSource = 'river').
% Rule to decide based on rainfall intensity and sandy aquifer
decide_rain(RiverDistance, RainfallIntensity, WaterSource, LakeDistance) :-
    RainfallIntensity >= 150,
    WaterSource = 'rain'.
decide_rain(RiverDistance, RainfallIntensity, WaterSource, LakeDistance) :-
    RainfallIntensity < 150,
    prompt(sandy_aquifer, SandyAquifer),
    decide_sandy_aquifer(SandyAquifer, WaterSource, LakeDistance, RiverDistance).  % Pass RiverDistance
% Rule to decide based on sandy aquifer
decide_sandy_aquifer(yes, WaterSource, _, RiverDistance) :-
    prompt(beach_distance, BeachDistance),
    decide_beach(BeachDistance, RiverDistance, WaterSource).  % Pass RiverDistance
decide_sandy_aquifer(no, WaterSource, LakeDistance, _) :-
    (LakeDistance < 14 ->
        WaterSource = 'lake';
        WaterSource = 'rain').
% Rule to decide based on beach distance
decide_beach(BeachDistance, RiverDistance, WaterSource) :-  % RiverDistance is passed here
    BeachDistance < 5,
    (RiverDistance < 20 ->
        WaterSource = 'river';
        WaterSource = 'rain').
decide_beach(BeachDistance, _, WaterSource) :-
    BeachDistance >= 5,
    WaterSource = 'ground_water'.
% Utility to prompt user for attribute values
prompt(Attribute, Value) :-
    format('Enter the value for ~w: ', [Attribute]),
    read(Value).