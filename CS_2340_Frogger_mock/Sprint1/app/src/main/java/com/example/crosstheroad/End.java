package com.example.crosstheroad;

import android.graphics.Bitmap;

/**
 * This class represents the End tile.
 * Attributes: done (boolean) -
 *            signifies end of the game.
 * Methods:
 *  -Constructor(int x, int y, int w, int h, Bitmap hm)
 *  - getDone() : boolean
 *  - setDone(boolean) : void
 */
public class End extends Tile {

    public Boolean getDone() {
        return done;
    }

    public void setDone(Boolean done) {
        this.done = done;
    }

    private Boolean done;
    public End(int x, int y, int w, int h, Bitmap bm) {
        super(x, y, w, h, bm, Type.END, 300);
        this.done = false;
    }
}
