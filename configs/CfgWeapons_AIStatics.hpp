class MGun;
class LMG_RCWS : MGun {
	aiDispersionCoefX = 7;
	aiDispersionCoefY = 6;
	class manual : MGun {};
	class close : manual {
		aiBurstTerminable = 0;
		aiDispersionCoefX = 8.0;
		aiDispersionCoefY = 8.0;
	};
	class short : close {
		aiBurstTerminable = 0;
	};
	class medium : close {
		aiBurstTerminable = 0;
	};
	class far : close {
		aiBurstTerminable = 0;
	};
};
class HMG_127 : LMG_RCWS {
	class manual : MGun {};
	class close : manual {
		aiBurstTerminable = 0;
		aiDispersionCoefX = 8.0;
		aiDispersionCoefY = 8.0;
	};
	class short : close {
		aiBurstTerminable = 0;
	};      
	class medium : close {
		aiBurstTerminable = 0;
	}; 
	class far : close {
		aiBurstTerminable = 0;
	};
};
class LMG_coax : LMG_RCWS {
	class manual : MGun {};
	class close : manual {
		aiBurstTerminable = 0;
		aiDispersionCoefX = 8.0;
		aiDispersionCoefY = 8.0;
	};
	class short : close {
		aiBurstTerminable = 0;
	};     
	class medium : close {
		aiBurstTerminable = 0;
	}; 
	class far : close {
		aiBurstTerminable = 0;
	};
};
class cannonCore;
class autocannon_Base_F: CannonCore {
	aiDispersionCoefX = 8;
	aiDispersionCoefY = 6;
	//cursor = "EmptyCursor";
	//cursorAim = "cannon";
};
