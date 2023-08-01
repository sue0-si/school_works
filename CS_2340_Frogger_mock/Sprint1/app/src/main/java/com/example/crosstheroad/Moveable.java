package com.example.crosstheroad;
import android.graphics.Bitmap;

/**
 * Moveable - provides identifier for movable objects.
 * Attributes:
 *     int vel - not allowed to set
 *     int W - not allowed to set
 * Methods:
 *  getVel(void) : int
 *  getW(void) : int
 *  move(void) : void
 *
 */
public class Moveable extends Entity {

    public int getVel() {
        return vel;
    }
    private final int vel;
    private final int w;

    public Moveable(int x, int y, int w, int h, Bitmap bm, int vel) {
        super(x, y, w, h, bm);
        this.vel = vel;
        this.w = w;
    }

    public void move() {
        setLeft(getLeft() + getVel());
        setRight(getRight() + getVel());
        if ((vel < 0) && (getRight() < 0)) {
            setLeft(1400);
            setRight(getLeft() + w);
        } else if ((vel > 0) && (getLeft() > 1400)) {
            setRight(0);
            setLeft(-w);
        }
    }
}
