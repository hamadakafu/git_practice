#ifndef STUDENT_H
#define STUDENT_H

typedef struct Student_tag {
    int id;
    char name[256];
} Student;

void print_student(Student s);

#endif
