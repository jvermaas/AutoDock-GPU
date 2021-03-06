#ifndef FILELIST_HPP
#define FILELIST_HPP

#include <stdio.h>
#include <stdlib.h>
#include <string>
#include <vector>

class FileList{

	public:

	bool used;
	bool preload_maps;
	bool maps_are_loaded;
	char filename [128];
	int nfiles;
	std::vector<std::string> resnames;
	std::vector<std::string> fld_files;
	std::vector<std::string> ligand_files;

	// Default to unused, with 1 file
	FileList() : used( false ), nfiles( 1 ), preload_maps( false ), maps_are_loaded( false ) {}
};

#endif
