//#define LOWMEMORYMODE //uncomment this to load centcom and runtime station and thats it.

#include "..\maps\map_files\generic\CentCom.dmm"

#ifndef LOWMEMORYMODE
	#ifdef CIBUILDING
		#include "..\maps\templates.dm"
	#endif
#endif
