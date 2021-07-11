///@function rousr_bin_pack_defintiions()
///@desc definitions and enums for rousr bin packer
///@extensionizer { "export": false, "docs": false }
function rousr_bin_pack_definitions() {
#region General Definitions
	enum ERousrBinRect {
		Min = 0,
		Max,
	
		Num
	};
#endregion

#region Lazy Bin Packing defs
	enum ERousrLazyBin {
		Rects = 0,
		Width,
		Height,
	
		Num
	};

#endregion


}
