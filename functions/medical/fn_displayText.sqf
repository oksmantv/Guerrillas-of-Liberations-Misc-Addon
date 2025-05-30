params ["_caller","_target","_bodyPart","_action"];
if (_bodyPart == "") then {
	[[("<t size='1.3'>" + "Someone" + " is " + _action + " you" + "</t>"), "PLAIN DOWN", -1, true, true]] remoteExec ["titleText", _target];
} else {
	if (_action in ["CheckPulse","CheckBloodPressure","PersonalAidKit","Diagnose"]) then {
		[[("<t size='1.3'>" + (name _caller) + " is " + _action + " you" + "</t>"), "PLAIN DOWN", -1, true, true]] remoteExec ["titleText", _target];
	} else {
		[[("<t size='1.3'>" + (name _caller) + " is " + _action + " your " + _bodyPart + "</t>"), "PLAIN DOWN", -1, true, true]] remoteExec ["titleText", _target];
	};
};