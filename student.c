#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "student.h"

void print_student(Student s) {
    printf("%d: %s\n", s.id, s.name);
}

Student *new_student() {
    Student *s = malloc(sizeof(Student));
    if (s == NULL) {
        fprintf(stderr, "error: can't malloc Student in new_student.\n");
        exit(1);
    }
    s->id = 0;
    strcpy(s->name, "unknown");
    return s;
}

int set_params(Student *s, int id, char *name) {
    if (sizeof(*name) >= 256) {
        fprintf(stderr, "error: name is too long in set_params.\n");
        return 1;
    } else {
        s->id = id;
        strcpy(s->name, name);
        return 0;
    }
}
