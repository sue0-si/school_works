package com.example.crosstheroad;

import android.graphics.Bitmap;

/**
 * Acts as an all encompassing class for entity objects.
 * Attributes:
 *      int left
 *      int right
 *      int top
 *      int bottom
 *      Bitmap bm
 * Mainly provides setter/getter methods
 * Provides a constructor.
 */
public class Entity {

    public int getLeft() {
        return left;
    }

    public void setLeft(int left) {
        this.left = left;
    }

    private int left;

    public int getRight() {
        return right;
    }

    public void setRight(int right) {
        this.right = right;
    }

    public int getTop() {
        return top;
    }

    public void setTop(int top) {
        this.top = top;
    }

    public int getBottom() {
        return bottom;
    }

    public void setBottom(int bottom) {
        this.bottom = bottom;
    }

    private int right;
    private int top;
    private int bottom;


    public Bitmap getBm() {
        return bm;
    }

    private Bitmap bm;

    Entity(int x, int y, int w, int h, Bitmap bm) {
        left = x;
        right = x + w;
        top = y;
        bottom = y + h;
        this.bm = bm;
    }
}
