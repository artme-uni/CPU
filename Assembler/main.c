#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define SIZE 100

int main(void)
{
    FILE *in1 = fopen("cmd.txt", "r");
    FILE *out1 = fopen("rom.txt", "w");

    char cmd[SIZE];
    int num;
    int count = 0;

    while (1)
    {
        int estr = fscanf(in1, "%s %d\n", cmd, &num);

        if (estr == EOF)
        {
            break;
        }
        else
        {
            count++;
        }

        printf("%s %x -> ", cmd, num);

        if (strcmp(cmd, "\n") == 0)
            continue;

        if (strcmp(cmd, "LOAD") == 0)
        {
            fprintf(out1, "00");
            printf("00");
        }
        else if (strcmp(cmd, "+") == 0)
        {
            fprintf(out1, "01");
            printf("01");
        }
        else if (strcmp(cmd, "-") == 0)
        {
            fprintf(out1, "02");
            printf("02");
        }
        else if (strcmp(cmd, "/") == 0)
        {
            fprintf(out1, "03");
            printf("03");
        }
        else if (strcmp(cmd, "*") == 0)
        {
            fprintf(out1, "04");
            printf("04");
        }
        else if (strcmp(cmd, "OUT") == 0)
        {
            fprintf(out1, "0500\n");
            printf("0500\n");
            continue;
        }
        else if (strcmp(cmd, "INP") == 0)
        {
            fprintf(out1, "0600\n");
            printf("0600\n");
            continue;
        }
        else if (strcmp(cmd, "SAVE") == 0)
        {
            fprintf(out1, "07");
            printf("07");
        }
        else if (strcmp(cmd, "SCAN") == 0)
        {
            fprintf(out1, "08");
            printf("08");
        }
        else if (strcmp(cmd, "++") == 0)
        {
            fprintf(out1, "0900\n");
            printf("0900\n");
            continue;
        }
        else if (strcmp(cmd, "--") == 0)
        {
            fprintf(out1, "0a00\n");
            printf("0a00\n");
            continue;
        }
        else if (strcmp(cmd, "SHIFT") == 0)
        {
            fprintf(out1, "0b00\n");
            printf("0b00\n");
            continue;
        }
        else if (strcmp(cmd, "SKIP") == 0)
        {
            fprintf(out1, "0c00\n");
            printf("0c00\n");
            continue;
        }
        else printf("syntax error\n");

        printf("%02x\n", num);
        fprintf(out1, "%02x\n", num);
    }

    for (int i = 0; i != 255 - count; i++)
    {
        fprintf(out1, "0000\n");
    }
    fprintf(out1, "0000");

    fclose(in1);
    fclose(out1);

    return 0;
}
