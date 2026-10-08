CREATE DATABASE COLLEGEDB;
USE COLLEGEDB;
ALTER TABLE student ADD department_id NUMBER;

UPDATE student 
SET department_id = 10 
WHERE student_id = 101;
COMMIT;

SET SERVEROUTPUT ON;

DECLARE
    CURSOR c_students IS
        SELECT student_id, first_name || ' ' || last_name AS student_name, department_id
        FROM student;

    v_student_rec c_students%ROWTYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE(RPAD('STUDENT ID', 12) || RPAD('STUDENT NAME', 25) || RPAD('DEPT ID', 10));
    DBMS_OUTPUT.PUT_LINE(RPAD('-', 10, '-') || '  ' || RPAD('-', 23, '-') || '  ' || RPAD('-', 8, '-'));

    OPEN c_students;

    LOOP
        FETCH c_students INTO v_student_rec;
        EXIT WHEN c_students%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(
            RPAD(TO_CHAR(v_student_rec.student_id), 12) || 
            RPAD(v_student_rec.student_name, 25) || 
            RPAD(NVL(TO_CHAR(v_student_rec.department_id), 'N/A'), 10)
        );
    END LOOP;

    CLOSE c_students;

EXCEPTION
    WHEN OTHERS THEN

        IF c_students%ISOPEN THEN
            CLOSE c_students;
        END IF;
        DBMS_OUTPUT.PUT_LINE('An unexpected error occurred: ' || SQLERRM);
END;
/
