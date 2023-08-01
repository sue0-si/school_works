package com.example.crosstheroad;

import android.graphics.Bitmap;

/**
 * Defines the Player.
 * Attributes:
 *      variables to define player start pos:
 *          int startX
 *          int startY
 *          int startW - width
 *          int startH - height
 * Method:
 *     resetPos() : void
 *          resets player position on screen.
 */
public class Player extends Entity {
    private final int startX;
    private final int startY;
    private final int startW;
    private final int startH;
    Player(int x, int y, int w, int h, Bitmap avatar) {
        super(x, y, w, h, avatar);
        startX = x;
        startY = y;
        startW = w;
        startH = h;
    }

    public void resetPos() {
        setLeft(startX);
        setRight(startX + startW);
        setTop(startY);
        setBottom(startY + startH);
    }
}
