// Disable RHS barrel heat-shimmer particle effects globally.
// lifeTime = 0 makes particles expire immediately — visually silent.
// Affects any weapon using RHSUSF_BarrelRefract or RHSUSF_BarrelRefractHeavy.
class CfgCloudlets {
	class RHSUSF_BarrelRefract {
		class RHS_HeatHaze {
			lifeTime = 0;
		};
	};
	class RHSUSF_BarrelRefractHeavy {
		class RHS_HeatHaze1 {
			lifeTime = 0;
		};
	};
};
