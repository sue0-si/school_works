#ifndef MAIN_H
#define MAIN_H

#include "gba.h"

// TODO: Create any necessary structs
struct playerState {
    int row;
    int column;
    int width;
    int height;
};

struct objectState {
    int row;
    int column;
    int width;
    int height;
};

/*
* For example, for a Snake game, one could be:
*
* struct snake {
*   int heading;
*   int length;
*   int row;
*   int col;
* };
*
* Example of a struct to hold state machine data:
*
* struct state {
*   int currentState;
*   int nextState;
* };
*
*/
void startScreen(void);
int collide(struct playerState *player, struct objectState *object);
void defaultPlayer(struct playerState *player);
void defaultObject(struct objectState *object);
void movePlayer(struct playerState *player, u32 currentButtons);

#endif
