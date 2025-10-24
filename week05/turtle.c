#include <stdio.h>

/* What the turtle can do */
enum command {
    ROTATE_CLOCKWISE,
    MOVE_FORWARD,
    PRINT_STATE,
    NOOP,
};

enum orientation {
    NORTH, EAST, SOUTH, WEST
};

/* Where the turtle is, and which way it is facing */
struct turtle {
    int x, y;
    enum orientation orientation;
};


/*
This is the main exercise. The procedure run_command receives a command command and a pointer to a turtle turtle. The effect of that command being run should be directly applied to the underlying struct turtle. Now implement the procedure.
*/
void run_command(enum command command, struct turtle *turtle) {
    switch (command) {
        case ROTATE_CLOCKWISE:
            turtle->orientation = (enum orientation)((turtle->orientation + 1) % 4);
            break;
        case MOVE_FORWARD:
            switch (turtle->orientation) {
                case NORTH:
                    turtle->y++;
                    break;
                case SOUTH:
                    turtle->y--;
                    break;
                case WEST:
                    turtle->x--;
                    break;
                case EAST:
                    turtle->x++;
                    break;
            }
            break;
        case PRINT_STATE:
            switch (turtle->orientation) {
                case NORTH:
                    printf("x: %d, y: %d, orientation: %s\n", turtle->x, turtle->y, "NORTH");
                    break;
                case SOUTH:
                    printf("x: %d, y: %d, orientation: %s\n", turtle->x, turtle->y, "SOUTH");
                    break;
                case WEST:
                    printf("x: %d, y: %d, orientation: %s\n", turtle->x, turtle->y, "WEST");
                    break;
                case EAST:
                    printf("x: %d, y: %d, orientation: %s\n", turtle->x, turtle->y, "EAST");
                    break;
            }
            break;
        case NOOP:
            break;
    }
}

void run_program(int n, enum command program[n], struct turtle *turtle) {
    for (int i = 0; i < n; i++)
    {
        run_command(program[i], turtle);
    }
    
}

int main(int argc, char *argv[]) {
    struct turtle turtle = {0, 0, NORTH};
    enum command program[] = {
    MOVE_FORWARD, ROTATE_CLOCKWISE, ROTATE_CLOCKWISE, ROTATE_CLOCKWISE, ROTATE_CLOCKWISE, ROTATE_CLOCKWISE, MOVE_FORWARD, PRINT_STATE
    };
    run_program(8, program, &turtle);
    return 0;
}
