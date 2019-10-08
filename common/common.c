#include "common.h"
#include <string.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <dirent.h>

int getAllTestcase(char filename[][256]){
    DIR *dir;
	// dir = (DIR*)malloc(sizeof(DIR));
    struct dirent *ent;
	//len = offsetof(struct dirent, d_name) + pathconf("./testcase/", _PC_NAME_MAX) + 1;
  	//ent = malloc(len);
    int files_count = 0;
    if ((dir = opendir ("./testcase/")) != NULL) {
        while((ent = readdir(dir)) != NULL && strlen(ent->d_name) > 0){
            //tmp = ent->d_name;
            if(ent->d_name[0]  == '.'){
				continue;
			}
            printf("reading file:%s\n", ent->d_name);
            strcpy(filename[files_count++], ent->d_name);
            //printf("%d %s\n", ++count, tmp.substr(0, tmp.rfind('.')).c_str());
        }
        closedir(dir);
		//free(ent);
    } else{
        // printf("open file failed !");
        // return exit(1);
    }
	return files_count;
}
