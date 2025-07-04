// File: fnc_FaceSwap.sqf
/*
    [unit, "african"] spawn OKS_fnc_FaceSwap;
    [unit] spawn OKS_fnc_FaceSwap; // Defaults to "african"
*/

params [
    ["_unit", objNull, [objNull]],
    ["_faceType", nil, [""]]
];

if(hasInterface && !isServer) exitWith {};
private _faceswapDebug = missionNamespace getVariable ["GOL_FaceSwap_Debug", false];

if(isNil "_faceType") then {
    _faceType = [_unit] call OKS_fnc_GetEthnicity;
};

if (isNil "_faceType") exitWith {
    if(_faceswapDebug) then {
        format["[FaceSwap] Exited on %1 - Type is null"] spawn OKS_fnc_LogDebug;
    };
};

if(isNull _unit) exitWith {
    if(_faceswapDebug) then {
        "[FaceSwap] Exited - Unit is null" spawn OKS_fnc_LogDebug;
    };
};

sleep (3 + (random 3));

private _faces = [];
private _speakers = [];
private _firstNames = [];
private _surnames = [];

switch (toLower _faceType) do {
    case "polish": {
        _faces = [
            "LivonianHead_5","LivonianHead_2","Ioannou","LivonianHead_7","LivonianHead_6",
            "LivonianHead_3","LivonianHead_1","LivonianHead_10","LivonianHead_8","LivonianHead_4","LivonianHead_9"
        ];
        _speakers = ["Male01POL","Male02POL","Male03POL"];
        _firstNames = [
            "Jakub", "Mateusz", "Kacper", "Szymon", "Jan", "Filip", "Michał", "Bartosz",
            "Krzysztof", "Adam", "Piotr", "Paweł", "Tomasz", "Marcin", "Łukasz", "Maciej",
            "Grzegorz", "Wojciech", "Dawid", "Rafał"
        ];
        _surnames = [
            "Kowalski", "Nowak", "Wiśniewski", "Wójcik", "Kowalczyk", "Kamiński", "Lewandowski",
            "Zieliński", "Szymański", "Woźniak", "Dąbrowski", "Kozłowski", "Jankowski", "Mazur",
            "Wojciechowski", "Kwiatkowski", "Krawczyk", "Kaczmarek", "Piotrowski", "Grabowski"
        ];
    };
    case "greek": {
        _faces = [
            "GreekHead_A3_13","GreekHead_A3_01","GreekHead_A3_02","GreekHead_A3_07","GreekHead_A3_03","GreekHead_A3_04",
            "GreekHead_A3_14","GreekHead_A3_05","GreekHead_A3_11","GreekHead_A3_06","GreekHead_A3_08","GreekHead_A3_12",
            "Mavros","GreekHead_A3_09"
        ];
        _speakers = ["Male01GRE","Male02GRE","Male03GRE","Male04GRE","Male05GRE","Male06GRE"];
        _firstNames = [
            "Giorgos", "Dimitris", "Nikos", "Kostas", "Vasilis", "Ioannis", "Panagiotis", "Christos",
            "Athanasios", "Stavros", "Spyros", "Andreas", "Michalis", "Petros", "Alexandros"
        ];
        _surnames = [
            "Papadopoulos", "Nikolaidis", "Georgiou", "Papanikolaou", "Christodoulou", "Ioannidis",
            "Vasileiou", "Panagiotopoulos", "Konstantinou", "Stavrou", "Spyrou", "Andreou", "Michailidis",
            "Petrou", "Alexandrou"
        ];
    };
    case "african": {
        _faces = [
            "Barklem","TanoanHead_A3_03","TanoanHead_A3_04","AfricanHead_02","AfricanHead_03","TanoanHead_A3_05",
            "TanoanHead_A3_07","TanoanHead_A3_01","TanoanHead_A3_06","TanoanHead_A3_08","AfricanHead_01",
            "TanoanHead_A3_02","TanoanHead_A3_09"
        ];
        _speakers = ["Male01FRE","Male02FRE","Male03FRE"];
        _firstNames = [
            "Kwame", "Abdul", "Samuel", "Emeka", "Chinedu", "Kofi", "Amadou", "Moussa", "Omar", "Bakari",
            "Tunde", "Juma", "Sefu", "Babatunde", "Ibrahim"
        ];
        _surnames = [
            "Okafor", "Mensah", "Diallo", "Abebe", "Ndlovu", "Kamara", "Adebayo", "Ngugi", "Chukwu", "Mugabe",
            "Sow", "Mwangi", "Banda", "Kone", "Agyeman"
        ];
    };
    case "asian": {
        _faces = ["AsianHead_A3_01","AsianHead_A3_07","AsianHead_A3_03","AsianHead_A3_04","AsianHead_A3_02","AsianHead_A3_05"];
        _speakers = ["Male01CHI","Male02CHI","Male03CHI"];
        _firstNames = [
            "Wei", "Li", "Chen", "Hiroshi", "Takashi", "Minh", "Sang", "Jin", "Yong", "Daisuke",
            "Akira", "Kenji", "Bao", "Tuan", "Jun"
        ];
        _surnames = [
            "Wang", "Zhang", "Liu", "Chen", "Yang", "Huang", "Nguyen", "Kim", "Pham", "Lin",
            "Tanaka", "Suzuki", "Yamamoto", "Park", "Lee"
        ];
    };
    case "american": {
        _faces = [
            "WhiteHead_31","Sturrock","WhiteHead_30","WhiteHead_32","WhiteHead_28","WhiteHead_27","WhiteHead_01",
            "WhiteHead_02","WhiteHead_03","WhiteHead_04","WhiteHead_05","WhiteHead_06","WhiteHead_07","WhiteHead_08",
            "WhiteHead_09","WhiteHead_10","WhiteHead_11","WhiteHead_12","WhiteHead_13","WhiteHead_14","WhiteHead_15",
            "WhiteHead_16","WhiteHead_17","WhiteHead_18","WhiteHead_19","WhiteHead_20","WhiteHead_21","WhiteHead_22",
            "WhiteHead_23","WhiteHead_24","WhiteHead_25","WhiteHead_26"
        ];
        _speakers = ["Male01ENG","Male02ENG","Male03ENG","Male04ENG","Male05ENG","Male06ENG","Male07ENG","Male08ENG","Male09ENG","Male010ENG","Male11ENG","Male12ENG"];
        _firstNames = [
            "James", "John", "Robert", "Michael", "William", "David", "Richard", "Joseph", "Thomas", "Charles",
            "Christopher", "Daniel", "Matthew", "Anthony", "Mark"
        ];
        _surnames = [
            "Smith", "Johnson", "Williams", "Brown", "Jones", "Garcia", "Miller", "Davis", "Rodriguez", "Martinez",
            "Hernandez", "Lopez", "Gonzalez", "Wilson", "Anderson"
        ];
    };
    case "english": {
        _faces = [
            "WhiteHead_31","Sturrock","WhiteHead_30","WhiteHead_32","WhiteHead_28","WhiteHead_27","WhiteHead_01",
            "WhiteHead_02","WhiteHead_03","WhiteHead_04","WhiteHead_05","WhiteHead_06","WhiteHead_07","WhiteHead_08",
            "WhiteHead_09","WhiteHead_10","WhiteHead_11","WhiteHead_12","WhiteHead_13","WhiteHead_14","WhiteHead_15",
            "WhiteHead_16","WhiteHead_17","WhiteHead_18","WhiteHead_19","WhiteHead_20","WhiteHead_21","WhiteHead_22",
            "WhiteHead_23","WhiteHead_24","WhiteHead_25","WhiteHead_26"
        ];
        _speakers = ["Male01ENGB","Male02ENGB","Male03ENGB","Male04ENGB","Male05ENGB"];
        _firstNames = [
            "Oliver", "George", "Harry", "Jack", "Jacob", "Noah", "Charlie", "Muhammad", "Thomas", "Oscar",
            "William", "James", "Henry", "Leo", "Alfie"
        ];
        _surnames = [
            "Smith", "Jones", "Taylor", "Brown", "Williams", "Wilson", "Johnson", "Davies", "Patel", "Wright",
            "Walker", "White", "Edwards", "Green", "Hall"
        ];
    };
    case "french": {
        _faces = [
            "WhiteHead_31","Sturrock","WhiteHead_30","WhiteHead_32","WhiteHead_28","WhiteHead_27","WhiteHead_01",
            "WhiteHead_02","WhiteHead_03","WhiteHead_04","WhiteHead_05","WhiteHead_06","WhiteHead_07","WhiteHead_08",
            "WhiteHead_09","WhiteHead_10","WhiteHead_11","WhiteHead_12","WhiteHead_13","WhiteHead_14","WhiteHead_15",
            "WhiteHead_16","WhiteHead_17","WhiteHead_18","WhiteHead_19","WhiteHead_20","WhiteHead_21","WhiteHead_22",
            "WhiteHead_23","WhiteHead_24","WhiteHead_25","WhiteHead_26"
        ];
        _speakers = ["Male01FRE","Male02FRE","Male03FRE","Male01ENGFRE","Male02ENGFRE"];
        _firstNames = [
            "Jean", "Michel", "Pierre", "Alain", "Philippe", "Louis", "Henri", "Jacques", "Bernard", "Claude",
            "Paul", "Luc", "Marc", "André", "François"
        ];
        _surnames = [
            "Martin", "Bernard", "Dubois", "Thomas", "Robert", "Richard", "Petit", "Durand", "Leroy", "Moreau",
            "Simon", "Laurent", "Lefebvre", "Michel", "Garcia"
        ];
    };
    case "middleeast": {
        _faces = ["PersianHead_A3_01","PersianHead_A3_02","PersianHead_A3_03"];
        _speakers = ["Male01PER","Male02PER","Male03PER"];
        _firstNames = [
            "Ahmed", "Mohammed", "Ali", "Omar", "Hassan", "Youssef", "Khaled", "Ibrahim", "Sami", "Tariq",
            "Faisal", "Karim", "Samir", "Bilal", "Rashid"
        ];
        _surnames = [
            "Al-Farsi", "Al-Masri", "Al-Hassan", "Al-Khalifa", "Al-Sayed", "Al-Amin", "Al-Rashid", "Al-Hakim", "Al-Nasser", "Al-Sabah",
            "Al-Mansour", "Al-Ahmad", "Al-Hashim", "Al-Jabari", "Al-Karim"
        ];
    };
    case "russian": {
        _faces = ["RussianHead_1","RussianHead_2","RussianHead_3","RussianHead_4","RussianHead_5","RussianHead_4","RussianHead_1"];
        _speakers = ["Male01RUS","Male02RUS","Male03RUS","RHS_Male01RUS","RHS_Male02RUS","RHS_Male03RUS","RHS_Male04RUS","RHS_Male052US"];
        _firstNames = [
            "Ivan", "Dmitry", "Alexei", "Sergey", "Vladimir", "Nikolai", "Andrei", "Mikhail", "Yuri", "Pavel",
            "Viktor", "Oleg", "Igor", "Roman", "Maxim"
        ];
        _surnames = [
            "Ivanov", "Petrov", "Sidorov", "Smirnov", "Kuznetsov", "Popov", "Vasiliev", "Mikhailov", "Fedorov", "Morozov",
            "Volkov", "Solovyov", "Lebedev", "Semenov", "Egorov"
        ];
    };
    default {
        "[FaceSwap] No face type found - Default" spawn OKS_fnc_LogDebug;
    };
};

if(count _faces == 0 || count _speakers == 0) exitWith {
    if(_faceswapDebug) then {
        format ["[FaceSwap] Exited - No faces or speakers found for type: %1", (toupper _faceType)] spawn OKS_fnc_LogDebug;
    };
};

private _face = selectRandom _faces;
private _voice = selectRandom _speakers;
private _firstName = selectRandom _firstNames;
private _surname = selectRandom _surnames;
private _name = format ["%1 %2", _firstName, _surname];

[_unit,_voice] remoteExec ["setSpeaker", 0];
[_unit,_face] remoteExec ["setFace", 0];
[_unit,""] remoteExec ["setNameSound",0];
[_unit,_name] remoteExec ["setUnitName",0];

if(_faceswapDebug) then {
    format ["[FaceSwap] %2 Executed on %1",_unit,(toupper _faceType)] spawn OKS_fnc_LogDebug;
};