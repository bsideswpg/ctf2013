#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[])
{
	char *flag = "b4ck_dat_asm_up";

	if (argc == 1) {
		puts("Yo, gimme something!");
		exit(1);
	}

	if (argc > 2) {
		puts("Yo, you're deluging me!");
		exit(1);
	}

	if (!strcmp(argv[1], flag))
		puts("Yo, you're legit!");
	else
		puts("Dawg, you're *lame*!");

	return 0;
}
